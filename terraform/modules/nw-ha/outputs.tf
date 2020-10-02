output "project_id" {
  value = var.project_id
}

output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Primary Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links_primary" {
  description = "List of self-links for primary compute instances"
  value       = module.sap_s4hana_umig.instances_self_links
}

output "address_primary" {
  value = google_compute_address.gcp_sap_s4hana_intip_primary.address
}

output "sap_image_family" {
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "primary_umig_group_link" {
  value = length(module.sap_s4hana_umig.self_links) != 0 ? element(tolist(module.sap_s4hana_umig.self_links), 0) : ""
}

output "primary_instance_name" {
  value = length(module.sap_s4hana_umig.instances_self_links) != 0 ? element(split("/", element(tolist(module.sap_s4hana_umig.instances_self_links), 0)), 10) : ""
}

output "primary_instance_ip" {
  value = google_compute_address.gcp_sap_s4hana_intip_primary.address
}
