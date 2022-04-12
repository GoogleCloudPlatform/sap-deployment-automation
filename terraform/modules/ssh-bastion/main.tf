/**
 * Copyright 2022 Google LLC
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

resource "random_string" "name_suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  random_suffix         = var.random_suffix ? "${random_string.name_suffix.result}" : ""
  bastion_sa            = var.random_suffix ? "${var.bastion_sa}-${local.random_suffix}" : "${var.bastion_sa}"
  bastion_instance_name = var.random_suffix ? "${var.bastion_instance_name}-${local.random_suffix}" : "${var.bastion_instance_name}"
}

resource "google_service_account" "bastion" {
  account_id   = local.bastion_sa
  display_name = "ssh bastion"
  project      = var.project
}

resource "google_compute_instance" "bastion" {
  name         = local.bastion_instance_name
  project      = var.project
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project_id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "ansible:${file(var.public_ssh)}"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.bastion.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "all-ssh" {
  name                    = "allow-bastion-ssh-on-${var.network}-${local.random_suffix}"
  project                 = var.project
  network                 = var.network
  target_service_accounts = [google_service_account.bastion.email]
  source_ranges           = ["0.0.0.0/0"]
  allow {
    protocol = "TCP"
    ports    = [22]
  }
}