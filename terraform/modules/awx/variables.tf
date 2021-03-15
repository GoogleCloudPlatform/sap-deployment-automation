/**
 * Copyright 2021 Google LLC
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

variable "assign_public_ip" {
  type           = bool
  description    = "Whether or not to assign a public IP to instance."
  default        = false
}

variable "machine_type" {
  type           = string
  description    = "Type of machine."
  default        = "n1-standard-2"
}

variable "nat_create" {
  type           = bool
  description    = "Whether or not to create a Cloud NAT instance."
  default        = false
}

variable "instance_name" {
  type           = string
  description    = "Name of instance."
}

variable "project_id" {
  type           = string
  description    = "ID of project where instance is located."
}

variable "region" {
  type           = string
  description    = "Region where instance is located."
  default        = "us-central1"
}

variable "subnetwork" {
  type           = string
  description    = "Subnetwork of instance's network interface."
}

variable "subnetwork_project_id" {
  type           = string
  description    = "Project ID where instance subnetwork is located."
  default        = ""
}

variable "source_image_family" {
  type           = string
  description    = "Family of disk source image."
  default        = "sap-awx"
}

variable "source_image_project" {
  type           = string
  description    = "Project of disk source image."
  default        = "albatross-duncanl-sandbox-2"
}

variable "tags" {
  type           = list(string)
  description    = "List of network tags to assign to instance, in addition to the tag `awx`."
  default        = []
}
