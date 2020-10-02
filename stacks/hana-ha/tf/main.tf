provider "google" {}

module "hana_ha" {
  source                = "../../../terraform/modules/hana-ha"
  instance_name         = var.instance_name
  instance_type         = var.instance_type
  project_id            = var.project_id
  zone_a                = var.zone_a
  zone_b                = var.zone_b
  gce_ssh_user          = var.gce_ssh_user
  gce_ssh_pub_key_file  = var.gce_ssh_pub_key_file
  service_account_email = var.service_account_email
  network               = var.network
  subnetwork            = var.subnetwork
  subnetwork_project    = local.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  boot_disk_size        = tonumber(var.boot_disk_size)
  boot_disk_type        = var.boot_disk_type
  autodelete_disk       = tobool(var.autodelete_disk)
  network_tags          = yamldecode(var.network_tags)
  target_size           = tonumber(var.target_size)
  pd_kms_key            = var.pd_kms_key
  create_backup_volume  = var.create_backup_volume
}