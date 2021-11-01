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
  device_name_swap      = "swap"
  device_name_usrsap    = "usrsap"
  additional_disks      = [
    {
      device_name       = local.device_name_swap,
      size              = var.disk_size_swap,
      type              = var.disk_type_swap,
    },
    {
      device_name       = local.device_name_usrsap,
      size              = var.disk_size_usrsap,
      type              = var.disk_type_usrsap,
    },
  ]
  additional_disks_db2  = concat(local.additional_disks, [{
      device_name       = local.device_name_db2,
      size              = var.disk_size_db2,
      type              = var.disk_type_db2,
  }])
  filestore_network     = var.filestore_network != "" ? var.filestore_network : module.ascs.network
  instance_name_pas     = "${var.instance_basename_as}-1"
  instance_names_as     = [
    for i in range(var.num_instances_as) : "${var.instance_basename_as}-${i+1}"
  ]
  metadata              = { ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}" }
  network               = element(regex(".*/([^/]+$)", data.google_compute_subnetwork.subnetwork.network), 0)
  region                = join("-", slice(split("-", var.zone_primary), 0, 2))
  subnetwork_project_id = var.subnetwork_project_id == "" ? var.project_id : var.subnetwork_project_id
  zones                 = [var.zone_primary, var.zone_secondary]

  as_instances          = values(module.as)
  base_inventory        = [
    {
      groups            = ["sap"],
      host              = module.ascs.internal_ip,
      vars              = {
        sap_is_ascs     = true,
        sap_is_scs      = true,
      }
    },
    {
      groups            = ["sap"],
      host              = module.ers.internal_ip,
      vars              = {
        sap_is_ers      = true,
        sap_is_scs      = true,
      }
    },
    {
      groups            = ["sap"],
      host              = module.db2_primary.internal_ip,
      vars              = {
        sap_is_db2         = true,
        sap_is_db2_primary = true,
      }
    },
    {
      groups            = ["sap"],
      host              = module.db2_secondary.internal_ip,
      vars              = {
        sap_is_db2           = true,
        sap_is_db2_secondary = true,
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
