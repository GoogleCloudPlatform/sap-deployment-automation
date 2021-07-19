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

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project_id
}

module "ascs" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks
  instance_name           = var.instance_name_ascs
  instance_type           = var.instance_type_ascs
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = local.subnetwork_project_id
  zone                    = var.zone_primary
}

module "ers" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks
  instance_name           = var.instance_name_ers
  instance_type           = var.instance_type_ers
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = local.subnetwork_project_id
  zone                    = var.zone_secondary
}

module "db2_primary" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks_db2
  instance_name           = var.instance_name_db2_primary
  instance_type           = var.instance_type_db2
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = local.subnetwork_project_id
  zone                    = var.zone_primary
}

module "db2_secondary" {
  source                  = "../vm"

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks_db2
  instance_name           = var.instance_name_db2_secondary
  instance_type           = var.instance_type_db2
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = local.subnetwork_project_id
  zone                    = var.zone_secondary
}

module "as" {
  source                  = "../vm"
  for_each                = toset(local.instance_names_as)

  boot_disk_auto_delete   = var.auto_delete_disk_boot
  boot_disk_size          = var.disk_size_boot
  boot_disk_type          = var.disk_type_boot
  additional_disks        = local.additional_disks
  instance_name           = each.key
  instance_type           = var.instance_type_as
  metadata                = local.metadata
  network_tags            = var.network_tags
  project_id              = var.project_id
  service_account_email   = var.service_account_email
  service_account_scopes  = var.service_account_scopes
  source_image            = var.source_image
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  subnetwork              = var.subnetwork
  subnetwork_project_id   = local.subnetwork_project_id
  # Alternate zones between primary and secondary.
  zone                    = local.zones[index(local.instance_names_as, each.value) % 2]
}

module "umig_ascs" {
  source                  = "../umig"

  instances_self_links    = [module.ascs.instance_self_link]
  name                    = var.instance_name_ascs
  project_id              = var.project_id
  zones                   = [var.zone_primary]
}

module "umig_ers" {
  source                  = "../umig"

  instances_self_links    = [module.ers.instance_self_link]
  name                    = var.instance_name_ers
  project_id              = var.project_id
  zones                   = [var.zone_secondary]
}

module "umig_db2" {
  source                  = "../umig"

  instances_self_links    = [module.db2_primary.instance_self_link, module.db2_secondary.instance_self_link]
  name                    = "${var.instance_name_db2_primary}-${var.instance_name_db2_secondary}"
  project_id              = var.project_id
  zones                   = [var.zone_primary, var.zone_secondary]
}

module "ilb_ascs" {
  source                = "../terraform-google-lb-internal"

  all_ports             = true
  backends              = [
    {
      group             = module.umig_ascs.instance_groups[var.zone_primary].self_link
      description       = ""
      failover          = false
    },
    {
      group             = module.umig_ers.instance_groups[var.zone_secondary].self_link
      description       = ""
      failover          = true
    },
  ]
  failover_policy       = {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_check          = {
    check_interval_sec  = null
    healthy_threshold   = 1
    host                = null
    port                = var.health_check_port_ascs
    port_name           = "ascs"
    proxy_header        = null
    request             = null
    request_path        = null
    response            = null
    timeout_sec         = null
    type                = "tcp"
    unhealthy_threshold = 3
  }
  name                  = var.instance_name_ascs
  network               = local.network
  network_project       = var.subnetwork_project_id
  ports                 = []
  project               = var.project_id
  region                = local.region
  source_tags           = []
  subnetwork            = var.subnetwork
  target_tags           = var.network_tags
}

module "ilb_db2" {
  source                = "../terraform-google-lb-internal"

  all_ports             = true
  backends              = [
    {
      group             = module.umig_db2.instance_groups[var.zone_primary].self_link
      description       = ""
      failover          = false
    },
    {
      group             = module.umig_db2.instance_groups[var.zone_secondary].self_link
      description       = ""
      failover          = true
    },
  ]
  failover_policy       = {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_check          = {
    check_interval_sec  = null
    healthy_threshold   = 1
    host                = null
    port                = var.health_check_port_db2
    port_name           = "db2"
    proxy_header        = null
    request             = null
    request_path        = null
    response            = null
    timeout_sec         = null
    type                = "tcp"
    unhealthy_threshold = 3
  }
  name                  = "${var.instance_name_db2_primary}-${var.instance_name_db2_secondary}"
  network               = local.network
  network_project       = var.subnetwork_project_id
  ports                 = []
  project               = var.project_id
  region                = local.region
  source_tags           = []
  subnetwork            = var.subnetwork
  target_tags           = var.network_tags
}

module "ilb_ers" {
  source                = "../terraform-google-lb-internal"
  count                 = var.ers_ilb_required ? 1 : 0

  all_ports             = true
  backends              = [
    {
      group             = module.umig_ers.instance_groups[var.zone_secondary].self_link
      description       = ""
      failover          = false
    },
    {
      group             = module.umig_ascs.instance_groups[var.zone_primary].self_link
      description       = ""
      failover          = true
    },
  ]
  failover_policy       = {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_check          = {
    check_interval_sec  = null
    healthy_threshold   = 1
    host                = null
    port                = var.health_check_port_ers
    port_name           = "ers"
    proxy_header        = null
    request             = null
    request_path        = null
    response            = null
    timeout_sec         = null
    type                = "tcp"
    unhealthy_threshold = 3
  }
  name                  = var.instance_name_ers
  network               = local.network
  network_project       = var.subnetwork_project_id
  ports                 = []
  project               = var.project_id
  region                = local.region
  source_tags           = []
  subnetwork            = var.subnetwork
  target_tags           = var.network_tags
}

module "filestore" {
  source     = "../filestore"
  count      = var.filestore_name == "" ? 0 : 1

  clients    = concat(
        [
          module.ascs.internal_ip,
          module.ers.internal_ip,
          module.db2_primary.internal_ip,
          module.db2_secondary.internal_ip,
        ],
        [for as in module.as : as.internal_ip])
  name       = var.filestore_name
  network    = local.network
  project_id = local.subnetwork_project_id
  share      = "sap"
  size       = var.filestore_size
  tier       = var.filestore_tier
  zone       = var.zone_primary
}

resource "google_compute_address" "ers_vip" {
  count        = var.ers_ilb_required ? 0 : 1

  name         = "${var.instance_name_ers}-vip"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = local.region
  project      = var.project_id
  purpose      = "GCE_ENDPOINT"
}
