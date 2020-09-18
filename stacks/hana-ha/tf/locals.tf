locals {
  subnetwork_project = var.subnetwork_project == "" ? var.project_id : var.subnetwork_project
}