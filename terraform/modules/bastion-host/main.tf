provider "google" {}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project
}

module "hana_bastion_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = local.region

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

  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project
  tags                 = var.network_tags
  can_ip_forward       = true
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  disk_size_gb         = var.boot_disk_size
  disk_type            = var.boot_disk_type
  auto_delete          = var.autodelete_disk
}

resource "google_compute_address" "gcp_hana_bastion_intip" {
  name         = "${var.instance_name}-int"
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

module "hana_bastion" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = google_compute_address.gcp_hana_bastion_intip.*.address
  hostname           = var.instance_name
  instance_template  = module.hana_bastion_template.self_link
}
