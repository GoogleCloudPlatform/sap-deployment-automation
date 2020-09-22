output "instance_name" {
  value = google_compute_instance.gcp_sap_hana.name
}

output "instance_id" {
  value = google_compute_instance.gcp_sap_hana.instance_id
}

output "self_link" {
  value = google_compute_instance.gcp_sap_hana.self_link
}

output "hostname" {
  value = google_compute_instance.gcp_sap_hana.hostname
}

output "zone" {
  value = google_compute_instance.gcp_sap_hana.zone
}

output "machine_type" {
  value = google_compute_instance.gcp_sap_hana.machine_type
}

output "address" {
  value = google_compute_instance.gcp_sap_hana.network_interface[0].network_ip
}

output "public_ip" {
  value = (
    length(google_compute_instance.gcp_sap_hana.network_interface[0].access_config) != 0 ? (
      google_compute_instance.gcp_sap_hana.network_interface[0].access_config[0].nat_ip
    ) : ""
  )
}

output "instance_attached_disks_data" {
  value = google_compute_disk.gcp_sap_hana_sd_data.name
}

output "instance_attached_disks_backup" {
  value = google_compute_disk.gcp_sap_hana_sd_backup.name
}
