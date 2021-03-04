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

output "project_id" {
  value = var.project_id
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "instances_self_links" {
  value = module.hana_bastion.instances_self_links
}

output "sap_image_family" {
  value =   var.source_image_family
}

output "instance_group_link" {
  value = length(module.hana_bastion.instances_self_links) != 0 ? element(tolist(module.hana_bastion.instances_self_links), 0) : ""
}

output "instance_name" {
  value = length(module.hana_bastion.instances_self_links) != 0 ? element(split("/", element(tolist(module.hana_bastion.instances_self_links), 0)), 10) : ""
}

output "address" {
  value = join("", google_compute_address.gcp_hana_bastion_ip.*.address)
}

output "instance_ip" {
  value = join("", google_compute_address.gcp_hana_bastion_ip.*.address)
}
