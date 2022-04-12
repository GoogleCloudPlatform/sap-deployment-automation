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

module "nw_db2_std_105FP9" {
  source             = "../../modules/test-setup"
  project_name       = "nw-db2-std-105fp9"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "nw-db2"
  subnets = [
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.0.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "11.10.1.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.2.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.3.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.4.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.5.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.6.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.7.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.8.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.9.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw_db2_std_105FP9" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw_db2_std_105FP9.media_bucket}/
EOT
  }
  depends_on = [module.nw_db2_std_105FP9]
}

module "nw_db2_std_111MP4FP6" {
  source             = "../../modules/test-setup"
  project_name       = "nw-db2-std-111mp4fp6"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "nw-db2"
  subnets = [
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.10.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.11.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.12.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.13.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.14.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.15.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.16.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.17.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.18.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.19.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw_db2_std_111MP4FP6" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw_db2_std_111MP4FP6.media_bucket}/
EOT
  }
  depends_on = [module.nw_db2_std_111MP4FP6]
}


module "nw_db2_std_115MP5FP1" {
  source             = "../../modules/test-setup"
  project_name       = "nw-db2-std-115mp5fp1"
  random_suffix      = false
  org_id             = var.org_id
  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id
  network_name       = "nw-db2"
  subnets = [
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.21.0/24"
      subnet_region         = "us-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.22.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.23.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.24.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.25.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.26.0/24"
      subnet_region         = "us-west3"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.27.0/24"
      subnet_region         = "us-west4"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.28.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    },
    {
      subnet_name           = "nw-db2"
      subnet_ip             = "10.11.29.0/24"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
  ]
}

resource "null_resource" "copy_install_media_nw_db2_std_115MP5FP1" {
  triggers = {
    id = md5(var.billing_account_id)
  }
  provisioner "local-exec" {
    command = <<EOT
gsutil -q -m cp -r  gs://${var.media_bucket}/* gs://${module.nw_db2_std_115MP5FP1.media_bucket}/
EOT
  }
  depends_on = [module.nw_db2_std_115MP5FP1]
}