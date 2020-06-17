provider "google" {}

locals {
  pd_ssd_size = lookup(local.pd_ssd_map, var.instance_type)
  pd_hdd_size = lookup(local.pd_hdd_map, var.instance_type)

  pd_ssd_map = {
    "n1-highmem-32"   = 834
    "n1-highmem-64"   = 1280
    "n1-highmem-96"   = 1904
    "n2-highmem-32"   = 834
    "n2-highmem-48"   = 1184
    "n2-highmem-64"   = 1568
    "n2-highmem-80"   = 1952
    "m1-megamem-96"   = 3717
    "m1-ultramem-40"  = 2914
    "m1-ultramem-80"  = 4451
    "m1-ultramem-160" = 7334
    "m2-ultramem-208" = 10400
    "m2-ultramem-416" = 19217
  }

  pd_hdd_map = {
    "n1-highmem-32"   = 448
    "n1-highmem-64"   = 864
    "n1-highmem-96"   = 1280
    "n2-highmem-32"   = 544
    "n2-highmem-48"   = 800
    "n2-highmem-64"   = 1056
    "n2-highmem-80"   = 1312
    "m1-megamem-96"   = 2898
    "m1-ultramem-40"  = 1954
    "m1-ultramem-80"  = 3876
    "m1-ultramem-160" = 7720
    "m2-ultramem-208" = 11808
    "m2-ultramem-416" = 23564
  }

  instance_mem_map = {
    "n1-highmem-32"   = 208
    "n1-highmem-64"   = 416
    "n1-highmem-96"   = 624
    "n2-highmem-32"   = 256
    "n2-highmem-48"   = 384
    "n2-highmem-64"   = 512
    "n2-highmem-80"   = 640
    "m1-megamem-96"   = 1433
    "m1-ultramem-40"  = 961
    "m1-ultramem-80"  = 1922
    "m1-ultramem-160" = 3844
    "m2-ultramem-208" = 5888
    "m2-ultramem-416" = 11766
  }

  hana_log_size    = min(512, max(64, lookup(local.instance_mem_map, var.instance_type) / 2))
  hana_data_size   = lookup(local.instance_mem_map, var.instance_type) * 15 / 10
  hana_shared_size = min(1024, lookup(local.instance_mem_map, var.instance_type))
  hana_usr_size    = 32
  hana_backup_size = lookup(local.instance_mem_map, var.instance_type) * 2
}

module "gcp_sap_hana" {
  source                     = "./modules/sap_hana"
  subnetwork                 = var.subnetwork
  linux_image_family         = var.linux_image_family
  linux_image_project        = var.linux_image_project
  instance_name              = var.instance_name
  instance_type              = var.instance_type
  subnetwork_project         = var.subnetwork_project
  project_id                 = var.project_id
  region                     = var.region
  zone                       = var.zone
  service_account_email      = var.service_account_email
  boot_disk_type             = var.boot_disk_type
  boot_disk_size             = var.boot_disk_size
  autodelete_disk            = "true"
  pd_ssd_size                = max(834, (local.hana_log_size + local.hana_data_size + local.hana_shared_size + local.hana_usr_size))
  pd_hdd_size                = local.hana_backup_size
  sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
  sap_deployment_debug       = "false"
  post_deployment_script     = var.post_deployment_script
  startup_script             = file(var.startup_script)
  sap_hana_sid               = var.sap_hana_sid
  sap_hana_instance_number   = var.sap_hana_instance_number
  sap_hana_sidadm_password   = var.sap_hana_sidadm_password
  sap_hana_system_password   = var.sap_hana_system_password
  network_tags               = var.network_tags
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  public_ip                  = var.public_ip
  address_name               = "${var.instance_name}-reservedip"
}
