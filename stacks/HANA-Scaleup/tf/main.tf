provider "google" {}

module "gcp_sap_hana" {
  source                     = "../../../terraform/modules/hana"
  subnetwork                 = var.subnetwork
  source_image_family        = var.source_image_family
  source_image_project       = var.source_image_project
  instance_name              = var.sap_hana_instance_name
  instance_type              = var.sap_hana_instance_type
  subnetwork_project         = local.subnetwork_project
  project_id                 = var.project_id
  zone                       = var.zone
  service_account_email      = var.sap_hana_service_account_email
  boot_disk_type             = var.sap_hana_boot_disk_type
  boot_disk_size             = var.sap_hana_boot_disk_size
  autodelete_disk            = var.sap_hana_autodelete_boot_disk
  pd_ssd_size                = local.pd_ssd_size
  pd_hdd_size                = local.pd_hdd_size
  sap_install_files_bucket   = var.sap_hana_install_files_bucket
  sap_hostagent_rpm_file_name    = var.sap_hostagent_rpm_file_name
  sap_hana_bundle_file_name  = var.sap_hana_bundle_file_name
  sap_hana_sapcar_file_name  = var.sap_hana_sapcar_file_name
  network_tags               = var.sap_hana_network_tags
  use_public_ip              = var.sap_hana_use_public_ip
  gce_ssh_user               = var.gce_ssh_user
  gce_ssh_pub_key_file       = var.gce_ssh_pub_key_file
}
