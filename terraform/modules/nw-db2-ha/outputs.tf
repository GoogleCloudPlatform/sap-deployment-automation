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
  value = [for as in module.as : as.internal_ip]
}

output "ascs_internal_ip" {
  value = module.ascs.internal_ip
}

output "ers_internal_ip" {
  value = module.ers.internal_ip
}

output "db2_primary_internal_ip" {
  value = module.db2_primary.internal_ip
}

output "db2_secondary_internal_ip" {
  value = module.db2_secondary.internal_ip
}

output "filestore_ip" {
  value = join("", module.filestore.*.filestore_ip)
}

output "ilb_internal_ip_ascs" {
  value = module.ilb_ascs.ip_address
}

output "ilb_internal_ip_db2" {
  value = module.ilb_db2.ip_address
}

output "ilb_internal_ip_ers" {
  value = (
    var.ers_ilb_required
    ? join("", module.ilb_ers.*.ip_address)
    : join("", google_compute_address.ers_vip.*.address)
    )
}

output "inventory" {
  value           = {
    ascs          = [module.ascs.internal_ip],
    ers           = [module.ers.internal_ip],
    db2           = [module.db2_primary.internal_ip, module.db2_secondary.internal_ip],
    db2_primary   = [module.db2_primary.internal_ip],
    db2_secondary = [module.db2_secondary.internal_ip],
    pas           = [for k, v in module.as : v.internal_ip if k == local.instance_name_pas]
    aas           = [for k, v in module.as : v.internal_ip if k != local.instance_name_pas],
    nodes         = concat(
      [
	module.ascs.internal_ip,
	module.ers.internal_ip,
	module.db2_primary.internal_ip,
	module.db2_secondary.internal_ip,
      ],
      [for as in module.as : as.internal_ip]),
  }
}

output "pas_instance_name" {
  value = local.instance_name_pas
}

output "pas_internal_ip" {
  value = length(module.as) > 0 ? module.as[local.instance_name_pas].internal_ip : ""
}
