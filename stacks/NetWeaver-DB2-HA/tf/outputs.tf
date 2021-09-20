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

output "as_internal_ips" {
  value = module.nw_db2_ha.as_internal_ips
}

output "ascs_internal_ip" {
  value = module.nw_db2_ha.ascs_internal_ip
}

output "db2_primary_internal_ip" {
  value = module.nw_db2_ha.db2_primary_internal_ip
}

output "db2_secondary_internal_ip" {
  value = module.nw_db2_ha.db2_secondary_internal_ip
}

output "ers_internal_ip" {
  value = module.nw_db2_ha.ers_internal_ip
}

output "filestore_ip" {
  value = module.nw_db2_ha.filestore_ip
}

output "ilb_internal_ip_ascs" {
  value = module.nw_db2_ha.ilb_internal_ip_ascs
}

output "ilb_internal_ip_db2" {
  value = module.nw_db2_ha.ilb_internal_ip_db2
}

output "ilb_internal_ip_ers" {
  value = module.nw_db2_ha.ilb_internal_ip_ers
}

output "inventory" {
  value = module.nw_db2_ha.inventory
}

output "pas_internal_ip" {
  value = module.nw_db2_ha.pas_internal_ip
}

output "pas_instance_name" {
  value = module.nw_db2_ha.pas_instance_name
}
