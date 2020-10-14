output "hana_instance_name" {
  description = "Name of HANA instance."
  value       = module.gcp_hana.instance_name
}

output "hana_data_size" {
  value = module.gcp_hana.hana_data_size
}

output "hana_shared_size" {
  value = module.gcp_hana.hana_shared_size
}

output "hana_log_size" {
  value = module.gcp_hana.hana_log_size
}

output "hana_usr_size" {
  value = module.gcp_hana.hana_usr_size
}

output "hana_backup_size" {
  value = module.gcp_hana.hana_backup_size
}

output "hana_attached_disks_data" {
  value = module.gcp_hana.instance_attached_disks_data
}

output "hana_attached_disks_backup" {
  value = join("", module.gcp_hana.instance_attached_disks_backup)
}

output "inventory" {
  value = {
    "hana" = [module.gcp_hana.address],
    "nw"   = [module.gcp_netweaver.instance_internal_ip],
  }
}

output "nw_instance_name" {
  description = "Name of NetWeaver instance."
  value       = module.gcp_netweaver.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}
