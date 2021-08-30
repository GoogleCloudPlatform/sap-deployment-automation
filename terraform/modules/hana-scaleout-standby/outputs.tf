output "project_id" {
  value = var.project_id
}

output "instances_self_links_master" {
  value = module.sap_hana_instance_master.instances_self_links
}

output "instances_self_links_worker" {
  value = concat(flatten(module.sap_hana_instance_worker.*.instances_self_links), flatten(module.sap_hana_instance_standby.*.instances_self_links))
}

output "master_instance_name" {
  value = element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)
}

output "worker_instance_names" {
  value       = [
    for link in flatten(module.sap_hana_instance_worker.*.instances_self_links) : split("/", link)[10]
  ]
}

output "address_master" {
  value = google_compute_address.gcp_sap_hana_intip_master.*.address
}

output "address_worker" {
  value = google_compute_address.gcp_sap_hana_intip_worker.*.address
}

output "master_attached_disks_data" {
  value = google_compute_attached_disk.master_data.*.disk
}

output "worker_attached_disks_data" {
  value = google_compute_attached_disk.worker_data.*.disk
}

output "hana_data_size" {
  value = local.hana_data_size
}

output "hana_log_size" {
  value = local.hana_log_size
}

output "hana_usr_size" {
  value = local.hana_usr_size
}

output "inventory" {
  value = {
    hana = concat(
      google_compute_address.gcp_sap_hana_intip_master.*.address,
      google_compute_address.gcp_sap_hana_intip_worker.*.address,
      google_compute_address.gcp_sap_hana_intip_standby.*.address,
    )
    hana-master = google_compute_address.gcp_sap_hana_intip_master.*.address
    hana-worker = concat(
      google_compute_address.gcp_sap_hana_intip_worker.*.address,
      google_compute_address.gcp_sap_hana_intip_standby.*.address,
    )
  }
}

output "hana_filestore_backup" {
  value = "${google_filestore_instance.hana_filestore_backup.networks[0].ip_addresses[0]}:/${google_filestore_instance.hana_filestore_backup.file_shares[0].name}"
}

output "hana_filestore_shared" {
  value = "${google_filestore_instance.hana_filestore_shared.networks[0].ip_addresses[0]}:/${google_filestore_instance.hana_filestore_shared.file_shares[0].name}"
}
