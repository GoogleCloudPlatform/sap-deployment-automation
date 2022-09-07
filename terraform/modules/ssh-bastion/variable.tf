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

variable "project" {
  description = "Project ID"
  type        = string
}

variable "public_ssh" {
  description = "Path to the public ssh key"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "subnetwork_project_id" {
  description = "Project ID of the subnetwork"
  type        = string
}

variable "network" {
  description = "VPC name"
  type        = string
}

variable "random_suffix" {
  type    = bool
  default = true
}

variable "zone" {
  description = "Zone where to deploy"
  type        = string
}

variable "bastion_sa" {
  type        = string
  default     = "ssh-bastion"
  description = "Bastion SA to be created"
}

variable "bastion_instance_name" {
  type        = string
  default     = "ssh-bastion-vm"
  description = "Bastion VM name"
}