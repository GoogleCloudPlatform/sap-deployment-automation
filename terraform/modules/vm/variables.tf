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

variable "access_config" {
  type        = map
  description = "Network access config."
  default     = null
}

variable "boot_disk_device_name" {
  type        = string
  description = "The device name of the boot disk."
  default     = "boot"
}

variable "boot_disk_size" {
  type        = number
  description = "The size of the boot disk in GB."
}

variable "boot_disk_type" {
  type        = string
  description = "The type of the boot disk."
}

variable "boot_disk_auto_delete" {
  type        = bool
  description = "Whether or not the boot disk will be auto-deleted when the instance is deleted."
  default     = true
}

variable "additional_disks" {
  description = <<-EOD
    A list of maps of disks in addition to the boot disk. Each map may have the following keys:
     device_name (string, default null): The name that will be used for the disk device within the instance.
     image (string, default null): The image from which the disk is created.
     labels (map(string), default null): A map of key/value pairs used as labels for the disk.
     mode (string, default "READ_WRITE"): The mode of the disk attachment.
     physical_block_size_bytes (number): The physical block size of the disk in bytes. Must be one of 4096 or 16384.
     size (number): The size of the disk in GB.
     snapshot (string, default null): The snapshot from which the disk is created.
     type (string): The type of the disk.
  EOD
  type           = list(any)
  default        = []
}

variable "instance_name" {
  type        = string
  description = "A unique name for the instance."
}

variable "instance_type" {
  type        = string
  description = "The machine type of the instance."
}

variable "metadata" {
  type        = map
  description = "Metadata to pass to the instance."
  default     = null
}

variable "network_tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance."
  default     = []
}

variable "pd_kms_key" {
  type        = string
  description = "A customer managed encryption key to use for persistent disks. If none is provided, a Google managed key will be used."
  default     = ""
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the instance will be located."
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
  description = "The source image for the boot disk. One of source_image or source_image_family must be provided."
  default     = ""
}

variable "source_image_family" {
  type        = string
  description = "The source image family for the boot disk. One of source_image or source_image_family must be provided. This is ignored if source_image is defined."
  default     = ""
}

variable "source_image_project_id" {
  type        = string
  description = "The project in which source_image or source_image_family are located."
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork where the instance will be located."
}

variable "subnetwork_project_id" {
  type        = string
  description = "The project of the subnetwork, defaults to project_id."
  default     = ""
}

variable "zone" {
  type        = string
  description = "The zone in which the instance will be located."
}
