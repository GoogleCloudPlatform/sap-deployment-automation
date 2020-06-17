output "sap_hana_sid" {
  description = "SAP Hana SID user"
  value       = var.sap_hana_sid
}

output "instance_name" {
  description = "Name of instance"
  value       = var.instance_name
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = var.zone
}

output "self_link" {
  value = module.gcp_sap_hana.self_link
}

output "address" {
  value = module.gcp_sap_hana.address
}

output "public_ip" {
  value = module.gcp_sap_hana.public_ip
}

resource "local_file" "ansible_inventory" {
  content = templatefile("modules/ansible/templates/inventory.tmpl",
    {
      private-dns = module.gcp_sap_hana.instance_name,
      private-ip  = module.gcp_sap_hana.address,
      private-id  = module.gcp_sap_hana.instance_id
    }
  )
  filename = "modules/ansible/plays/inventory"
}


resource "local_file" "ansible_variables" {
  content = templatefile("modules/ansible/templates/sap_hosts.tmpl",
    {
      hana_log_size    = local.hana_log_size,
      hana_data_size   = local.hana_data_size,
      hana_shared_size = local.hana_shared_size,
      hana_usr_size    = local.hana_usr_size,
      hana_backup_size = local.hana_backup_size
    }
  )
  filename = "modules/ansible/vars/sap_hosts.yml"
}
