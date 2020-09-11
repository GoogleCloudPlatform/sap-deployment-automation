output "sap_hana_sid" {
  description = "SAP Hana SID user"
  value       = var.sap_hana_sid
}

output "hana_instance_name" {
  description = "Name of HANA instance."
  value       = module.gcp_hana.instance_name
}

output "nw_instance_name" {
  description = "Name of NetWeaver instance."
  value       = module.gcp_netweaver.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "self_link" {
  value = module.gcp_hana.self_link
}

output "hana_address" {
  value = module.gcp_hana.address
}

output "nw_address" {
  value = module.gcp_netweaver.instance_internal_ip
}

output "public_ip" {
  value = module.gcp_hana.public_ip
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
