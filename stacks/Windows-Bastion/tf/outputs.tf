output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.hana_bastion.instances_self_links
}

output "address" {
  value = module.hana_bastion.address
}

output "sap_image_family" {
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "inventory" {
  value = { hana = [module.hana_bastion.address] }
}
