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

output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.hana_scaleup.instances_self_links
}

output "address" {
  value = module.hana_scaleup.address
}

output "hana_data_size" {
  value = module.hana_scaleup.hana_data_size
}

output "hana_shared_size" {
  value = module.hana_scaleup.hana_shared_size
}

output "hana_log_size" {
  value = module.hana_scaleup.hana_log_size
}

output "hana_usr_size" {
  value = module.hana_scaleup.hana_usr_size
}

output "hana_backup_size" {
  value = module.hana_scaleup.hana_backup_size
}

output "sap_image_family" {
  value = contains([element(split("-", var.source_image_family), 0)], "rhel") ? "RedHat" : "Suse"
}

output "inventory" {
  value = module.hana_scaleup.inventory
}

output "hana_attached_disks_data" {
  value = module.hana_scaleup.instance_attached_disks_data
}

output "hana_attached_disks_backup" {
  value = join("", module.hana_scaleup.instance_attached_disks_backup)
}
