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

variable "ports" {
  default = null
}

variable "all_ports" {
  default = true
}

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = ""
}

variable "ers_health_check_port" {
  description = "ers health check port."
}

variable "ascs_health_check_port" {
  description = "ascs health check port"
}

variable "subnetwork_nw" {
  description = "The name or self_link of the nw subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = "app2"
}

variable "subnetwork_hana" {
  description = "The name or self_link of the hana subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = "app2"
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "hana_instance_name" {
}

variable "hana_instance_name_primary" {
}

variable "hana_instance_name_secondary" {
}

variable "ascs_instance_name" {
}

variable "ers_instance_name" {
}

variable "pas_instance_name" {
}

variable "nw_as_num_instances" {
  description = "Number of application server (PAS + AAS) instances"
  default = 1
}

variable "primary_zone" {
  description = "The zone that the primary instances should be created in."
}

variable "secondary_zone" {
  description = "The zone that the secondary instances should be created in."
}

variable "gce_ssh_user" {
  description = "SSH user name to connect to your instance."
}

variable "gce_ssh_pub_key_file" {
  description = "Path to the public SSH key you want to bake into the instance."
}

variable "hana_instance_type" {
  description = "The GCE instance/machine type for HANA."
}

variable "nw_instance_type" {
  description = "The GCE instance/machine type for NetWeaver."
}

variable "source_image_family" {
  description = "GCE linux image family."
}

variable "source_image_project" {
  description = "Project name containing the linux image."
}

variable "hana_boot_disk_size" {
  description = "Boot disk size in GB for HANA."
  type        = number
}

variable "hana_boot_disk_type" {
  description = "Type of boot disk for HANA."
}

variable "hana_autodelete_boot_disk" {
  description = "Whether the HANA boot disk will be auto-deleted when the instance is deleted."
}

variable "hana_create_backup_volume" {
  description = "Whether or not to create a backup volume for HANA."
}

variable "hana_pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks for HANA. If none provided, a Google managed key will be used."
}

variable "hana_network_tags" {
  type        = list
  description = "List of network tags to attach to the HANA instances."
}

variable "nw_network_tags" {
  type        = list
  description = "List of network tags to attach to the NetWeaver instances."
}

variable "nw_boot_disk_size" {
  description = "Boot disk size in GB for NetWeaver."
  type        = number
}

variable "nw_boot_disk_type" {
  description = "Type of boot disk for NetWeaver."
}

variable "nw_autodelete_boot_disk" {
  description = "Whether the NetWeaver boot disk will be auto-deleted when the instance is deleted."
}

variable "nw_usrsap_disk_size" {
  description = "Persistent disk size in GB"
  type        = number
}

variable "nw_swap_disk_size" {
  description = "Persistent disk size in GB."
  type        = number
}

variable "hana_service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "nw_service_account_email" {
  description = "Email of service account to attach to the instance."
}
