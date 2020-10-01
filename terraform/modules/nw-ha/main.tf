provider "google" {}

module "sap_s4hana_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = var.region
  metadata = {
    instanceName           = var.instance_name
    instanceType           = var.instance_type
    post_deployment_script = var.post_deployment_script
    subnetwork             = var.subnetwork
    usrsapSize             = var.usr_sap_size
    swapSize               = var.swap_size
    sap_deployment_debug   = var.sap_deployment_debug
    ssh-keys               = "${var.ssh_user}:${file("${var.public_key_path}")}"
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
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

resource "google_compute_address" "gcp_sap_s4hana_intip_primary" {
  name         = "${var.instance_name}-${var.address_name}"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = var.region
  project      = var.subnetwork_project
  purpose      = "GCE_ENDPOINT"
}

module "sap_s4hana_umig" {
  source             = "../terraform-google-vm//modules/umig"
  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  static_ips         = [google_compute_address.gcp_sap_s4hana_intip_primary.address]
  hostname           = substr("${var.instance_name}", 0, 12) # Limit length to 12 charecters
  num_instances      = var.target_size
  instance_template  = module.sap_s4hana_template.self_link
}

resource "google_compute_disk" "gcp_nw_pd_0" {
  count   = var.usr_sap_size > 0 ? 1 : 0
  project = var.project_id
  name    = "${var.instance_name}-nw-0"
  type    = "pd-ssd"
  zone    = var.zone
  size    = var.usr_sap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_nw_pd_1" {
  count   = var.swap_size > 0 ? 1 : 0
  project = var.project_id
  name    = "${var.instance_name}-nw-1"
  type    = "pd-ssd"
  zone    = var.zone
  size    = var.swap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_0" {
  count       = var.usr_sap_size > 0 ? 1 : 0
  disk        = element(google_compute_disk.gcp_nw_pd_0.*.self_link, count.index)
  instance    = element(split("/", element(tolist(module.sap_s4hana_umig.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_s4hana_umig.instances_self_links), 0)), 10)}-usrsap"
  project     = var.project_id
  zone        = var.zone
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_1" {
  count       = var.swap_size > 0 ? 1 : 0
  disk        = element(google_compute_disk.gcp_nw_pd_1.*.self_link, count.index)
  instance    = element(split("/", element(tolist(module.sap_s4hana_umig.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_s4hana_umig.instances_self_links), 0)), 10)}-swap"
  project     = var.project_id
  zone        = var.zone
}
