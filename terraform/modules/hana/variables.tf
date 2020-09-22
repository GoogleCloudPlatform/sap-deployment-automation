variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "source_image_family" {
  description = "GCE image family."
}

variable "source_image_project" {
  description = "Project name containing the linux image."
}

variable "sap_install_files_bucket" {
  description = "SAP install files GCE bucket name"
}

variable "sap_hostagent_rpm_file_name" {
  description = "SAP Host agent filename"
}

variable "sap_hana_bundle_file_name" {
  description = "SAP Hana deployment bundle filename"
}

variable "sap_hana_sapcar_file_name" {
  description = "SAPCAR filename"
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = "false"
}

variable "disk_name_0" {
  description = "Name of first disk."
  default     = "hana0"
}

variable "disk_name_1" {
  description = "Name of second disk."
  default     = "hana1"
}

variable "disk_type_0" {
  description = "The GCE data disk type. May be set to pd-ssd."
  default     = "pd-ssd"
}

variable "disk_type_1" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD)."
  default     = "pd-standard"
}

variable "boot_disk_size" {
  description = "Root disk size in GB."
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
  default     = "pd-standard"
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB."
  default     = ""
}

variable "pd_hdd_size" {
  description = "Persistent disk size in GB."
  default     = ""
}

variable "device_name_pd_ssd" {
  description = "device name for ssd persistant disk"
  default     = "data"
}

variable "device_name_pd_hdd" {
  description = "device name for standard persistant disk"
  default     = "backup"
}

variable "pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.."
  default     = null
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
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

variable "use_public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
  default     = "balaguduru"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
  default     = "~/.ssh/id_rsa.pub"
}
