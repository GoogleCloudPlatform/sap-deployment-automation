output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.hana_scaleup.instances_self_links
}

output "address" {
  value = module.hana_scaleup.address
}

output "hana_data_size" {
  value = module.hana_scaleup.hana_data_size
}

output "hana_shared_size" {
  value = module.hana_scaleup.hana_shared_size
}

output "hana_log_size" {
  value = module.hana_scaleup.hana_log_size
}

output "hana_usr_size" {
  value = module.hana_scaleup.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana_scaleup.hana_backup_size
}

<<<<<<< HEAD
output "sap_hostagent_rpm_file_name" {
  value = var.sap_hostagent_rpm_file_name
}

output "sap_hana_bundle_file_name" {
  value = var.sap_hana_bundle_file_name
}

output "sap_hana_sapcar_file_name" {
  value = var.sap_hana_sapcar_file_name
=======
output "sap_image_family" {
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
>>>>>>> Refactored hana scaleup code
}

output "inventory" {
  value = { hana = [module.hana_scaleup.address] }
}

output "hana_attached_disks_data" {
  value = module.hana_scaleup.instance_attached_disks_data
}

output "hana_attached_disks_backup" {
  value = module.hana_scaleup.instance_attached_disks_backup
}
