# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "google" {}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project
}

module "sap_hana_template" {
  source       = "../terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
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

resource "google_compute_address" "gcp_sap_hana_intip_master" {
  name         = "${var.instance_name}-int-m"
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "gcp_sap_hana_intip_worker" {
  name         = "${var.instance_name}-int-w${format("%01d", count.index + 1)}"
  count        = var.instance_count_worker
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "gcp_sap_hana_intip_standby" {
  name         = "${var.instance_name}-int-w${local.sap_node_count}"
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}

module "sap_hana_instance_master" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip_master.*.address
  hostname           = var.instance_name
  instance_template  = module.sap_hana_template.self_link
}

module "sap_hana_instance_worker" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip_worker.*.address
  hostname           = "${var.instance_name}w"
  num_instances      = var.instance_count_worker
  instance_template  = module.sap_hana_template.self_link
}

module "sap_hana_instance_standby" {
  source             = "../terraform-google-vm//modules/compute_instance"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = google_compute_address.gcp_sap_hana_intip_standby.*.address
  hostname           = "${var.instance_name}w0${local.sap_node_count}"
  instance_template  = module.sap_hana_template.self_link
}

resource "google_compute_disk" "gcp_sap_hana_data_master" {
  project = var.project_id
  name    = "${var.instance_name}-mnt00001"
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

resource "google_compute_disk" "gcp_sap_hana_data_worker" {
  project = var.project_id
  name    = "${var.instance_name}-mnt0000${count.index + 2}"
  count   = var.instance_count_worker
  type    = "pd-ssd"
  zone    = var.zone
  size    = local.pd_ssd_size_worker

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != "" ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "master_data" {
  project     = var.project_id
  zone        = var.zone
  disk        = google_compute_disk.gcp_sap_hana_data_master.id
  instance    = element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_instance_master.instances_self_links), 0)), 10)}-data"
  depends_on  = [google_compute_disk.gcp_sap_hana_data_master]
}

resource "google_compute_attached_disk" "worker_data" {
  project     = var.project_id
  zone        = var.zone
  count       = var.instance_count_worker
  disk        = element(google_compute_disk.gcp_sap_hana_data_worker.*.self_link, count.index + 1)
  instance    = element(split("/", element(element(module.sap_hana_instance_worker.*.instances_self_links, 0), count.index + 1)), 10)
  device_name = "${element(split("/", element(element(module.sap_hana_instance_worker.*.instances_self_links, 0), count.index + 1)), 10)}-data"
}


resource "google_filestore_instance" "hana_filestore_backup" {
  name = "sap-hana-backup-fs-bg"
  project = local.subnetwork_project
  zone = var.zone
  tier = "STANDARD"

  file_shares {
    capacity_gb = 1024
    name        = "hanabackup"
  }

  networks {
    network = local.network
    modes   = ["MODE_IPV4"]
  }
}

resource "google_filestore_instance" "hana_filestore_shared" {
  name = "sap-hana-shared-fs-bg"
  project = local.subnetwork_project
  zone = var.zone
  tier = "STANDARD"

  file_shares {
    capacity_gb = 1024
    name        = "hanashared"
  }

  networks {
    network = local.network
    modes   = ["MODE_IPV4"]
  }
}
