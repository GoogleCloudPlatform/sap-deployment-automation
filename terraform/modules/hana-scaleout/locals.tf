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
  pd_ssd_map = {
    "n1-highmem-32"   = 834
    "n1-highmem-64"   = 1280
    "n1-highmem-96"   = 1904
    "n2-highmem-32"   = 834
    "n2-highmem-48"   = 1184
    "n2-highmem-64"   = 1568
    "n2-highmem-80"   = 1952
    "m1-megamem-96"   = 3717
    "m1-ultramem-40"  = 2914
    "m1-ultramem-80"  = 4451
    "m1-ultramem-160" = 7334
    "m2-ultramem-208" = 10400
    "m2-ultramem-416" = 19217
  }

  pd_hdd_map = {
    "n1-highmem-32"   = 448
    "n1-highmem-64"   = 864
    "n1-highmem-96"   = 1280
    "n2-highmem-32"   = 544
    "n2-highmem-48"   = 800
    "n2-highmem-64"   = 1056
    "n2-highmem-80"   = 1312
    "m1-megamem-96"   = 2898
    "m1-ultramem-40"  = 1954
    "m1-ultramem-80"  = 3876
    "m1-ultramem-160" = 7720
    "m2-ultramem-208" = 11808
    "m2-ultramem-416" = 23564
  }

  pd_balanced_map = {
    "n1-highmem-32"   = 1429
    "n1-highmem-64"   = 1980
    "n1-highmem-96"   = 2942
    "n2-highmem-32"   = 1429
    "n2-highmem-48"   = 1831
    "n2-highmem-64"   = 2424
    "n2-highmem-80"   = 3017
    "m1-megamem-96"   = 4286
    "m1-ultramem-40"  = 4286
    "m1-ultramem-80"  = 4286
    "m1-ultramem-160" = 6180
    "m2-ultramem-208" = 8667
    "m2-ultramem-416" = 15766
  }

  instance_mem_map = {
    "n1-highmem-32"   = 208
    "n1-highmem-64"   = 416
    "n1-highmem-96"   = 624
    "n2-highmem-32"   = 256
    "n2-highmem-48"   = 384
    "n2-highmem-64"   = 512
    "n2-highmem-80"   = 640
    "m1-megamem-96"   = 1433
    "m1-ultramem-40"  = 961
    "m1-ultramem-80"  = 1922
    "m1-ultramem-160" = 3844
    "m2-ultramem-208" = 5888
    "m2-ultramem-416" = 11766
  }

  hana_log_size    = min(512, max(64, lookup(local.instance_mem_map, var.instance_type) / 2))
  hana_data_size   = lookup(local.instance_mem_map, var.instance_type) * 15 / 10
  hana_shared_size = min(1024, lookup(local.instance_mem_map, var.instance_type))
  hana_usr_size    = 32
  hana_backup_size = lookup(local.instance_mem_map, var.instance_type) * 2
  pd_ssd_size      = max(lookup(local.pd_ssd_map, var.instance_type), (local.hana_log_size + local.hana_data_size + local.hana_shared_size + local.hana_usr_size))
  pd_bal_size      = max(lookup(local.pd_balanced_map, var.instance_type), (local.hana_log_size + local.hana_data_size + local.hana_shared_size + local.hana_usr_size))
  pd_hdd_size      = local.hana_backup_size
  pd_ssd_size_wor  = local.hana_log_size + local.hana_data_size + local.hana_usr_size + 1

  region             = join("-", slice(split("-", var.zone), 0, 2))
  subnetwork_project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
  network_parts      = split("/", data.google_compute_subnetwork.subnetwork.network)
  network            = element(local.network_parts, length(local.network_parts) - 1)

  master_inventory   = [{
    host             = join("", google_compute_address.gcp_sap_hana_intip_master.*.address),
    groups           = ["hana", "hana_master"],
    vars             = {
      sap_hana_is_master = true,
    },
  }]
  worker_inventory   = [for ip in google_compute_address.gcp_sap_hana_intip_worker : {
    host             = ip.address,
    groups           = ["hana", "hana_worker"],
    vars             = {
      sap_hana_is_worker = true,
    },
  }]
  inventory          = concat(local.master_inventory, local.worker_inventory)
}
