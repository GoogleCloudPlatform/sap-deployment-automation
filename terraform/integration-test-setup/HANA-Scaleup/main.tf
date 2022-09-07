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

module "hana_scaleup_20sps03" {
  source             = "../../modules/test-setup"
  project_name       = "hana-scaleup-20sps03"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "scaleup"
  subnets = [
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.0.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.1.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.2.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.3.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.4.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.5.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.6.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.7.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.8.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.9.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_hana_scaleup_20sps03" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.hana_scaleup_20sps03.media_bucket}/
EOT
  }
  depends_on = [module.hana_scaleup_20sps03]
}

module "hana_scaleup_20sps04" {
  source             = "../../modules/test-setup"
  project_name       = "hana-scaleup-20sps04"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "scaleup"
  subnets = [
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.10.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.11.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.12.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.13.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.14.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.15.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.16.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.17.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.18.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.19.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_hana_scaleup_20sps04" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.hana_scaleup_20sps04.media_bucket}/
EOT
  }
  depends_on = [module.hana_scaleup_20sps04]
}


module "hana_scaleup_20sps05" {
  source             = "../../modules/test-setup"
  project_name       = "hana-scaleup-20sps05"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "scaleup"
  subnets = [
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.21.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.22.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.23.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.24.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.25.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.26.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.27.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.28.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "hana-scaleup"
      subnet_ip             = "10.9.29.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_hana_scaleup_20sps05" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.hana_scaleup_20sps05.media_bucket}/
EOT
  }
  depends_on = [module.hana_scaleup_20sps05]
}