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

module "sap_hana_template" {
  source       = "../terraform-google-vm//modules/instance_template"
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

  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  tags               = var.network_tags
  can_ip_forward     = true

  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project

  disk_size_gb = var.boot_disk_size
  disk_type    = var.boot_disk_type
  auto_delete  = var.autodelete_disk
}

resource "google_compute_address" "gcp_sap_hana_intip_primary" {
  name         = "${local.instance_name_primary}-int"
  address_type = "INTERNAL"
  subnetwork   = "projects/${var.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "gcp_sap_hana_intip_secondary" {
  name         = "${local.instance_name_secondary}-int"
  address_type = "INTERNAL"
  subnetwork   = "projects/${var.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

module "sap_hana_umig_primary" {
  source               = "../terraform-google-vm//modules/umig"
  project_id           = var.project_id
  region               = local.region
  zone                 = var.primary_zone
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  static_ips           = [google_compute_address.gcp_sap_hana_intip_primary.address]
  hostname             = local.instance_name_primary
  auto_append_hostname = var.instance_name_primary == ""
  num_instances        = var.target_size
  instance_template    = module.sap_hana_template.self_link
}

module "sap_hana_umig_secondary" {
  source               = "../terraform-google-vm//modules/umig"
  project_id           = var.project_id
  region               = local.region
  zone                 = var.secondary_zone
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  static_ips           = [google_compute_address.gcp_sap_hana_intip_secondary.address]
  hostname             = local.instance_name_secondary
  auto_append_hostname = var.instance_name_secondary == ""
  num_instances        = var.target_size
  instance_template    = module.sap_hana_template.self_link
}

resource "google_compute_disk" "gcp_sap_hana_data_primary" {
  project = var.project_id
  name    = "${local.instance_name_primary}-data"
  type    = "pd-ssd"
  zone    = var.primary_zone
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup_primary" {
  project = var.project_id
  name    = "${local.instance_name_primary}-backup"
  count   = tobool(var.create_backup_volume) == true ? 1 : 0
  type    = "pd-standard"
  zone    = var.primary_zone
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_data_secondary" {
  project = var.project_id
  name    = "${local.instance_name_secondary}-data"
  type    = "pd-ssd"
  zone    = var.secondary_zone
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup_secondary" {
  project = var.project_id
  name    = "${local.instance_name_secondary}-backup"
  count   = tobool(var.create_backup_volume) == true ? 1 : 0
  type    = "pd-standard"
  zone    = var.secondary_zone
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "primary_data" {
  disk        = google_compute_disk.gcp_sap_hana_data_primary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)}-data"
  project     = var.project_id
  zone        = var.primary_zone
}

resource "google_compute_attached_disk" "primary_backup" {
  count       = tobool(var.create_backup_volume) == true ? 1 : 0
  disk        = google_compute_disk.gcp_sap_hana_backup_primary[0].id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)}-backup"
  project     = var.project_id
  zone        = var.primary_zone
}

resource "google_compute_attached_disk" "secondary_data" {
  disk        = google_compute_disk.gcp_sap_hana_data_secondary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)}-data"
  project     = var.project_id
  zone        = var.secondary_zone
}

resource "google_compute_attached_disk" "secondary_backup" {
  count       = tobool(var.create_backup_volume) == true ? 1 : 0
  disk        = google_compute_disk.gcp_sap_hana_backup_secondary[0].id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)}-backup"
  project     = var.project_id
  zone        = var.secondary_zone
}

module "sap_hana_ilb" {
  source          = "../terraform-google-lb-internal"
  project         = var.project_id
  region          = local.region
  network         = local.network
  network_project = var.subnetwork_project
  subnetwork      = var.subnetwork
  name            = local.ilb_name
  source_tags     = ["source-tag"]
  target_tags     = ["target-tag"]
  ports           = null
  all_ports       = true
  health_check    = local.health_check

  backends = [
    {
      group       = module.sap_hana_umig_primary.self_links[0]
      description = "Primary instance backend group"
      failover    = false
    },
    {
      group       = module.sap_hana_umig_secondary.self_links[0]
      description = "Secondary instance backend group"
      failover    = true
    },
  ]
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = var.subnetwork_project
}
