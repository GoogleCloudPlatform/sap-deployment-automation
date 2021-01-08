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

