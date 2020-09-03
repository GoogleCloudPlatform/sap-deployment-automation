provider "google" {}

module "sap_hana_template" {
  source       = "git::ssh://balabharat.guduru@googlecloud.corp-partner.google.com@source.developers.google.com:2022/p/albatross-duncanl-sandbox-2/r/terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = var.region

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "hana"
  }

  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  tags               = var.network_tags
  can_ip_forward     = true

  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project

  disk_size_gb = var.boot_disk_size
  disk_type    = var.boot_disk_type
  auto_delete  = var.autodelete_disk
}

resource "google_compute_address" "gcp_sap_hana_intip_master" {
  name         = "${var.instance_name}-int-m"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = var.region
  project      = var.subnetwork_project
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "gcp_sap_hana_intip_worker" {
  name         = "${var.instance_name}-int-w${format("%01d", count.index + 1)}"
  count        = var.instance_count_worker
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = var.region
  project      = var.subnetwork_project
  purpose      = "GCE_ENDPOINT"
}

module "sap_hana_instance_master" {
  source             = "git::ssh://balabharat.guduru@googlecloud.corp-partner.google.com@source.developers.google.com:2022/p/albatross-duncanl-sandbox-2/r/terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip_master.*.address
  hostname           = var.instance_name
  instance_template  = module.sap_hana_template.self_link
}

module "sap_hana_instance_worker" {
  source             = "git::ssh://balabharat.guduru@googlecloud.corp-partner.google.com@source.developers.google.com:2022/p/albatross-duncanl-sandbox-2/r/terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip_worker.*.address
  hostname           = "${var.instance_name}w"
  num_instances      = var.instance_count_worker
  instance_template  = module.sap_hana_template.self_link
}

resource "google_compute_disk" "gcp_sap_hana_data_master" {
  project = var.project_id
  name    = "${var.instance_name}-data"
  type    = "pd-ssd"
  zone    = var.zone
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup_master" {
  project = var.project_id
  name    = "${var.instance_name}-backup"
  count   = tobool(var.create_backup_volume) == true ? 1 : 0
  type    = "pd-standard"
  zone    = var.zone
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_data_worker" {
  project = var.project_id
  name    = "${var.instance_name}w${count.index + 1}-data"
  count   = var.instance_count_worker
  type    = "pd-ssd"
  zone    = var.zone
  size    = local.pd_ssd_size_wor

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "master_data" {
  project     = var.project_id
  zone        = var.zone
  disk        = google_compute_disk.gcp_sap_hana_data_master.id
  instance    = element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)}-data"
  depends_on  = [google_compute_disk.gcp_sap_hana_data_master]
}

resource "google_compute_attached_disk" "master_backup" {
  project     = var.project_id
  zone        = var.zone
  count       = tobool(var.create_backup_volume) == true ? 1 : 0
  disk        = google_compute_disk.gcp_sap_hana_backup_master[0].id
  instance    = element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)}-backup"
  depends_on  = [google_compute_disk.gcp_sap_hana_backup_master]
}

resource "google_compute_attached_disk" "worker_data" {
  project     = var.project_id
  zone        = var.zone
  count       = var.instance_count_worker
  disk        = element(google_compute_disk.gcp_sap_hana_data_worker.*.self_link, count.index + 1)
  instance    = element(split("/", element(element(module.sap_hana_instance_worker.*.instances_self_links, 0), count.index + 1)), 10)
  device_name = "${element(split("/", element(element(module.sap_hana_instance_worker.*.instances_self_links, 0), count.index + 1)), 10)}-data"
}
