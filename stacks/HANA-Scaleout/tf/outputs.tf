output "project_id" {
  value = var.project_id
}

output "instances_self_links_master" {
  value = module.hana_scaleout.instances_self_links_master
}

output "instances_self_links_worker" {
  value = module.hana_scaleout.instances_self_links_worker
}

output "master_instance_name" {
  value = module.hana_scaleout.master_instance_name
}

output "worker_instance_names" {
  value = module.hana_scaleout.worker_instance_names
}

output "address_master" {
  value = module.hana_scaleout.address_master
}

output "address_worker" {
  value = module.hana_scaleout.address_worker
}

output "master_attached_disks_data" {
  value = module.hana_scaleout.master_attached_disks_data
}

output "master_attached_disks_backup" {
  value = module.hana_scaleout.master_attached_disks_backup
}

output "worker_attached_disks_data" {
  value = module.hana_scaleout.worker_attached_disks_data
}

output "hana_data_size" {
  value = module.hana_scaleout.hana_data_size
}

output "hana_shared_size" {
  value = module.hana_scaleout.hana_shared_size
}

output "hana_log_size" {
  value = module.hana_scaleout.hana_log_size
}

output "hana_usr_size" {
  value = module.hana_scaleout.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana_scaleout.hana_backup_size
}

output "inventory" {
  value = module.hana_scaleout.inventory
}
