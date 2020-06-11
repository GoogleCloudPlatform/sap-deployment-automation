output "instance_name" {
  value = google_compute_instance.gcp_sap_hana.name
}

output "zone" {
  value = google_compute_instance.gcp_sap_hana.zone
}

output "machine_type" {
  value = google_compute_instance.gcp_sap_hana.machine_type
}