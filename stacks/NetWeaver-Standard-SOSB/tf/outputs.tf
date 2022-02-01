/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "instances_self_links_master" {
  value = module.gcp_hana.instances_self_links_master
}

output "instances_self_links_worker" {
  value = module.gcp_hana.instances_self_links_worker
}

output "master_instance_name" {
  value = module.gcp_hana.master_instance_name
}

output "worker_instance_names" {
  value = module.gcp_hana.worker_instance_names
}

output "standby_instance_name" {
  value = module.gcp_hana.standby_instance_name
}

output "address_master" {
  value = flatten(module.gcp_hana.address_master)
}

output "address_worker" {
  value = module.gcp_hana.address_worker
}

output "address_standby" {
  value = module.gcp_hana.address_standby
}

output "master_attached_disks_data" {
  value = module.gcp_hana.master_attached_disks_data
}

output "worker_attached_disks_data" {
  value = module.gcp_hana.worker_attached_disks_data
}

output "hana_data_size" {
  value = module.gcp_hana.hana_data_size
}

output "hana_log_size" {
  value = module.gcp_hana.hana_log_size
}

output "hana_usr_size" {
  value = module.gcp_hana.hana_usr_size
}

output "hana_filestore_backup" {
  value = module.gcp_hana.hana_filestore_backup
}

output "hana_filestore_shared" {
  value = module.gcp_hana.hana_filestore_shared
}

output "inventory" {
  value = concat(module.gcp_hana.inventory, module.gcp_netweaver.inventory)
}

output "nw_ip" {
  value = module.gcp_netweaver.instance_internal_ip
}

output "nw_instance_name" {
  description = "Name of NetWeaver instance."
  value       = module.gcp_netweaver.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}
