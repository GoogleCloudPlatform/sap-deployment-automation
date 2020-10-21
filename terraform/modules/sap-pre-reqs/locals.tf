locals {
  region             = join("-", slice(split("-", var.zone), 0, 2))
  subnetwork_project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
  network_parts      = split("/", data.google_compute_subnetwork.subnetwork.network)
  network            = element(local.network_parts, length(local.network_parts) - 1)
}