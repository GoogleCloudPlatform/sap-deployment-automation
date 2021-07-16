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

variable "auto_delete_disk_boot" {
  type        = bool
  description = "Whether or not the boot disk will be auto-deleted when the instance is deleted."
  default     = true
}

variable "disk_size_boot" {
  type        = number
  description = "The size of the boot disk in GB."
  default     = 30
}

variable "disk_size_db2" {
  type        = number
  description = "The size of the db2 disk in GB."
  default     = 50
}

variable "disk_size_sapmnt" {
  type        = number
  description = "The size of the sapmnt disk in GB."
  default     = 25
}

variable "disk_size_swap" {
  type        = number
  description = "The size of the swap disk in GB."
  default     = 25
}

variable "disk_size_usrsap" {
  type        = number
  description = "The size of the usrsap disk in GB."
  default     = 25
}

variable "disk_type_boot" {
  type        = string
  description = "The type of the boot disk."
  default     = "pd-ssd"
}

variable "disk_type_db2" {
  type        = string
  description = "The type of the db2 disk."
  default     = "pd-ssd"
}

variable "disk_type_sapmnt" {
  type        = string
  description = "The type of the sapmnt disk."
  default     = "pd-ssd"
}

variable "disk_type_swap" {
  type        = string
  description = "The type of the swap disk."
  default     = "pd-ssd"
}

variable "disk_type_usrsap" {
  type        = string
  description = "The type of the usrsap disk."
  default     = "pd-ssd"
}

variable "instance_basename_as" {
  type        = string
  description = "The base name for application server instances. Names will have a count suffix appended."
}

variable "instance_name_db2" {
  type        = string
  description = "The name of the DB2 instance."
}

variable "instance_name_ascs" {
  type        = string
  description = "The name of the ASCS instance."
}

variable "instance_type_as" {
  type        = string
  description = "The machine type of the application server instance."
}

variable "instance_type_ascs" {
  type        = string
  description = "The machine type of the ASCS instance."
}

variable "instance_type_db2" {
  type        = string
  description = "The machine type of the DB2 instance."
}

variable "num_instances_as" {
  type        = number
  description = "The number of application server instances. The first will be the PAS, others will be AAS."
  default     = 1
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resources will be located."
}

variable "network_tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance."
  default     = []
}

variable "service_account_email" {
  type        = string
  description = "Email of the service account to attach to the instance."
}

variable "service_account_scopes" {
  type        = list(string)
  description = "Scopes of the service account."
  default     = ["cloud-platform"]
}

variable "source_image" {
  type        = string
  description = "The source image for all disks. One of source_image or source_image_family must be provided."
  default     = ""
}

variable "source_image_family" {
  type        = string
  description = "The source image family for all disks. One of source_image or source_image_family must be provided. This is ignored if source_image is defined."
  default     = ""
}

variable "source_image_project_id" {
  type        = string
  description = "The project in which source_image or source_image_family are located."
}

variable "ssh_pub_key_file" {
  type        = string
  description = "The local path to the ssh public key file, to be used for ssh-keys metadata."
}

variable "ssh_user" {
  type        = string
  description = "The ssh user, to be used for ssh-keys metadata."
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork where instances will be located."
}

variable "subnetwork_project_id" {
  type        = string
  description = "The project of the subnetwork, defaults to project_id."
  default     = ""
}

variable "zone" {
  type        = string
  description = "The zone in which the instances will be located."
}
