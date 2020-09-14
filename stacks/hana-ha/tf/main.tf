provider "google" {}

module "sap_hana_template" {
  source       = "../../../terraform/modules/terraform-google-vm//modules/instance_template"
  name_prefix  = "${var.instance_name}-instance-template"
  machine_type = var.instance_type
  project_id   = var.project_id
  region       = local.region

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"
  }

  service_account = {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "hana"
  }

  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  tags               = var.network_tags
  can_ip_forward     = true

  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project

  disk_size_gb = var.boot_disk_size
  disk_type    = var.boot_disk_type
  auto_delete  = var.autodelete_disk
}

resource "google_compute_address" "gcp_sap_hana_intip_primary" {
  name         = "${var.instance_name}-int-primary"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = local.region
  project      = local.subnetwork_project
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "gcp_sap_hana_intip_secondary" {
  name         = "${var.instance_name}-int-secondary"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = local.region
  project      = local.subnetwork_project
  purpose      = "GCE_ENDPOINT"
}

module "sap_hana_umig_primary" {
  source             = "../../../terraform/modules/terraform-google-vm//modules/umig"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone_a
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = [google_compute_address.gcp_sap_hana_intip_primary.address]
  hostname           = substr("${var.instance_name}-pri", 0, 11) # Limit length to 12 charecters
  num_instances      = var.target_size
  instance_template  = module.sap_hana_template.self_link
}

module "sap_hana_umig_secondary" {
  source             = "../../../terraform/modules/terraform-google-vm//modules/umig"
  project_id         = var.project_id
  region             = local.region
  zone               = var.zone_b
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project
  static_ips         = [google_compute_address.gcp_sap_hana_intip_secondary.address]
  hostname           = substr("${var.instance_name}-sec", 0, 11) # Limit length to 12 charecters
  num_instances      = var.target_size
  instance_template  = module.sap_hana_template.self_link
}

resource "google_compute_disk" "gcp_sap_hana_data_primary" {
  project = var.project_id
  name    = "${var.instance_name}-primary-data"
  type    = "pd-ssd"
  zone    = var.zone_a
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup_primary" {
  project = var.project_id
  name    = "${var.instance_name}-primary-backup"
  type    = "pd-standard"
  zone    = var.zone_a
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_data_secondary" {
  project = var.project_id
  name    = "${var.instance_name}-secondary-data"
  type    = "pd-ssd"
  zone    = var.zone_b
  size    = local.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_backup_secondary" {
  project = var.project_id
  name    = "${var.instance_name}-secondary-backup"
  type    = "pd-standard"
  zone    = var.zone_b
  size    = local.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "primary_data" {
  disk        = google_compute_disk.gcp_sap_hana_data_primary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)}-data"
  project     = var.project_id
  zone        = var.zone_a
}

resource "google_compute_attached_disk" "primary_backup" {
  disk        = google_compute_disk.gcp_sap_hana_backup_primary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_primary.instances_self_links), 0)), 10)}-backup"
  project     = var.project_id
  zone        = var.zone_a
}

resource "google_compute_attached_disk" "secondary_data" {
  disk        = google_compute_disk.gcp_sap_hana_data_secondary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)}-data"
  project     = var.project_id
  zone        = var.zone_b
}

resource "google_compute_attached_disk" "secondary_backup" {
  disk        = google_compute_disk.gcp_sap_hana_backup_secondary.id
  instance    = element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)
  device_name = "${element(split("/", element(tolist(module.sap_hana_umig_secondary.instances_self_links), 0)), 10)}-backup"
  project     = var.project_id
  zone        = var.zone_b
}

resource "google_compute_firewall" "hana_healthcheck_firewall_rule" {
  name          = "hana-healthcheck-firewall-rule"
  project       = var.project_id
  network       = var.network
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
  }
}

module "sap_hana_ilb" {
  source       = "../../../terraform/modules/terraform-google-lb-internal"
  project      = var.project_id
  region       = local.region
  network      = var.network
  subnetwork   = var.subnetwork
  name         = "${var.instance_name}-ilb"
  source_tags  = ["soure-tag"]
  target_tags  = ["target-tag"]
  ports        = [local.named_ports[0].port]
  health_check = local.health_check

  backends = [
    {
      group       = module.sap_hana_umig_primary.self_links[0]
      description = "Primary instance backend group"
      failover    = false
    },
    {
      group       = module.sap_hana_umig_secondary.self_links[0]
      description = "Secondary instance backend group"
      failover    = true
    },
  ]
}
