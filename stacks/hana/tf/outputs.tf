output "sap_hana_sid" {
  description = "SAP Hana SID user"
  value       = var.sap_hana_sid
}

output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "self_link" {
  value = module.gcp_sap_hana.self_link
}

output "address" {
  value = module.gcp_sap_hana.address
}

output "public_ip" {
  value = module.gcp_sap_hana.public_ip
}

output "hana_data_size" {
  value = local.hana_data_size
}

output "hana_shared_size" {
  value = local.hana_shared_size
}

output "hana_log_size" {
  value = local.hana_log_size
}

output "hana_usr_size" {
  value = local.hana_usr_size
}

output "hana_backup_size" {
  value = local.hana_backup_size
}

output "sap_image_family" {
  value = contains([element(split("-", var.linux_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "sap_install_files_bucket" {
  value = var.sap_install_files_bucket
}

output "sap_hostagent_file_name" {
  value = var.sap_hostagent_file_name
}

output "sap_hana_bundle_file_name" {
  value = var.sap_hana_bundle_file_name
}

output "sap_hana_sapcar_file_name" {
  value = var.sap_hana_sapcar_file_name
}

output "inventory" {
  value = { hana = [module.gcp_sap_hana.address] }
}

output "instance_attached_disks_data" {
  value = module.gcp_sap_hana.instance_attached_disks_data
}

output "instance_attached_disks_backup" {
  value = module.gcp_sap_hana.instance_attached_disks_backup
}
