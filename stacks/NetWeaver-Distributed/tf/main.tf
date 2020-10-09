/**
 * Copyright 2018 Google LLC
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

provider "google" {
  version = "~> 3.13.0"
}

module "hana" {
  source                      = "../../../terraform/modules/hana"
  subnetwork                  = var.subnetwork
  source_image_family         = var.source_image_family
  source_image_project        = var.source_image_project
  instance_name               = var.sap_hana_instance_name
  instance_type               = var.sap_hana_instance_type
  subnetwork_project          = var.subnetwork_project
  project_id                  = var.project_id
  zone                        = var.zone
  service_account_email       = var.sap_hana_service_account_email
  boot_disk_type              = var.sap_hana_boot_disk_type
  boot_disk_size              = var.sap_hana_boot_disk_size
  autodelete_disk             = var.sap_hana_autodelete_boot_disk
  pd_ssd_size                 = local.pd_ssd_size
  pd_hdd_size                 = local.pd_hdd_size
  sap_install_files_bucket    = var.sap_hana_install_files_bucket
  sap_hostagent_rpm_file_name = var.sap_hostagent_rpm_file_name
  sap_hana_bundle_file_name   = var.sap_hana_bundle_file_name
  sap_hana_sapcar_file_name   = var.sap_hana_sapcar_file_name
  network_tags                = var.sap_hana_network_tags
  use_public_ip               = var.sap_hana_use_public_ip
  gce_ssh_user                = var.gce_ssh_user
  gce_ssh_pub_key_file        = var.gce_ssh_pub_key_file
}

module "ascs" {
  source                = "../../../terraform/modules/nw"
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  autodelete_disk       = var.sap_nw_autodelete_boot_disk
  use_public_ip         = var.sap_nw_use_public_ip
  usrsap_disk_size      = var.sap_nw_usrsap_disk_size
  sapmnt_disk_size      = var.sap_nw_sapmnt_disk_size
  swap_disk_size        = var.sap_nw_swap_disk_size
  instance_name         = var.sap_ascs_instance_name
  instance_type         = var.sap_nw_instance_type
  network_tags          = var.sap_nw_network_tags
  project_id            = var.project_id
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  zone                  = var.zone
  boot_disk_size        = var.sap_nw_boot_disk_size
  boot_disk_type        = var.sap_nw_boot_disk_type
  additional_disk_type  = var.sap_nw_additional_disk_type
  service_account_email = var.sap_nw_service_account_email
}

module "pas" {
  source                = "../../../terraform/modules/nw"
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  autodelete_disk       = "true"
  use_public_ip         = var.sap_nw_use_public_ip
  swap_disk_size        = var.sap_nw_swap_disk_size
  instance_name         = var.sap_pas_instance_name
  instance_type         = var.sap_nw_instance_type
  network_tags          = var.sap_nw_network_tags
  project_id            = var.project_id
  zone                  = var.zone
  boot_disk_size        = var.sap_nw_boot_disk_size
  boot_disk_type        = var.sap_nw_boot_disk_type
  additional_disk_type  = var.sap_nw_additional_disk_type
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  service_account_email = var.sap_nw_service_account_email
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = var.project_id
}
