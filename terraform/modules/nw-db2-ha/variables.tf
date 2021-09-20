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
  description = "Whether or not to delete the boot disk when the machine is deleted."
  default     = true
}

variable "disk_size_boot" {
  type        = number
  description = "Size of boot disk."
  default     = 30
}

variable "disk_size_db2" {
  type        = number
  description = "Size of db2 disk in GB."
  default     = 50
}

variable "disk_size_swap" {
  type        = number
  description = "Size of swap disk in GB."
  default     = 25
}

variable "disk_size_usrsap" {
  type        = number
  description = "Size of usrsap disk in GB."
  default     = 25
}

variable "disk_type_boot" {
  type        = string
  description = "Type of boot disk."
  default     = "pd-ssd"
}

variable "disk_type_db2" {
  type        = string
  description = "Type of db2 disk."
  default     = "pd-ssd"
}

variable "disk_type_swap" {
  type        = string
  description = "Type of swap disk."
  default     = "pd-ssd"
}

variable "disk_type_usrsap" {
  type        = string
  description = "Type of usrsap disk."
  default     = "pd-ssd"
}

variable "ers_ilb_required" {
  type        = bool
  description = "Whether or not to create an ILB for ERS."
  default     = true
}

variable "filestore_name" {
  type        = string
  description = "Name of Cloud Filestore instance. If empty string then no Filestore instance is created."
  default     = ""
}

variable "filestore_network" {
  type        = string
  description = "Network of Cloud Filestore instance. If empty string then the VM instance network will be used. If instances use a shared network and filestore_name is defined, then this must also be defined, as Filestore instances cannot use a shared network."
  default     = ""
}

variable "filestore_size" {
  type        = number
  description = "Size of Cloud Filestore in GiB. Must be at least 1024 for standard tier and 2560 for premium tier."
  default     = 1024
}

variable "filestore_tier" {
  type        = string
  description = "Tier of Cloud Filestore. Must be one of TIER_UNSPECIFIED, STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, and HIGH_SCALE_SSD"
  default     = "STANDARD"
}

variable "health_check_port_ascs" {
  type = number
  description = "Port used for health checks for ASCS backend."
}

variable "health_check_port_db2" {
  type = number
  description = "Port used for health checks for DB2 backend."
}

variable "health_check_port_ers" {
  type = number
  description = "Port used for health checks for ERS backend."
}

variable "instance_basename_as" {
  type        = string
  description = "Base name for application server instances. Names will have a count suffix appended."
}

variable "instance_name_db2_primary" {
  type        = string
  description = "The name of the primary DB2 instance."
}

variable "instance_name_db2_secondary" {
  type        = string
  description = "The name of the secondary DB2 instance."
}

variable "instance_name_ascs" {
  type        = string
  description = "The name of the ASCS instance."
}

variable "instance_name_ers" {
  type        = string
  description = "The name of the ERS instance."
}

variable "instance_type_as" {
  type        = string
  description = "The application server instance machine type."
}

variable "instance_type_ascs" {
  type        = string
  description = "The ASCS instance machine type."
}

variable "instance_type_db2" {
  type        = string
  description = "The DB2 instance machine type."
}

variable "instance_type_ers" {
  type        = string
  description = "The ERS instance machine type."
}

variable "num_instances_as" {
  type        = number
  description = "Number of application server instances. The first will be the PAS, others will be AAS."
  default     = 1
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resources will be deployed."
}

variable "network_tags" {
  type        = list(string)
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "service_account_email" {
  type        = string
  description = "Email of service account to attach to the instance."
}

variable "service_account_scopes" {
  type        = list(string)
  description = "Scopes of service account."
  default     = ["cloud-platform"]
}

variable "source_image" {
  type        = string
  description = "Source image for the boot disk. One of source_image or source_image_family must be provided."
  default     = ""
}

variable "source_image_family" {
  type        = string
  description = "Source image family for the boot disk. One of source_image or source_image_family must be provided. This is ignored if source_image is defined."
  default     = ""
}

variable "source_image_project_id" {
  type        = string
  description = "Project containing the boot disk image."
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
  description = "The name or self_link of the subnetwork where the instance will be deployed."
}

variable "subnetwork_project_id" {
  type        = string
  description = "The project of the subnetwork, defaults to project_id."
  default     = ""
}

variable "zone_primary" {
  type        = string
  description = "The zone that the primary instances will be created in."
}

variable "zone_secondary" {
  type        = string
  description = "The zone that the secondary instances will be created in."
}
