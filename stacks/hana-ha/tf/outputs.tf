output "project_id" {
  value = module.hana_ha.project_id
}

output "instance_name" {
  description = "Name of instance"
  value       = module.hana_ha.instance_name
}

output "primary_zone" {
  description = "Primary Compute Engine instance deployment zone"
  value       = module.hana_ha.primary_zone
}

output "secondary_zone" {
  description = "Secondary Compute Engine instance deployment zone"
  value       = module.hana_ha.secondary_zone
}

output "instances_self_links_primary" {
  description = "List of self-links for primary compute instances"
  value       = module.hana_ha.instances_self_links_primary
}

output "instances_self_links_secondary" {
  description = "List of self-links for secondary compute instances"
  value       = module.hana_ha.instances_self_links_secondary
}

output "address_primary" {
  value = module.hana_ha.address_primary
}

output "address_secondary" {
  value = module.hana_ha.address_secondary
}

output "hana_data_size" {
  value = module.hana_ha.hana_data_size
}

output "hana_shared_size" {
  value = module.hana_ha.hana_shared_size
}

output "hana_log_size" {
  value = module.hana_ha.hana_log_size
}

output "hana_usr_size" {
  value = module.hana_ha.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana_ha.hana_backup_size
}

output "sap_image_family" {
  value = module.hana_ha.sap_image_family
}

output "primary_attached_disks_data" {
  value = module.hana_ha.primary_attached_disks_data
}

output "primary_attached_disks_backup" {
  value = module.hana_ha.primary_attached_disks_backup
}

output "secondary_attached_disks_data" {
  value = module.hana_ha.secondary_attached_disks_data
}

output "secondary_attached_disks_backup" {
  value = module.hana_ha.secondary_attached_disks_backup
}

output "primary_umig_group_link" {
  value = module.hana_ha.primary_umig_group_link
}

output "secondary_umig_group_link" {
  value = module.hana_ha.secondary_umig_group_link
}

output "primary_instance_name" {
  value = module.hana_ha.primary_instance_name
}

output "secondary_instance_name" {
  value = module.hana_ha.secondary_instance_name
}

output "primary_instance_ip" {
  value = module.hana_ha.primary_instance_ip
}

output "secondary_instance_ip" {
  value = module.hana_ha.secondary_instance_ip
}

output "hana_ilb_ip" {
  value = module.hana_ha.hana_ilb_ip
}

output "health_check_port" {
  value = module.hana_ha.health_check_port
}

output "inventory" {
  value = module.hana_ha.inventory
}
