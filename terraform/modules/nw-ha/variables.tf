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

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = ""
}

variable "zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
  default     = "us-central1"
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "s4hanaslbg"
}

variable "instance_type" {
  description = "The GCE instance/machine type."
  default     = "n1-standard-8"
}

variable "source_image_family" {
  description = "Source image family."
}

variable "source_image_project" {
  description = "Source image project."
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = true
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
  default     = 30
}

variable "boot_disk_type" {
  description = "The GCE boot disk type.Set to pd-standard (for PD HDD)."
  default     = "pd-ssd"
}

variable "usr_sap_size" {
  description = "Persistent disk size in GB"
  default     = 100
}


variable "swap_size" {
  description = "Persistent disk size in GB."
  default     = 30
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "post_deployment_script" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "target_size" {
  description = "The target number of running instances for the unmanaged instance group."
  default     = 1
}

variable "pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used."
  default     = null
}

variable "public_key_path" {
  description = ""
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  description = ""
}
