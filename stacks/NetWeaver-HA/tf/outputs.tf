output "hana_primary_instance_name" {
  value = module.hana_ha.primary_instance_name
}

output "hana_secondary_instance_name" {
  value = module.hana_ha.secondary_instance_name
}

output "hana_primary_instance_ip" {
  value = module.hana_ha.primary_instance_ip
}

output "hana_secondary_instance_ip" {
  value = module.hana_ha.secondary_instance_ip
}

output "hana_ilb_ip" {
  value = module.hana_ha.hana_ilb_ip
}

output "hana_health_check_port" {
  value = module.hana_ha.health_check_port
}

output "ascs_instance_ip" {
  value = module.netweaver_ascs.primary_instance_ip
}

output "ers_instance_ip" {
  value = module.netweaver_ers.primary_instance_ip
}

output "ascs_instance_name" {
  value = module.netweaver_ascs.primary_instance_name
}

output "pas_instance_name" {
  value = module.netweaver_pas.primary_instance_name
}

output "ers_instance_name" {
  value = module.netweaver_ers.primary_instance_name
}

output "pas_instance_ip" {
  value = module.netweaver_pas.primary_instance_ip
}

output "ascs_ilb_ip" {
  value = module.ascs_ilb.ip_address
}

output "ers_ilb_ip" {
  value = local.ilb_required == false ? join("", google_compute_address.gcp_sap_s4hana_alias_ip.*.address) : module.ers_ilb.ip_address
}

output "inventory" {
  value = {
    hana     = [module.hana_ha.primary_instance_ip, module.hana_ha.secondary_instance_ip],
    ascs     = [module.netweaver_ascs.primary_instance_ip],
    ers      = [module.netweaver_ers.primary_instance_ip],
    nw_nodes = [module.netweaver_ascs.primary_instance_ip, module.netweaver_ers.primary_instance_ip],
    pas      = [module.netweaver_pas.primary_instance_ip],
  }
}

output "subnet_cidr_hana" {
  value = data.google_compute_subnetwork.subnetwork_hana.ip_cidr_range
}

output "subnet_cidr_nw" {
  value = data.google_compute_subnetwork.subnetwork_nw.ip_cidr_range
}

output "hana_data_size" {
  value = module.hana_ha.hana_data_size
}

output "hana_shared_size" {
  value = module.hana_ha.hana_shared_size
}

output "hana_log_size" {
  value = module.hana_ha.hana_log_size
}

output "hana_usr_size" {
  value = module.hana_ha.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana_ha.hana_backup_size
}

output "nw_usrsap_disk_size" {
  value = var.nw_usrsap_disk_size
}

output "nw_swap_disk_size" {
  value = var.nw_swap_disk_size
}

output "ascs_health_check_port" {
  value = var.ascs_health_check_port
}

output "ers_health_check_port" {
  value = var.ers_health_check_port
}
