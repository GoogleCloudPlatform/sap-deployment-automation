variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone to to deploy resources"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "subnetwork_project" {
  description = "The name or self_link of the subnetwork project where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "network_tags" {
  description = "List of network tags to attach to the firewall rule."
}

variable "sap_service_account_name" {
  description = "SAP service account name."
}

variable "nat_create" {
  description = "Create NAT instance (true/false)"
}
