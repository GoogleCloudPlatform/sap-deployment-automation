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

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project_id
}

data "google_compute_image" "image" {
  name    = var.source_image != "" ? var.source_image : null
  family  = var.source_image == "" ? var.source_image_family : null
  project = var.source_image_project_id
}

resource "google_compute_instance" "instance" {
  allow_stopping_for_update = true
  name                      = var.instance_name
  machine_type              = var.instance_type
  metadata                  = var.metadata
  project                   = var.project_id
  tags                      = var.network_tags
  zone                      = var.zone

  boot_disk {
    auto_delete             = var.boot_disk_auto_delete
    device_name             = var.boot_disk_device_name
    initialize_params {
      image                 = data.google_compute_image.image.self_link
      size                  = var.boot_disk_size
      type                  = var.boot_disk_type
    }
  }

  network_interface {
    network                 = local.network
    subnetwork              = var.subnetwork
    subnetwork_project      = local.subnetwork_project_id
    network_ip              = google_compute_address.internal_ip.address
    dynamic "access_config" {
      for_each              = var.access_config != null ? [var.access_config] : []
      content {
        nat_ip              = lookup(access_config.value, "nat_ip", null)
        network_tier        = lookup(access_config.value, "network_tier", "PREMIUM")
      }
    }
  }

  service_account {
    email                   = var.service_account_email
    scopes                  = var.service_account_scopes
  }

  lifecycle {
    ignore_changes          = [
      attached_disk,
      # Don't interfere with pacemaker-managed alias IP.
      network_interface[0].alias_ip_range,
    ]
  }
}

resource "google_compute_disk" "additional_disks" {
  for_each                  = local.disks

  image                     = each.value.image
  labels                    = each.value.labels
  name                      = each.key
  physical_block_size_bytes = each.value.physical_block_size_bytes
  project                   = var.project_id
  size                      = each.value.size
  snapshot                  = each.value.snapshot
  type                      = each.value.type
  zone                      = var.zone
}

resource "google_compute_attached_disk" "attached_disks" {
  for_each     = local.disks

  device_name  = each.value.device_name
  disk         = google_compute_disk.additional_disks[each.key].id
  instance     = google_compute_instance.instance.id
  mode         = each.value.mode
}

resource "google_compute_address" "internal_ip" {
  name         = var.instance_name
  address_type = "INTERNAL"
  subnetwork   = "projects/${local.subnetwork_project_id}/regions/${local.region}/subnetworks/${var.subnetwork}"
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}
