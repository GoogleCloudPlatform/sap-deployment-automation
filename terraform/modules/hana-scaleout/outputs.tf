output "project_id" {
  value = var.project_id
}

output "instances_self_links_master" {
  value = module.sap_hana_instance_master.instances_self_links
}

output "instances_self_links_worker" {
  value = flatten(module.sap_hana_instance_worker.*.instances_self_links)
}

output "master_instance_name" {
  value = element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)
}

output "address_master" {
  value = google_compute_address.gcp_sap_hana_intip_master.*.address
}

output "address_worker" {
  value = google_compute_address.gcp_sap_hana_intip_worker.*.address
}

output "master_attached_disks_data" {
  value = google_compute_attached_disk.master_data.*.device_name
}

output "master_attached_disks_backup" {
  value = google_compute_attached_disk.master_backup.*.device_name
}

output "worker_attached_disks_data" {
  value = google_compute_attached_disk.worker_data.*.device_name
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

output "inventory" {
  value = {
    hana-master = flatten([google_compute_address.gcp_sap_hana_intip_master.*.address])
    hana-worker = flatten([google_compute_address.gcp_sap_hana_intip_worker.*.address])
  }
}
