provider "google" {}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project
}

locals {
  access_config = {
    nat_ip       = google_compute_address.gcp_hana_bastion_ip.address
    network_tier = "PREMIUM"
  }
}

module "hana_bastion_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = local.region

 
  metadata = {
    #windows-startup-script-url = "gs://win-scripts-test/install-sap-hana-logon-v1.ps1"
    windows-startup-script-ps1 = file("${path.module}/install-sap-hana-logon.ps1")
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "sap-win-bastion"
  }

  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project
  tags                 = var.network_tags
  can_ip_forward       = false #true
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  disk_size_gb         = var.boot_disk_size
  disk_type            = var.boot_disk_type
  auto_delete          = var.autodelete_disk
}

resource "google_compute_address" "gcp_hana_bastion_ip" {
  name         = "${var.instance_name}-ip"
  address_type = var.use_public_ip ? "EXTERNAL" : "INTERNAL"
  subnetwork   = var.use_public_ip ? null : "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = var.use_public_ip ? null : "GCE_ENDPOINT"
}


module "hana_bastion" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = var.use_public_ip ? [] : google_compute_address.gcp_hana_bastion_ip.*.address
  hostname           = var.instance_name
  
  access_config      = var.use_public_ip ? [local.access_config] : []

  instance_template  = module.hana_bastion_template.self_link
}
