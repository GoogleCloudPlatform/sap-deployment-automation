terraform {
  required_version = "~> 0.12.26"
  required_providers {
    google = ">= 2.7, <4.0"
  }

  backend "gcs" {
    bucket = "sap-terraform-state-bg"
    prefix = "hana"
  }
}