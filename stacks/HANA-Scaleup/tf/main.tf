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

provider "google" {}

module "hana_scaleup" {
  source                = "../../../terraform/modules/hana-scaleup"
  instance_name         = var.instance_name
  instance_type         = var.instance_type
  project_id            = var.project_id
  zone                  = var.zone
  gce_ssh_user          = var.gce_ssh_user
  gce_ssh_pub_key_file  = var.gce_ssh_pub_key_file
  service_account_email = var.service_account_email
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  boot_disk_size        = var.boot_disk_size
  boot_disk_type        = var.boot_disk_type
  autodelete_disk       = var.autodelete_disk
  network_tags          = var.network_tags
  pd_kms_key            = var.pd_kms_key
  create_backup_volume  = var.create_backup_volume
}
