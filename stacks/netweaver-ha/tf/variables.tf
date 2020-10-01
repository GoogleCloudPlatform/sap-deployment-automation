variable "netweaver_sid" {
  description = "The SID for NetWeaver"
  default     = "SL2"
}

variable "ascs_instance_number" {
  description = "The instance number for the ASCS installation"
  default     = "03"
}

variable "ers_instance_number" {
  description = "The instance number for the ERS installation"
  default     = "13"
}

variable "ports" {
  default = null
}

variable "all_ports" {
  default = true
}

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = ""
}
variable "ers_healthcheck_port" {
  description = "ers health check port."
}

variable "ascs_healthcheck_port" {
  description = "ascs health check port"
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
  default     = "us-central1"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

variable "network" {
  description = "The name or self_link of the network where the isntance will be deployed. The network must exist in the same region this instance will be created in."
  default     = ""
}

variable "ascs_instance_name" {
  description = "Persistent disk size in GB"
  default     = "s4-ascs"
}

variable "ers_instance_name" {
  description = "Persistent disk size in GB."
  default     = "s4-ers"
}

variable "pas_instance_name" {
  description = "Persistent disk size in GB"
  default     = "gcpsappas"
}


variable "ascs_zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "ers_zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-c"
}

variable "pas_zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-b"
}

variable "gce_ssh_user" {
  description = "SSH user name to connect to your instance."
}

variable "gce_ssh_pub_key_file" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/id_rsa.pub"
}

variable "gce_ssh_priv_key_file" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/id_rsa"
}
variable "instance_type" {
  description = "The GCE instance/machine type."
  default     = "n1-standard-8"
}

variable "source_image_family" {
  description = "GCE linux image family."
  default     = "sles-12-sp3-sap"
}

variable "source_image_project" {
  description = "Project name containing the linux image."
  default     = "suse-sap-cloud"
}
variable "boot_disk_size" {
  description = "Root disk size in GB"
  default     = 30
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
  default     = "terraform-managed-sa@albatross-duncanl-sandbox-2.iam.gserviceaccount.com"
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = ""
}

