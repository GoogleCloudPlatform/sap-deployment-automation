variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = "albatross-duncanl-sandbox-2"
}

variable "zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "saphanasles-bg"
}

variable "instance_type" {
  description = "The GCE instance/machine type."
  default     = "n1-highmem-32"
}

variable "linux_image_family" {
  description = "GCE linux image family."
  default     = "rhel-7-7-sap-ha"
}

variable "linux_image_project" {
  description = "Project name containing the linux image."
  default     = "rhel-sap-cloud"
}

variable "sap_install_files_bucket" {
  description = "SAP install files GCE bucket name"
  default     = "nw-ansible"
}

variable "sap_hostagent_file_name" {
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

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = 100
}

variable "pd_hdd_size" {
  description = "Persistent disk size in GB."
  default     = 100
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
  default     = "terraform-managed-sa@albatross-duncanl-sandbox-2.iam.gserviceaccount.com"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = "app2"
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

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket."
  default     = "sap-hana-single-node-bkt"
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
  description = "SAP HANA System Identifier"
  default     = "D10"
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
  default     = 1
}

variable "sap_hana_sidadm_password" {
  description = "SAP HANA System Identifier Admin password"
  default     = "Google123"
}

variable "sap_hana_system_password" {
  description = "SAP HANA system password"
  default     = "Google123"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
  default     = 900
}

variable "public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
  default     = true
}

variable "gce_ssh_user" {
  description = "GCE ssh user"
  default     = "balaguduru"
}

variable "gce_ssh_pub_key_file" {
  description = "GCE ssh user pub key file name"
  default     = "~/.ssh/id_rsa.pub"
}
