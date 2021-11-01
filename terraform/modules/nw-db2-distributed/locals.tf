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

locals {
  device_name_db2       = "db2"
  device_name_sapmnt    = "sapmnt"
  device_name_swap      = "swap"
  device_name_usrsap    = "usrsap"
  additional_disks      = [
    {
      device_name       = local.device_name_swap,
      size              = 25,
      type              = var.disk_type_swap,
    },
    {
      device_name       = local.device_name_usrsap,
      size              = 25,
      type              = var.disk_type_usrsap,
    },
  ]
  additional_disks_ascs = concat(local.additional_disks, [{
      device_name       = local.device_name_sapmnt,
      size              = 25,
      type              = var.disk_type_sapmnt,
  }])
  additional_disks_db2  = concat(local.additional_disks, [{
      device_name       = local.device_name_db2,
      size              = 50,
      type              = var.disk_type_db2,
  }])
  instance_name_pas     = "${var.instance_basename_as}-1"
  instance_names_as     = [
    for i in range(var.num_instances_as) : "${var.instance_basename_as}-${i+1}"
  ]
  metadata              = { ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}" }

  as_instances          = values(module.as)
  base_inventory        = [
    {
      groups            = ["sap"],
      host              = module.ascs.internal_ip,
      vars              = {
        sap_is_ascs     = true,
      }
    },
    {
      groups            = ["sap"],
      host              = module.db2.internal_ip,
      vars              = {
        sap_is_db2      = true,
      }
    },
  ]
  pas_inventory         = (
    var.num_instances_as < 1 ? [] : [
      {
	groups          = ["sap"],
        host            = local.as_instances[0].internal_ip,
        vars            = {
          sap_is_pas    = true,
        }
      }]
    )
  aas_inventory         = (
    var.num_instances_as < 2 ? [] : [
      for as in slice(local.as_instances, 1, var.num_instances_as) : {
	groups          = ["sap"],
        host            = as.internal_ip,
        vars            = {
          sap_is_aas    = true,
        }
      }]
    )
  inventory             = concat(local.base_inventory, local.pas_inventory, local.aas_inventory)
}
