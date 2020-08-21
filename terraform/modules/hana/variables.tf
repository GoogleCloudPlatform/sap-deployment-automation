variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "linux_image_family" {
  description = "GCE image family."
}

variable "linux_image_project" {
  description = "Project name containing the linux image."
}

variable "sap_install_files_bucket" {
  description = "SAP install files GCE bucket name"
}

variable "sap_hostagent_file_name" {
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
  default     = "albatross-duncanl-sandbox-2"
}

variable "network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
  default     = true
}

variable "address_name" {
  description = "Name of static IP adress to add to the instance's access config."
  default     = ""
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket."
}

variable "sap_deployment_debug" {
  description = "Debug flag for SAP HANA deployment."
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "sap_hana_sid" {
  description = "SAP HANA System Identifier. When using the SID to enter a user session, like this for example, `su - [SID]adm`, make sure that [SID] is in lower case."
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
}

variable "sap_hana_sidadm_password" {
  description = "SAP HANA System Identifier Admin password"
}

variable "sap_hana_system_password" {
  description = "SAP HANA system password"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
  default     = "balaguduru"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
  default     = "~/.ssh/id_rsa.pub"
}