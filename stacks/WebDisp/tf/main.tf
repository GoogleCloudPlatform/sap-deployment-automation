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

module "gcp_webdisp" {
  source                = "../../../terraform/modules/wd"
  subnetwork            = var.subnetwork_wd
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  autodelete_disk       = var.sap_wd_autodelete_boot_disk
  use_public_ip         = var.sap_wd_use_public_ip
  usrsap_disk_size      = var.sap_wd_usrsap_disk_size
  sapmnt_disk_size      = var.sap_wd_sapmnt_disk_size
  swap_disk_size        = var.sap_wd_swap_disk_size
  instance_name         = var.sap_wd_instance_name
  instance_type         = var.sap_wd_instance_type
  network_tags          = var.sap_wd_network_tags
  project_id            = var.project_id
  zone                  = var.zone
  boot_disk_size        = var.sap_wd_boot_disk_size
  boot_disk_type        = var.sap_wd_boot_disk_type
  additional_disk_type  = var.sap_wd_additional_disk_type
  service_account_email = var.sap_wd_service_account_email
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
}
