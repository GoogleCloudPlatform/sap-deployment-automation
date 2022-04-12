# Copyright 2022 Google LLC
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

variable "project" {}
variable "network" {}
variable "zone" {}

terraform {
  backend "gcs" {}
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_filestore_instance" "nfs" {
  project   = var.project
  name      = "sap-nfs-${random_string.suffix.result}"
  location  = var.zone
  tier      = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "sap"
  }

  networks {
    network = var.network
    modes   = ["MODE_IPV4"]
  }
}

output "mount" {
  value = "${google_filestore_instance.nfs.networks.0.ip_addresses.0}:/sap"
}
