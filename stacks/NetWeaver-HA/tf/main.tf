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

module "hana_ha" {
  source                = "../../../terraform/modules/hana-ha"
  instance_name         = var.hana_instance_name
  instance_type         = var.hana_instance_type
  project_id            = var.project_id
  primary_zone          = var.primary_zone
  secondary_zone        = var.secondary_zone
  gce_ssh_user          = var.gce_ssh_user
  gce_ssh_pub_key_file  = var.gce_ssh_pub_key_file
  service_account_email = var.hana_service_account_email
  subnetwork            = var.subnetwork_hana
  subnetwork_project    = local.subnetwork_project_hana
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  boot_disk_size        = var.hana_boot_disk_size
  boot_disk_type        = var.hana_boot_disk_type
  autodelete_disk       = var.hana_autodelete_boot_disk
  network_tags          = var.hana_network_tags
  target_size           = 1
  pd_kms_key            = var.hana_pd_kms_key
  create_backup_volume  = var.hana_create_backup_volume
}

module "netweaver_ascs" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.ascs_instance_name
  zone                  = var.primary_zone
  ssh_user              = var.gce_ssh_user
  project_id            = var.project_id
  public_key_path       = var.gce_ssh_pub_key_file
  region                = local.region
  subnetwork            = var.subnetwork_nw
  subnetwork_project    = local.subnetwork_project_nw
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  usr_sap_size          = var.nw_usrsap_disk_size
  swap_size             = var.nw_swap_disk_size
  instance_type         = var.nw_instance_type
  boot_disk_size        = var.nw_boot_disk_size
  autodelete_disk       = var.nw_autodelete_boot_disk
  network_tags          = var.nw_network_tags
  service_account_email = var.nw_service_account_email
}

module "netweaver_ers" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.ers_instance_name
  zone                  = var.secondary_zone
  project_id            = var.project_id
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  region                = local.region
  subnetwork            = var.subnetwork_nw
  subnetwork_project    = local.subnetwork_project_nw
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  usr_sap_size          = var.nw_usrsap_disk_size
  swap_size             = var.nw_swap_disk_size
  instance_type         = var.nw_instance_type
  boot_disk_size        = var.nw_boot_disk_size
  autodelete_disk       = var.nw_autodelete_boot_disk
  network_tags          = var.nw_network_tags
  service_account_email = var.nw_service_account_email
}

module "netweaver_pas" {
  source                = "../../../terraform/modules/nw-ha"
  instance_name         = var.pas_instance_name
  zone                  = var.primary_zone
  project_id            = var.project_id
  ssh_user              = var.gce_ssh_user
  public_key_path       = var.gce_ssh_pub_key_file
  region                = local.region
  subnetwork            = var.subnetwork_nw
  subnetwork_project    = local.subnetwork_project_nw
  source_image_family   = var.source_image_family
  source_image_project  = var.source_image_project
  usr_sap_size          = var.nw_usrsap_disk_size
  swap_size             = var.nw_swap_disk_size
  instance_type         = var.nw_instance_type
  boot_disk_size        = var.nw_boot_disk_size
  autodelete_disk       = var.nw_autodelete_boot_disk
  network_tags          = var.nw_network_tags
  service_account_email = var.nw_service_account_email
}

module "ascs_ilb" {
  source          = "../../../terraform/modules/terraform-google-lb-internal"
  project         = var.project_id
  network_project = local.subnetwork_project
  region          = local.region
  network         = local.network_nw
  subnetwork      = var.subnetwork_nw
  name            = "${var.ascs_instance_name}-ilb"
  source_tags     = ["soure-tag"]
  target_tags     = ["target-tag"]
  ports           = var.ports
  all_ports       = var.all_ports
  health_check    = local.ascs_health_check
  backends = [
    {
      group       = module.netweaver_ascs.primary_umig_group_link
      description = "Primary instance backend group"
      failover    = false
    },
    {
      group       = module.netweaver_ers.primary_umig_group_link
      description = "failover instance backend group"
      failover    = true
    }
  ]
}

module "ers_ilb" {
  source          = "../../../terraform/modules/terraform-google-lb-internal"
  project         = var.project_id
  network_project = local.subnetwork_project
  region          = local.region
  network         = local.network_nw
  ilb_required    = local.ilb_required
  subnetwork      = var.subnetwork_nw
  name            = "${var.ers_instance_name}-ilb"
  source_tags     = ["soure-tag"]
  target_tags     = ["target-tag"]
  ports           = var.ports
  all_ports       = var.all_ports
  health_check    = local.ers_health_check
  backends = [
    {
      group       = module.netweaver_ers.primary_umig_group_link
      description = "Primary instance backend group"
      failover    = false
    },
    {
      group       = module.netweaver_ascs.primary_umig_group_link
      description = "failover instance backend group"
      failover    = true
    }
  ]
}

data "google_compute_subnetwork" "subnetwork_hana" {
  name    = var.subnetwork_hana
  region  = local.region
  project = local.subnetwork_project_hana
}

data "google_compute_subnetwork" "subnetwork_nw" {
  name    = var.subnetwork_nw
  region  = local.region
  project = local.subnetwork_project_nw
}

resource "google_compute_address" "gcp_sap_s4hana_alias_ip" {
  count        = local.ilb_required == false ? 1 : 0
  name         = "${var.ers_instance_name}-ip"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork_nw
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}
