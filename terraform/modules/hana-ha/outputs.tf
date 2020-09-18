output "project_id" {
  value = var.project_id
}

output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone_a" {
  description = "Primary Compute Engine instance deployment zone"
  value       = var.zone_a
}

output "zone_b" {
  description = "Secondary Compute Engine instance deployment zone"
  value       = var.zone_b
}

output "instances_self_links_primary" {
  description = "List of self-links for primary compute instances"
  value       = module.sap_hana_umig_primary.instances_self_links
}

output "instances_self_links_secondary" {
  description = "List of self-links for secondary compute instances"
  value       = module.sap_hana_umig_secondary.instances_self_links
}

output "address_primary" {
  value = google_compute_address.gcp_sap_hana_intip_primary.address
}

output "address_secondary" {
  value = google_compute_address.gcp_sap_hana_intip_secondary.address
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
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "primary_attached_disks_data" {
  value = google_compute_attached_disk.primary_data.device_name
}

output "primary_attached_disks_backup" {
  value = google_compute_attached_disk.primary_backup.*.device_name
}

output "secondary_attached_disks_data" {
  value = google_compute_attached_disk.secondary_data.device_name
}

output "secondary_attached_disks_backup" {
  value = google_compute_attached_disk.secondary_backup.*.device_name
}

output "primary_umig_group_link" {
  value = length(module.sap_hana_umig_primary.self_links) != 0 ? element(tolist(module.sap_hana_umig_primary.self_links), 0) : ""
}

output "secondary_umig_group_link" {
  value = length(module.sap_hana_umig_secondary.self_links) != 0 ? element(tolist(module.sap_hana_umig_secondary.self_links), 0) : ""
}

output "primary_instance_name" {
  value = length(module.sap_hana_umig_primary.instances_self_links) != 0 ? element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10) : ""
}

output "secondary_instance_name" {
  value = length(module.sap_hana_umig_secondary.instances_self_links) != 0 ? element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10) : ""
}

output "primary_instance_ip" {
  value = google_compute_address.gcp_sap_hana_intip_primary.address
}

output "secondary_instance_ip" {
  value = google_compute_address.gcp_sap_hana_intip_secondary.address
}

output "hana_ilb_ip" {
  value = module.sap_hana_ilb.ip_address
}

output "health_check_port" {
  value = local.health_check["port"]
}

output "inventory" {
  value = { hana = [google_compute_address.gcp_sap_hana_intip_primary.address, google_compute_address.gcp_sap_hana_intip_secondary.address] }
}
