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

variable "counter" {
  default = 0
}

terraform {
  backend "gcs" {
    bucket = "kevin-zhang-7010-tf-state"
    prefix = "this-project-config"
  }
}

module "test_setup" {
  source             = "../../../terraform/modules/test-setup"
  project_name       = "kevin-zhang"
  org_id             = "998150935773"
  folder_id          = "774539458350"
  billing_account_id = "01B1A8-71DE39-09742B"

  subnets = [{
    subnet_name           = "sap-test-${var.counter}"
    subnet_ip             = "10.74.${var.counter}.0/24"
    subnet_region         = "us-central1"
    subnet_private_access = true
  }]
}

resource "null_resource" "copy_install_media" {
  triggers = {
    id = md5("01B1A8-71DE39-09742B")
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://sap-iac-cicd-deployment-media/* gs://${module.test_setup.media_bucket}/
EOT
  }
  depends_on = [module.test_setup]
}

output "setup_output" {
  sensitive = true
  value     = module.test_setup
}
output "subnetwork" {
  value = module.test_setup.vpc
}
output "region" {
  value = module.test_setup.region
}
output "sap_service_account" {
  value = module.test_setup.sap_service_account_email
}
output "media_bucket" {
  value = module.test_setup.media_bucket
}
output "project_id" {
  value = module.test_setup.project_id
}
