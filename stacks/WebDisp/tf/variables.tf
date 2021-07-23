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
}

variable "zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "sap_wd_instance_name" {
  description = "A unique name for the Web Dispatcher instance. Changing this forces a new resource to be created."
}

variable "sap_wd_instance_type" {
  description = "The GCE instance/machine type for Web Dispatcher."
  default     = "n1-standard-2"
}

variable "source_image_family" {
  description = "GCE source_image family."
  default     = "rhel-7-7-sap-ha"
}

variable "source_image_project" {
  description = "Project name containing the source image."
  default     = "rhel-sap-cloud"
}

variable "sap_wd_install_files_bucket" {
  description = "SAP Web Dispatcher install files GCE bucket name"
  default     = "juliorg-sap-iac"
}

variable "sap_hostagent_rpm_file_name" {
  description = "SAP Host agent filename"
  default     = "saphostagentrpm_44-20009394.rpm"
}

variable "sap_wd_sapcar_file_name" {
  description = "SAPCAR filename"
  default     = "SAPCAR_1320-80000935.EXE"
}

variable "sap_wd_autodelete_boot_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
}

variable "sap_wd_boot_disk_size" {
  description = "Root disk size in GB for Web Dispatcher."
  default     = 20
}

variable "sap_wd_boot_disk_type" {
  description = "The GCE boot disk type for Web Dispatcher. Set to pd-standard (for PD SSD)."
  default     = "pd-ssd"
}

variable "sap_wd_additional_disk_type" {
  description = "The GCE disk type for Web Dispatcher. Set to pd-standard (for PD SSD)."
  default     = "pd-ssd"
}

variable "sap_wd_usrsap_disk_size" {
  description = "Size of /usr/sap for Web Dispatcher."
  default     = 10
}

variable "sap_wd_sapmnt_disk_size" {
  description = "Size of /sapmnt for Web Dispatcher."
  default     = 20
}

variable "sap_wd_swap_disk_size" {
  description = "Size of swap for Web Dispatcher."
  default     = 20
}

variable "sap_wd_service_account_email" {
  description = "Email of service account to attach to the Web Dispatcher instance."
}

variable "subnetwork_wd" {
  description = "The name or self_link of the wd subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = "app2"
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "sap_wd_network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "sap_wd_use_public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
  default     = "~/.ssh/id_rsa.pub"
}
