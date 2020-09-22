variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "sap_hana_instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "sap_hana_instance_type" {
  description = "The GCE instance/machine type."
}

variable "source_image_family" {
  description = "GCE linux image family."
}

variable "source_image_project" {
  description = "Project name containing the linux image."
}

variable "sap_hana_install_files_bucket" {
  description = "SAP install files GCE bucket name"
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

variable "sap_hana_boot_disk_size" {
  description = "Root disk size in GB"
}

variable "sap_hana_boot_disk_type" {
  description = "The GCE boot disk type.Set to pd-standard (for PD HDD)."
}

variable "sap_hana_service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "sap_hana_network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
}

variable "sap_hana_use_public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
}
