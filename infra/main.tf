provider "google" {}

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
  pd_ssd_size                = local.pd_ssd_size
  pd_hdd_size                = local.pd_hdd_size
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

resource "local_file" "ansible_inventory" {
  content = templatefile("modules/ansible/templates/inventory.tmpl",
    {
      private-dns = module.gcp_sap_hana.instance_name,
      private-ip  = module.gcp_sap_hana.address,
      private-id  = module.gcp_sap_hana.instance_id
    }
  )
  filename = "modules/ansible/inventory"
}


resource "local_file" "ansible_variables" {
  content = templatefile("modules/ansible/templates/sap_hosts.tmpl",
    {
      hana_log_size    = local.hana_log_size,
      hana_data_size   = local.hana_data_size,
      hana_shared_size = local.hana_shared_size,
      hana_usr_size    = local.hana_usr_size,
      hana_backup_size = local.hana_backup_size - 1
    }
  )
  filename = "modules/ansible/vars/sap_hosts.yml"
}

resource "null_resource" "sap_config" {
  triggers = {
    build_number = timestamp()
  }

  # Add wait period before the hana node becomes available
  #TODO: Replace this with instance healthcheck
  provisioner "local-exec" {
    command = "sleep 2m"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ./modules/ansible/inventory ./modules/ansible/sap-hana-deploy.yml --extra-vars '@./modules/ansible/vars/sap_hosts.yml'"
  }

  depends_on = [local_file.ansible_inventory, local_file.ansible_variables, module.gcp_sap_hana]
}
 