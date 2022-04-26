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

variable "org_id" {}
variable "folder_id" {}
variable "billing_account_id" {}

module "test_setup" {
  source             = "../../../../../terraform/modules/test-setup"
  project_name       = "hanaha-20SPS03-rh-7-6"
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  subnets = [{
    subnet_name   = "hana-ha-rh-7-6"
    subnet_ip     = "10.10.0.0/24"
    subnet_region = "us-west1"
  }]
}
output "setup_output" {
  sensitive = true
  value     = module.test_setup
}
output "subnetwork" {
  value = module.test_setup.vpc
}
output "private_key_openssh" {
  sensitive = true
  value     = module.test_setup.private_key_openssh
}
output "public_key_openssh" {
  value = module.test_setup.public_key_openssh
}
output "bastion_ip" {
  value = module.test_setup.bastion_ip
}
output "region" {
  value = module.test_setup.region
}
output "sap_service_account" {
  value = module.test_setup.sap_service_account
}
output "media_bucket" {
  value = module.test_setup.media_bucket
}
output "project_id" {
  value = module.test_setup.project_id
}