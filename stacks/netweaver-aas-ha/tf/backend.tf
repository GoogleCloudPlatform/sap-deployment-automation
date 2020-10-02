terraform {
  backend "gcs" {
  bucket = "mercadona-sap-terraform-state"
  prefix = "sapaasha"
}
}
