provider "google" {}

module "sap_sa" {
  source                   = "../../../terraform/modules/sap-pre-reqs"
  project_id               = var.project_id
  zone                     = var.zone
  subnetwork               = var.subnetwork
  subnetwork_project       = var.subnetwork_project
  network_tags             = var.network_tags
  nat_create               = var.nat_create
  sap_service_account_name = var.sap_service_account_name
}