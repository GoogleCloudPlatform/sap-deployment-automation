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

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "source_image_family" {
  description = "GCE linux image family."
}

variable "source_image_project" {
  description = "Project name containing the linux image."
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  description = "The GCE boot disk type.Set to pd-standard (for PD HDD)."
}

variable "additional_disk_type" {
  description = "The GCE additional disk type.Set to pd-ssd (for PD SSD)."
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
}

variable "network_tags" {
  description = "List of network tags to attach to the instance."
}

variable "pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.."
}

variable "create_backup_volume" {
  description = "Create backup SAP volume"
}
