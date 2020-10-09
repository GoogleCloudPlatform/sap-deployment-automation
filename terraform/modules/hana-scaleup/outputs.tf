output "project_id" {
  value = var.project_id
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.sap_hana_scaleup.instances_self_links
}

output "address" {
  value = google_compute_address.gcp_sap_hana_intip.address
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

output "instance_attached_disks_data" {
  value = google_compute_attached_disk.data.device_name
}

output "instance_attached_disks_backup" {
  value = google_compute_attached_disk.backup.*.device_name
}

output "instance_group_link" {
  value = length(module.sap_hana_scaleup.instances_self_links) != 0 ? element(tolist(module.sap_hana_scaleup.instances_self_links), 0) : ""
}

output "instance_name" {
  value = length(module.sap_hana_scaleup.instances_self_links) != 0 ? element(split("/", element(tolist(module.sap_hana_scaleup.instances_self_links), 0)), 10) : ""
}

output "instance_ip" {
  value = google_compute_address.gcp_sap_hana_intip.address
}

output "inventory" {
  value = { hana = [google_compute_address.gcp_sap_hana_intip.address] }
}
