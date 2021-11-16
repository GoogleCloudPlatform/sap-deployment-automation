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

variable "sap_hana_instance_name" {
  description = "A unique name for the HANA instance. Changing this forces a new resource to be created."
}

variable "sap_nw_instance_name" {
  description = "A unique name for the HANA instance. Changing this forces a new resource to be created."
}

variable "sap_hana_instance_type" {
  description = "The GCE instance/machine type for HANA."
  default     = "n1-highmem-32"
}

variable "sap_nw_instance_type" {
  description = "The GCE instance/machine type for NetWeaver."
  default     = "n1-highmem-32"
}

variable "source_image_family" {
  description = "GCE source_image family."
  default     = "rhel-7-7-sap-ha"
}

variable "source_image_project" {
  description = "Project name containing the source image."
  default     = "rhel-sap-cloud"
}

variable "sap_hana_install_files_bucket" {
  description = "SAP HANA install files GCE bucket name"
}

variable "sap_hostagent_rpm_file_name" {
  description = "SAP Host agent filename"
  default     = "saphostagentrpm_44-20009394.rpm"
}

variable "sap_hana_bundle_file_name" {
  description = "SAP Hana deployment bundle filename"
  default     = "IMDB_SERVER20_047_0-80002031.SAR"
}

variable "sap_hana_sapcar_file_name" {
  description = "SAPCAR filename"
  default     = "SAPCAR_1320-80000935.EXE"
}

variable "sap_hana_autodelete_boot_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
}

variable "sap_nw_autodelete_boot_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
}

variable "sap_hana_boot_disk_size" {
  description = "Root disk size in GB for HANA."
  default     = 30
}

variable "sap_hana_boot_disk_type" {
  description = "The GCE boot disk type for HANA. Set to pd-standard (for PD HDD)."
  default     = "pd-ssd"
}

variable "sap_hana_pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.."
}

variable "sap_hana_create_backup_volume" {
  description = "Create backup SAP volume"
}

variable "sap_nw_boot_disk_size" {
  description = "Root disk size in GB for NetWeaver."
  default     = 30
}

variable "sap_nw_boot_disk_type" {
  description = "The GCE boot disk type for NetWeaver. Set to pd-standard (for PD HDD)."
  default     = "pd-ssd"
}

variable "sap_nw_additional_disk_type" {
  description = "The GCE disk type for NetWeaver. Set to pd-standard (for PD HDD)."
  default     = "pd-ssd"
}

variable "sap_hana_additional_disk_type" {
  description = "The GCE additional disk type for HANA. Set to pd-ssd (for PD SSD)."
}

variable "sap_nw_usrsap_disk_size" {
  description = "Size of /usr/sap for NetWeaver."
  default     = 150
}

variable "sap_nw_sapmnt_disk_size" {
  description = "Size of /sapmnt for NetWeaver."
  default     = 150
}

variable "sap_nw_swap_disk_size" {
  description = "Size of swap for NetWeaver."
  default     = 30
}

variable "sap_hana_service_account_email" {
  description = "Email of service account to attach to the HANA instance."
}

variable "sap_nw_service_account_email" {
  description = "Email of service account to attach to the NetWeaver instance."
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

variable "sap_hana_network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "sap_nw_network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "sap_nw_use_public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
  default     = "~/.ssh/id_rsa.pub"
}
