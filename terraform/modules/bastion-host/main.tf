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

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project
}

locals {
  access_config = {
    nat_ip       = join("", google_compute_address.gcp_hana_bastion_ip.*.address)
    network_tier = "PREMIUM"
  }
}

module "hana_bastion_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = var.instance_name
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = local.region

 
  metadata = {
    windows-startup-script-ps1 = templatefile("${path.module}/install-sap-hana-logon.ps1", {BucketFolder = var.install_files_bucket_folder})
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "sap-win-bastion"
  }

  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project
  tags                 = var.network_tags
  can_ip_forward       = false #true
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  disk_size_gb         = var.boot_disk_size
  disk_type            = var.boot_disk_type
  auto_delete          = var.autodelete_disk
}

resource "google_compute_address" "gcp_hana_bastion_ip" {
  count        = var.use_public_ip ? 1 : 0
  name         = "${var.instance_name}-ip"
  address_type = "EXTERNAL"
  region       = local.region
  project      = var.project_id
}

module "hana_bastion" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  #static_ips         = var.use_public_ip ? [] : google_compute_address.gcp_hana_bastion_ip.*.address
  hostname           = var.instance_name
  
  access_config      = var.use_public_ip ? [local.access_config] : []
  num_instances      = 1

  instance_template  = module.hana_bastion_template.self_link
}
