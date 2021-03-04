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

provider "google" {
  version = "~> 3.13.0"
}

module "app" {
  source                = "../../../terraform/modules/nw"
  instance_name         = var.aas_instance_name
  subnetwork            = var.subnetwork
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  subnetwork_project    = var.subnetwork_project
  linux_image_family    = var.source_image_family
  linux_image_project   = var.source_image_project
  autodelete_disk       = "true"
  public_ip             = var.public_ip
  sap_deployment_debug  = var.sap_deployment_debug
  swap_size             = var.swap_size
  usr_sap_size          = var.usr_sap_size
  instance_type         = var.instance_type
  network_tags          = var.network_tags
  project_id            = var.project_id
  zone                  = var.zone
  boot_disk_size        = var.boot_disk_size
  boot_disk_type        = var.boot_disk_type
  disk_type             = var.disk_type
  service_account_email = var.service_account_email
}


data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = var.region
  project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
}

