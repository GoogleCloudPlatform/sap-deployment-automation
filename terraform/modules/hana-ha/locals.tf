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
  pd_hdd_size      = local.hana_backup_size

  health_check = {
    type                = "tcp"
    check_interval_sec  = 10
    healthy_threshold   = 4
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 60000
    port_name           = "hana-health-check-port"
    request             = ""
    request_path        = "/"
    host                = ""
  }

  network_parts = split("/", data.google_compute_subnetwork.subnetwork.network)
  network       = element(local.network_parts, length(local.network_parts) - 1)
  region        = join("-", slice(split("-", var.primary_zone), 0, 2))
}
