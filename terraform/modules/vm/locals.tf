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
  region                        = join("-", slice(split("-", var.zone), 0, 2))
  subnetwork_project_id         = var.subnetwork_project_id == "" ? var.project_id : var.subnetwork_project_id
  network_parts                 = split("/", data.google_compute_subnetwork.subnetwork.network)
  network                       = element(local.network_parts, length(local.network_parts) - 1)
  disks                         = {
    for disk in var.additional_disks :
    "${var.instance_name}-${disk.device_name}" => {
      device_name               = lookup(disk, "device_name", null)
      image                     = lookup(disk, "image", null)
      labels                    = lookup(disk, "labels", null)
      mode                      = lookup(disk, "mode", "READ_WRITE")
      physical_block_size_bytes = lookup(disk, "physical_block_size_bytes", null)
      size                      = disk.size
      snapshot                  = lookup(disk, "snapshot", null)
      type                      = disk.type
    }
  }
}
