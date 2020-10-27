locals {
  access_config         = var.assign_public_ip ? [{
    nat_ip              = null
    network_tier        = "PREMIUM"
  }] : []
  awx_tag               = "awx"
  iap_range             = "35.235.240.0/20"
  network_parts         = split("/", data.google_compute_subnetwork.subnetwork.network)
  network               = element(local.network_parts, length(local.network_parts) - 1)
  subnetwork_project_id = var.subnetwork_project_id != "" ? var.subnetwork_project_id : var.project_id
  tags                  = toset(concat([local.awx_tag], var.tags))
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = local.subnetwork_project_id
  region  = var.region
}

resource "google_compute_firewall" "allow_iap" {
  name          = "${var.instance_name}-allow-iap"
  network       = local.network
  allow {
    protocol    = "TCP"
    ports       = ["80"]
  }
  project       = local.subnetwork_project_id
  source_ranges = [local.iap_range]
  target_tags   = [local.awx_tag]
}

resource "google_project_iam_member" "shared_vpc_project_iam_member" {
  count   = local.subnetwork_project_id == var.project_id ? 0 : 1

  project = var.subnetwork_project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${module.service_account.email}"
}

module "service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "= 3.0.1"

  project_id    = var.project_id
  names         = [var.instance_name]
  project_roles = [
    "${var.project_id}=>roles/compute.instanceAdmin",
    "${var.project_id}=>roles/compute.instanceAdmin.v1",
    "${var.project_id}=>roles/compute.networkAdmin",
    "${var.project_id}=>roles/compute.securityAdmin",
    "${var.project_id}=>roles/compute.storageAdmin",
    "${var.project_id}=>roles/storage.admin",
    "${var.project_id}=>roles/iam.serviceAccountUser",
    "${var.project_id}=>roles/servicenetworking.networksAdmin",
  ]
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "5.1.0"

  access_config        = local.access_config
  machine_type         = var.machine_type
  name_prefix          = var.instance_name
  project_id           = var.project_id
  region               = var.region
  service_account      = {
    email              = module.service_account.email,
    scopes             = ["cloud-platform"]
  }
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project_id
  tags                 = local.tags
}

module "compute_instance" {
  source             = "terraform-google-modules/vm/google//modules/compute_instance"
  version            = "5.1.0"

  access_config      = local.access_config
  instance_template  = module.instance_template.self_link
  hostname           = var.instance_name
  num_instances      = 1
  region             = var.region
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project_id
}
