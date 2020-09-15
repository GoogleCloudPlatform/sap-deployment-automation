resource "google_compute_disk" "gcp_sap_hana_sd_data" {
  project = var.project_id
  name    = "${var.instance_name}-${var.disk_name_0}-${var.device_name_pd_ssd}"
  type    = var.disk_type_0
  zone    = var.zone
  size    = var.pd_ssd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_sd_backup" {
  project = var.project_id
  name    = "${var.instance_name}-${var.disk_name_1}-${var.device_name_pd_hdd}"
  type    = var.disk_type_1
  zone    = var.zone
  size    = var.pd_hdd_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_address" "gcp_sap_hana_ip" {
  count = var.public_ip ? 1 : 0

  project = var.project_id
  name    = var.address_name
  region  = local.region
}

data "google_compute_image" "image" {
  family  = var.linux_image_family
  project = var.linux_image_project
}

resource "google_compute_instance" "gcp_sap_hana" {
  project        = var.project_id
  name           = var.instance_name
  machine_type   = var.instance_type
  zone           = var.zone
  tags           = var.network_tags
  can_ip_forward = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    auto_delete       = var.autodelete_disk
    kms_key_self_link = var.pd_kms_key

    initialize_params {
      image = data.google_compute_image.image.self_link
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  attached_disk {
    source      = google_compute_disk.gcp_sap_hana_sd_data.self_link
    device_name = google_compute_disk.gcp_sap_hana_sd_data.name
  }

  attached_disk {
    source      = google_compute_disk.gcp_sap_hana_sd_backup.self_link
    device_name = google_compute_disk.gcp_sap_hana_sd_backup.name
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = local.subnetwork_project

    dynamic "access_config" {
      for_each = var.public_ip ? google_compute_address.gcp_sap_hana_ip : []
      content {
        nat_ip = access_config.value.address
      }
    }

  }

  metadata = {
    sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
    sap_deployment_debug       = var.sap_deployment_debug
    post_deployment_script     = var.post_deployment_script
    sap_hana_sid               = var.sap_hana_sid
    sap_hana_instance_number   = var.sap_hana_instance_number
    sap_hana_sidadm_password   = var.sap_hana_sidadm_password
    sap_hana_system_password   = var.sap_hana_system_password
    sap_hana_sidadm_uid        = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid        = var.sap_hana_sapsys_gid
    ssh-keys                   = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"
  }

  metadata_startup_script = contains([element(split("-", var.linux_image_family), 0)], "rhel") ? templatefile("${path.module}/files/redhat.sh",
    {
      sap_install_files_bucket  = var.sap_install_files_bucket
      sap_hostagent_file_name   = var.sap_hostagent_file_name
      sap_hana_bundle_file_name = var.sap_hana_bundle_file_name
      sap_hana_sapcar_file_name = var.sap_hana_sapcar_file_name
    }
    ) : templatefile("${path.module}/files/sles.sh",
    {
      sap_install_files_bucket  = var.sap_install_files_bucket
      sap_hostagent_file_name   = var.sap_hostagent_file_name
      sap_hana_bundle_file_name = var.sap_hana_bundle_file_name
      sap_hana_sapcar_file_name = var.sap_hana_sapcar_file_name
    }
  )

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata, attached_disk]
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}

data "google_compute_instance" "sap_instance" {
  name    = google_compute_instance.gcp_sap_hana.name
  project = var.project_id
  zone    = var.zone
}
