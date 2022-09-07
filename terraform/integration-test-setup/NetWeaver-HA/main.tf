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

module "nw750_20sps03" {
  source             = "../../modules/test-setup"
  project_name       = "nw-ha-750-20sps03"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "hana-ha"
  subnets = [
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.0.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.1.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.2.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.3.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.4.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.5.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.6.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.7.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.8.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.9.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw750_20sps03" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw750_20sps03.media_bucket}/
EOT
  }
  depends_on = [module.nw750_20sps03]
}

module "nw750_20sps04" {
  source             = "../../modules/test-setup"
  project_name       = "nw-ha-750-20sps04"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "hana-ha"
  subnets = [
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.10.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.11.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.12.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.13.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.14.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.15.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.16.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.17.0/24"
      subnet_region         = "northamerica-northeast2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.18.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.19.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw750_20sps04" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw750_20sps04.media_bucket}/
EOT
  }
  depends_on = [module.nw750_20sps04]
}


module "nw750_20sps05" {
  source             = "../../modules/test-setup"
  project_name       = "nw-ha-750-20sps05"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "hana-ha"
  subnets = [
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.21.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.22.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.23.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.24.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.25.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.26.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.27.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.28.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-ha"
      subnet_ip             = "10.8.29.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw750_20sps05" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw750_20sps05.media_bucket}/
EOT
  }
  depends_on = [module.nw750_20sps05]
}