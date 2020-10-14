output "hana_instance_name" {
  description = "Name of HANA instance"
  value       = module.hana.instance_name
}

output "ascs_instance_name" {
  description = "Name of Netweaver ASCS instance"
  value       = module.ascs.instance_name
}

output "pas_instance_name" {
  description = "Name of Netweaver PAS instance"
  value       = module.pas.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "ascs_address" {
  description = "instance private IP"
  value       = module.ascs.instance_external_ip
}

output "pas_address" {
  description = "instance private IP"
  value       = module.pas.instance_external_ip
}

output "subnet_cidr" {
  value = data.google_compute_subnetwork.subnetwork.ip_cidr_range
}

output "ascs_private_ip" {
  description = "instance private IP"
  value       = module.ascs.instance_internal_ip
}

output "pas_private_ip" {
  description = "instance private IP"
  value       = module.pas.instance_internal_ip
}

output "nfs_private_ip" {
  description = "instance private IP"
  value       = module.ascs.instance_internal_ip
}

output "hana_data_size" {
  value = module.hana.hana_data_size
}

output "hana_shared_size" {
  value = module.hana.hana_shared_size
}

output "hana_log_size" {
  value = module.hana.hana_log_size
}

output "hana_usr_size" {
  value = module.hana.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana.hana_backup_size
}

output "hana_attached_disks_data" {
  value = module.hana.instance_attached_disks_data
}

output "hana_attached_disks_backup" {
  value = length(module.hana.instance_attached_disks_backup) > 0 ? module.hana.instance_attached_disks_backup[0] : ""
}

output "inventory" {
  value = {
    hana = [module.hana.address],
    ascs = [module.ascs.instance_internal_ip],
    pas  = [module.pas.instance_internal_ip],
    nodes = [
      module.ascs.instance_internal_ip,
      module.pas.instance_internal_ip,
    ],
  }
}
