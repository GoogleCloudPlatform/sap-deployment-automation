variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = "albatross-duncanl-sandbox-2"
}

variable "instance_count_worker" {
  type        = number
  description = "No. of worker instances"
  default     = 0
}

variable "zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "create_backup_volume" {
  type        = bool
  description = "The zone that the instance should be created in."
  default     = true
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
  default     = "us-central1"
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "hanslbg"
}

variable "instance_type" {
  description = "The GCE instance/machine type."
  default     = "n1-highmem-32"
}

variable "source_image_family" {
  description = "GCE linux image family."
  default     = "rhel-7-7-sap-ha"
}

variable "source_image_project" {
  description = "Project name containing the linux image."
  default     = "rhel-sap-cloud"
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

variable "network" {
  description = "The name or self_link of the network where the isntance will be deployed. The network must exist in the same region this instance will be created in."
  default     = "netweaver"
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

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket."
  default     = "sap-hana-single-node-bkt"
}

variable "run_provisioner" {
  type        = bool
  description = "Whether or not to run the Ansible provisioner"
  default     = true
}

variable "pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.."
  default     = null
}

variable "gce_ssh_pub_key_file" {
  description = ""
  default     = "~/.ssh/id_rsa.pub"
}

variable "gce_ssh_user" {
  description = ""
  default     = "balaguduru"
}
