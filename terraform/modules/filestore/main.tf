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

resource "google_filestore_instance" "filestore" {
  provider           = google-beta

  name               = var.name
  project            = var.project_id
  tier               = var.tier
  zone               = var.zone

  file_shares {
    capacity_gb      = var.size
    name             = var.share

    nfs_export_options {
      ip_ranges      = var.clients
      access_mode    = "READ_WRITE"
    }
  }

  networks {
    network          = var.network
    modes            = ["MODE_IPV4"]
  }
}

resource "google_compute_firewall" "filestore_egress" {
  destination_ranges = ["${local.filestore_ip}/32"]
  direction          = "EGRESS"
  name               = "${var.name}-egress"
  network            = var.network
  project            = var.project_id

  allow {
    protocol         = "tcp"
    # Per https://cloud.google.com/filestore/docs/configuring-firewall.
    ports            = ["111", "2046", "2049", "2050", "4045"]
  }
}
