locals {
  access_config      = var.assign_public_ip ? [{
    nat_ip           = null
    network_tier     = "PREMIUM"
  }] : null

  default_tag = local.uses_ssl ? "https-server" : "http-server"

  metadata = local.uses_ssl ? {
    startup-script = local.startup_script
    ssl-certificate = file(var.ssl_certificate_file)
    ssl-key = file(var.ssl_key_file)
  } : {
    startup-script = local.startup_script
  }

  python_requirements = {
    ansible = "2.9.10"
    cffi = "1.14.0"
    cryptography = "2.9.2"
    Jinja2 = "2.11.2"
    MarkupSafe = "1.1.1"
    pycparser = "2.20"
    PyYAML = "5.3.1"
    six = "1.15.0"
  }

  startup_script = templatefile("${path.module}/startup_script.sh.tmpl", {
    awx_repository = var.awx_repository
    awx_version = var.awx_version
    python_requirements = join("\n", [for k, v in local.python_requirements : "${k}==${v}"])
    uses_ssl = local.uses_ssl
  })

  subnetwork_project_id = var.subnetwork_project_id != "" ? var.subnetwork_project_id : var.project_id

  tags = length(var.tags) != 0 ? toset(concat(var.tags, [local.default_tag])) : [local.default_tag]

  uses_ssl = var.ssl_certificate_file != "" && var.ssl_key_file != ""
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "3.0.0"

  access_config        = local.access_config
  machine_type         = var.machine_type
  metadata             = local.metadata
  name_prefix          = "${var.instance_name}-instance-template"
  project_id           = var.project_id
  region               = var.region
  service_account      = var.service_account
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  subnetwork           = var.subnetwork
  subnetwork_project   = local.subnetwork_project_id
  tags                 = local.tags
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "3.0.0"

  access_config      = local.access_config
  instance_template  = module.instance_template.self_link
  hostname           = var.instance_name
  num_instances      = 1
  region             = var.region
  subnetwork         = var.subnetwork
  subnetwork_project = local.subnetwork_project_id
}
