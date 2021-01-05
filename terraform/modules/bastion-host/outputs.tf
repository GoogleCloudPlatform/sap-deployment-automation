output "project_id" {
  value = var.project_id
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.hana_bastion.instances_self_links
}

output "sap_image_family" {
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "instance_group_link" {
  value = length(module.hana_bastion.instances_self_links) != 0 ? element(tolist(module.hana_bastion.instances_self_links), 0) : ""
}

output "instance_name" {
  value = length(module.hana_bastion.instances_self_links) != 0 ? element(split("/", element(tolist(module.hana_bastion.instances_self_links), 0)), 10) : ""
}

output "address" {
  value = google_compute_address.gcp_hana_bastion_ip.address
}

output "instance_ip" {
  value = google_compute_address.gcp_hana_bastion_ip.address
}

output "inventory" {
  value = { hana = [google_compute_address.gcp_hana_bastion_ip.address] }
}
