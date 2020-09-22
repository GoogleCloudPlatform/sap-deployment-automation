/**
 * Copyright 2018 Google LLC
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
output "instance_name" {
  description = "Name of Netweaver instance"
  value       = google_compute_instance.gcp_nw.name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = google_compute_instance.gcp_nw.zone
}

output "instance_machine_type" {
  description = "Primary GCE instance/machine type."
  value       = google_compute_instance.gcp_nw.machine_type
}

output "instance_internal_ip" {
  description = "internal IP of instance"
  value       = google_compute_instance.gcp_nw.network_interface.0.network_ip
}

output "instance_external_ip" {
  description = "external IP of instance"
  value = (
    length(google_compute_instance.gcp_nw.network_interface[0].access_config) != 0 ? (
      google_compute_instance.gcp_nw.network_interface[0].access_config[0].nat_ip
    ) : ""
  )
}

output "instance_attached_disks_sapmnt" {
  value = google_compute_disk.gcp_nw_pd_0.name
}

output "instance_attached_disks_usrsap" {
  value = google_compute_disk.gcp_nw_pd_1.name
}

output "instance_attached_disks_swap" {
  value = google_compute_disk.gcp_nw_pd_2.name
}

output "device_name_usr_sap" {
  value = local.device_name_1
}

output "device_name_sapmnt" {
  value = local.device_name_2
}

output "device_name_swap" {
  value = local.device_name_3
}
