output "ascs_instance_ip" {
  value = module.gcp_netweaver_ascs.primary_instance_ip
}

output "ers_instance_ip" {
  value = module.gcp_netweaver_ers.primary_instance_ip
}

output "ascs_instance_name" {
  value = module.gcp_netweaver_ascs.primary_instance_name
}

output "pas_instance_name" {
  value = module.gcp_netweaver_pas.primary_instance_name
}

output "ers_instance_name" {
  value = module.gcp_netweaver_ers.primary_instance_name
}

output "pas_instance_ip" {
  value = module.gcp_netweaver_pas.primary_instance_ip
}

output "ascs_ilb_ip" {
  value = module.sap_ascs_ilb.ip_address
}

output "ers_ilb_ip" {
  value = module.sap_ers_ilb.ip_address
}

output "inventory" {
  value = { ascs = [module.gcp_netweaver_ascs.primary_instance_ip], ers = [module.gcp_netweaver_ers.primary_instance_ip], nodes = [module.gcp_netweaver_ascs.primary_instance_ip, module.gcp_netweaver_ers.primary_instance_ip], pas = [module.gcp_netweaver_pas.primary_instance_ip] }
}

output "subnet_cidr" {
  value = data.google_compute_subnetwork.subnetwork.ip_cidr_range
}

output "usr_sap_size" {
  value = var.usr_sap_size
}

output "swap_size" {
  value = var.swap_size
}

output "ascs_health_check_port" {
  value = var.ascs_health_check_port
}

output "ers_health_check_port" {
  value = var.ers_health_check_port
}
