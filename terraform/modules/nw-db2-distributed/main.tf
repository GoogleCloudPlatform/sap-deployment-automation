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

module "ascs" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks_ascs
  instance_name           = var.instance_name_ascs
  instance_type           = var.instance_type_ascs
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

module "db2" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks_db2
  instance_name           = var.instance_name_db2
  instance_type           = var.instance_type_db2
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

module "as" {
  source                  = "../vm"
  for_each                = toset(local.instance_names_as)

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks
  instance_name           = each.key
  instance_type           = var.instance_type_as
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
