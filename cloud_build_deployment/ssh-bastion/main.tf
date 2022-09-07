# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "project" {}
variable "network" {}
variable "zone" {}
variable "ssh_pub_key" {}
variable "subnetwork" {}
variable "subnetwork_project_id" {}
variable "bastion_instance_name" {
  default = "ssh-bastion-vm"
}

terraform {
  backend "gcs" {}
}

module "test_setup" {
  source                = "../../terraform/modules/ssh-bastion"
  project               = var.project
  network               = var.network
  subnetwork            = var.subnetwork
  public_ssh            = var.ssh_pub_key
  zone                  = var.zone
  subnetwork_project_id = var.subnetwork_project_id
  bastion_instance_name = var.bastion_instance_name
}

output "bastion_ip" {
  value = module.test_setup.bastion_ip
}

output "export_variables" {
  value = module.test_setup.export_variables
}