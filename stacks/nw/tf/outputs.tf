output "instance_name" {
  description = "Name of Netweaver instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "address" {
  description = "instance private IP"
  value = module.gcp_netweaver.instance_external_ip
}

output "sap_image_family" {
  value = contains([element(split("-", var.linux_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "instance_attached_disks_sapmnt" {
  value = module.gcp_netweaver.instance_attached_disks_sapmnt
}

output "instance_attached_disks_usrsap" {
  value = module.gcp_netweaver.instance_attached_disks_usrsap
}

output "instance_attached_disks_swap" {
  value = module.gcp_netweaver.instance_attached_disks_swap
}

output "device_name_usr_sap" {
  value = module.gcp_netweaver.device_name_usr_sap
}

output "device_name_sapmnt" {
  value = module.gcp_netweaver.device_name_sapmnt
}

output "device_name_swap" {
  value = module.gcp_netweaver.device_name_swap
}