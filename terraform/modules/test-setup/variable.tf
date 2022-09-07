/**
 * Copyright 2022 Google LLC
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

variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID"
  type        = string
}

variable "folder_id" {
  description = "ID of the folder where test projects will be created"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "sap-iac-int-test"
}

variable "random_suffix" {
  type    = bool
  default = true
}

variable "network_name" {
  type    = string
  default = "test-vpc"
}

variable "firewall_rules" {
  type        = any
  description = "List of firewall rules"
  default     = []
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [{
    subnet_name   = "test-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = "us-west1"
  }]
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "region" {
  default = "us-west1"
}

variable "network_tags" {
  type    = list(string)
  default = ["sap-allow-all"]
}

variable "tf_state_bucket_suffix" {
  type        = string
  default     = "tf-state"
  description = "State bucket for forminator will have a name in the format {project_id}-{tf_state_bucket_suffix}"
}

variable "bastion_sa" {
  type        = string
  default     = "bastion-test-setup"
  description = "Bastion SA to be created"
}

variable "bastion_instance_name" {
  type        = string
  default     = "bastion-vm-test-setup"
  description = "Bastion VM name"
}
