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

output "hana_instance_name" {
  description = "Name of HANA instance"
  value       = module.hana.instance_name
}

output "ascs_instance_name" {
  description = "Name of Netweaver ASCS instance"
  value       = module.ascs.instance_name
}

output "pas_instance_name" {
  description = "Name of Netweaver PAS instance"
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

output "subnet_cidr_hana" {
  value = data.google_compute_subnetwork.subnetwork_hana.ip_cidr_range
}

output "subnet_cidr_nw" {
  value = data.google_compute_subnetwork.subnetwork_nw.ip_cidr_range
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

output "hana_data_size" {
  value = module.hana.hana_data_size
}

output "hana_shared_size" {
  value = module.hana.hana_shared_size
}

output "hana_log_size" {
  value = module.hana.hana_log_size
}

output "hana_usr_size" {
  value = module.hana.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana.hana_backup_size
}

output "hana_attached_disks_data" {
  value = module.hana.instance_attached_disks_data
}

output "hana_attached_disks_backup" {
  value = length(module.hana.instance_attached_disks_backup) > 0 ? module.hana.instance_attached_disks_backup[0] : ""
}

output "inventory" {
  value = local.inventory
}
