variable "netweaver_sid" {
  description = "The SID for NetWeaver"
  default = "SL2"
}

variable "ascs_instance_number" {
  description = "The instance number for the ASCS installation"
  default = "03"
}

variable "ers_instance_number" {
  description = "The instance number for the ERS installation"
  default = "13"
}

variable "ports" {
 default  = null
}

variable "all_ports" {
 default = true
}

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
  default     = "albatross-duncanl-sandbox-2"
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
  default     = "us-central1"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
  default     = "app2"
}

variable "network" {
  description = "The name or self_link of the network where the isntance will be deployed. The network must exist in the same region this instance will be created in."
  default     = "netweaver"
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