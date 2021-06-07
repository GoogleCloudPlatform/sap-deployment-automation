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

module "sap_hana_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = var.instance_name
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = local.region

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "hana"
  }

  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project
  tags                 = var.network_tags
  can_ip_forward       = true
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  disk_size_gb         = var.boot_disk_size
  disk_type            = var.boot_disk_type
  auto_delete          = var.autodelete_disk
}

resource "google_compute_address" "gcp_sap_hana_intip" {
  name         = "${var.instance_name}-int"
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

module "sap_hana_scaleup" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip.*.address
  hostname           = var.instance_name
  instance_template  = module.sap_hana_template.self_link
}

resource "google_compute_disk" "gcp_sap_hana_data" {
  project = var.project_id
  name    = "${var.instance_name}-data"
  type    = "pd-ssd"
  zone    = var.zone
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup" {
  project = var.project_id
  name    = "${var.instance_name}-backup"
  count   = tobool(var.create_backup_volume) == true ? 1 : 0
  type    = "pd-standard"
  zone    = var.zone
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "data" {
  disk        = google_compute_disk.gcp_sap_hana_data.id
  instance    = element(split("/", element(tolist(module.sap_hana_scaleup.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_scaleup.instances_self_links), 0)), 10)}-data"
  project     = var.project_id
  zone        = var.zone
}

resource "google_compute_attached_disk" "backup" {
  count       = tobool(var.create_backup_volume) == true ? 1 : 0
  disk        = google_compute_disk.gcp_sap_hana_backup[0].id
  instance    = element(split("/", element(tolist(module.sap_hana_scaleup.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_scaleup.instances_self_links), 0)), 10)}-backup"
  project     = var.project_id
  zone        = var.zone
}
