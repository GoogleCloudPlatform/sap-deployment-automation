output "app_instance_name" {
  description = "Name of Netweaver instance"
  value       = module.app.instance_name
}
output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "app_address" {
  description = "instance private IP"
  value       = module.app.instance_external_ip
}

output "sap_image_family" {
  value = contains([element(split("-", var.linux_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "subnet_cidr" {
  value = data.google_compute_subnetwork.subnetwork.ip_cidr_range
}

output "app_private_ip" {
  description = "instance private IP"
  value       = module.app.instance_internal_ip
}

