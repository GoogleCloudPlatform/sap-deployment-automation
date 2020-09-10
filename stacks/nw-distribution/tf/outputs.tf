output "ascs_instance_name" {
  description = "Name of Netweaver instance"
  value       = module.ascs.instance_name
}
output "pas_instance_name" {
  description = "Name of Netweaver instance"
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

output "sap_image_family" {
  value = contains([element(split("-", var.linux_image_family), 0)], "rhel") ? "RedHat" : "Suse"
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
