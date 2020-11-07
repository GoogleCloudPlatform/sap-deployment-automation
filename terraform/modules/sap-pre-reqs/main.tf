provider "google" {}

# Get subnetwork details
data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = local.subnetwork_project
}

# IAM policy for host project in shared VPC

resource "google_project_iam_member" "project_net_user" {
  count   = local.subnetwork_project != var.project_id ? 1 : 0
  project = local.subnetwork_project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.sap_service_account.email}"
}

resource "google_project_iam_member" "project_net_admin" {
  count   = local.subnetwork_project != var.project_id ? 1 : 0
  project = local.subnetwork_project
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.sap_service_account.email}"
}

resource "google_project_iam_member" "project_sec_admin" {
  count   = local.subnetwork_project != var.project_id ? 1 : 0
  project = local.subnetwork_project
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${google_service_account.sap_service_account.email}"
}

resource "random_id" "server" {
  byte_length = 2
}

resource "google_project_service" "enable_iam" {
  project                    = var.project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_service_account" "sap_service_account" {
  project      = var.project_id
  account_id   = var.sap_service_account_name == "" ? "sap-common-sa-${random_id.server.hex}" : var.sap_service_account_name
  display_name = "SAP Common Service Account for Hana and Netweaver"
}

resource "google_project_iam_member" "sap_sa_iam_mem_service" {
  for_each = toset([
    "roles/compute.admin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkUser",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/iam.serviceAccountUser",
    "roles/compute.networkAdmin",
    "roles/source.reader",
    "roles/storage.objectAdmin",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sap_service_account.email}"
}

resource "google_compute_project_metadata" "vm_dns_setting" {
  project = var.project_id
  metadata = {
    VmDnsSetting = "ZonalPreferred"
  }
}

# Create firewall rule to allow communication b/w instances in subnet
resource "google_compute_firewall" "sap_firewall_all" {
  project       = local.subnetwork_project
  name          = "sap-allow-all-${random_id.server.hex}"
  network       = local.network
  source_ranges = [data.google_compute_subnetwork.subnetwork.ip_cidr_range]
  target_tags   = var.network_tags

  allow {
    protocol = "all"
  }
}

# Create firewall rule to allow AWX to connect to instances
resource "google_compute_firewall" "sap_firewall_awx" {
  project       = local.subnetwork_project
  name          = "sap-allow-awx-ssh-${random_id.server.hex}"
  network       = local.network
  source_tags   = ["awx"]
  target_tags   = var.network_tags

  allow {
    protocol = "tcp"
    ports    = [22]
  }
}

# Create NAT for outside connectivity
resource "google_compute_router" "router" {
  count   = var.nat_create == true ? 1 : 0
  project = local.subnetwork_project
  name    = "router-${random_id.server.hex}"
  region  = local.region
  network = local.network
}

resource "google_compute_router_nat" "nat" {
  count                              = var.nat_create == true ? 1 : 0
  project                            = local.subnetwork_project
  name                               = "router-nat-${random_id.server.hex}"
  router                             = google_compute_router.router[count.index].name
  region                             = local.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = "projects/${local.subnetwork_project}/regions/${local.region}/subnetworks/${var.subnetwork}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
