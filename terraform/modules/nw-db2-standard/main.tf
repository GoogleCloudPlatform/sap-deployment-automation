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

module "vm" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = [
    {
      device_name         = "db2",
      size                = var.disk_size_db2,
      type                = var.disk_type_db2,
    },
    {
      device_name         = "sapmnt",
      size                = var.disk_size_sapmnt,
      type                = var.disk_type_sapmnt,
    },
    {
      device_name         = "swap",
      size                = var.disk_size_swap,
      type                = var.disk_type_swap,
    },
    {
      device_name         = "usrsap",
      size                = var.disk_size_usrsap,
      type                = var.disk_type_usrsap,
    },
  ]
  instance_name           = var.instance_name
  instance_type           = var.instance_type
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = var.subnetwork_project_id
  zone                    = var.zone
}
