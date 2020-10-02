/**
 * Copyright 2020 Google LLC
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

provider "google" {
}

module "gcp_netweaver_ascs" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.ascs_instance_name
  zone                  = var.ascs_zone
  ssh_user              = var.gce_ssh_user
  region                = var.region
  project_id            = var.project_id
  public_key_path       = var.gce_ssh_pub_key_file
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  network_tags          = var.network_tags
  usr_sap_size          = var.usr_sap_size
  swap_size             = var.swap_size
  instance_type         = var.instance_type
  boot_disk_size        = var.boot_disk_size
  service_account_email = var.service_account_email
}

module "gcp_netweaver_ers" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.ers_instance_name
  zone                  = var.ers_zone
  project_id            = var.project_id
  region                = var.region
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  network_tags          = var.network_tags
  usr_sap_size          = var.usr_sap_size
  swap_size             = var.swap_size
  instance_type         = var.instance_type
  boot_disk_size        = var.boot_disk_size
  service_account_email = var.service_account_email
}

module "gcp_netweaver_pas" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.pas_instance_name
  zone                  = var.pas_zone
  project_id            = var.project_id
  region                = var.region
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  subnetwork            = var.subnetwork
  subnetwork_project    = var.subnetwork_project
  source_image_family   = var.source_image_family
  network_tags          = var.network_tags
  source_image_project  = var.source_image_project
  usr_sap_size          = var.usr_sap_size
  swap_size             = var.swap_size
  instance_type         = var.instance_type
  boot_disk_size        = var.boot_disk_size
  service_account_email = var.service_account_email
}

module "sap_ascs_ilb" {
  source       = "../../../terraform/modules/terraform-google-lb-internal"
  project      = var.project_id
  region       = var.region
  network      = var.network
  subnetwork   = var.subnetwork
  name         = "${var.ascs_instance_name}-ilb"
  source_tags  = ["soure-tag"]
  target_tags  = ["target-tag"]
  ports        = var.ports
  all_ports    = var.all_ports
  network_project = var.subnetwork_project
  health_check = local.ascs_health_check
  backends = [
    {
      group       = module.gcp_netweaver_ascs.primary_umig_group_link
      description = "Primary instance backend group"
      failover    = true
    },
    {
      group       = module.gcp_netweaver_ers.primary_umig_group_link
      description = "failover instance backend group"
      failover    = false
    }
  ]
}

module "sap_ers_ilb" {
  source       = "../../../terraform/modules/terraform-google-lb-internal"
  project      = var.project_id
  region       = var.region
  network      = var.network
  subnetwork   = var.subnetwork
  name         = "${var.ers_instance_name}-ilb"
  source_tags  = ["soure-tag"]
  target_tags  = ["target-tag"]
  ports        = var.ports
  all_ports    = var.all_ports
  health_check = local.ers_health_check
  backends = [
    {
      group       = module.gcp_netweaver_ers.primary_umig_group_link
      description = "Primary instance backend group"
      failover    = true
    },
    {
      group       = module.gcp_netweaver_ascs.primary_umig_group_link
      description = "failover instance backend group"
      failover    = false
    }
  ]
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = var.region
  project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
}
