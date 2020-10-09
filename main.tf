locals {
  access_config      = var.assign_public_ip ? [{
    nat_ip           = null
    network_tier     = "PREMIUM"
  }] : []

  subnetwork_project_id = var.subnetwork_project_id != "" ? var.subnetwork_project_id : var.project_id
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "3.0.0"

  access_config        = local.access_config
  machine_type         = var.machine_type
  name_prefix          = "${var.instance_name}-instance-template"
  project_id           = var.project_id
  region               = var.region
  service_account      = var.service_account
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project_id
  tags                 = var.tags
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "3.0.0"

  access_config      = local.access_config
  instance_template  = module.instance_template.self_link
  hostname           = var.instance_name
  num_instances      = 1
  region             = var.region
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project_id
}
