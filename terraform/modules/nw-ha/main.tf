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

module "instance_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = var.instance_name
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = var.region
  metadata = {
    ssh-keys               = "${var.ssh_user}:${file("${var.public_key_path}")}"
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  tags               = var.network_tags

  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project

  disk_size_gb = var.boot_disk_size
  disk_type    = var.boot_disk_type
  auto_delete  = var.autodelete_disk
}

resource "google_compute_address" "internal_ip" {
  count        = var.target_size
  name         = "${var.instance_name}-${count.index}"
  address_type = "INTERNAL"
  subnetwork   = "projects/${var.subnetwork_project}/regions/${var.region}/subnetworks/${var.subnetwork}"
  region       = var.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

module "umig" {
  source             = "../terraform-google-vm//modules/umig"
  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  static_ips         = google_compute_address.internal_ip.*.address
  hostname           = substr("${var.instance_name}", 0, 12) # Limit length to 12 charecters
  num_instances      = var.target_size
  instance_template  = module.instance_template.self_link
}

resource "google_compute_disk" "gcp_nw_pd_0" {
  count   = var.usr_sap_size > 0 ? var.target_size : 0
  project = var.project_id
  name    = "${var.instance_name}-${count.index+1}-usrsap"
  type    = "pd-ssd"
  zone    = var.zone
  size    = var.usr_sap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_nw_pd_1" {
  count   = var.swap_size > 0 ? var.target_size : 0
  project = var.project_id
  name    = "${var.instance_name}-${count.index+1}-swap"
  type    = "pd-ssd"
  zone    = var.zone
  size    = var.swap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_0" {
  count       = var.usr_sap_size > 0 ? var.target_size : 0
  disk        = google_compute_disk.gcp_nw_pd_0.*.self_link[count.index]
  instance    = split("/", module.umig.instances_self_links[count.index])[10]
  device_name = "${split("/", module.umig.instances_self_links[count.index])[10]}-usrsap"
  project     = var.project_id
  zone        = var.zone
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_1" {
  count       = var.swap_size > 0 ? var.target_size : 0
  disk        = google_compute_disk.gcp_nw_pd_1.*.self_link[count.index]
  instance    = split("/", module.umig.instances_self_links[count.index])[10]
  device_name = "${split("/", module.umig.instances_self_links[count.index])[10]}-swap"
  project     = var.project_id
  zone        = var.zone
}
