# SAP HANA installation and configuration using Terraform and Ansible

Terraform module and ansible roles to deploy the SAP HANA Scaleup stack. This stack deploys a single node HANA instance with an option to create multiple nodes at the same time. HANA Scaleup config is performed by a higher ansible role `ansible/roles/sap-hana-scaleup` that in turn calls lower ansible roles to do a specific task as part of the scaleup config.

# Deployment Architecture

### <img src="images/scaleup.png" width="100px">

# Requirements

* Ansible version `>= 2.9.2`

# Usage

1. Terraform code for deploying the infrastructure required for installing and configuring SAP HANA scaleup nodes is stored under `tf/`.

2. Ansible roles for configuring HANA scaleup on the GCE instances is stored under `sap-iac/ansible/roles`.

3. Ansible playbook to deploy the HANA scale-up stack is `playbook.yml`.

# Variables

* All the ansible SAP HANA scaleup configuration default values are defined in the higher level ansible role under `sap-iac/ansible/roles/sap-hana-scaleup/defaults/main.yml`.

* All the variables required for deploying stack are defined in the `vars/deploy-vars.yml` file.

`sap_zone` (required): GCP zone to deploy the sap instances 

`sap_project_id` (required): GCP project-id to deploy the resources

`sap_source_image_family` (required): GCE instances image family

`sap_source_image_project` (required): GCE instances image family project

`sap_subnetwork_project_id` (required): GCP project-id hosting the subnetwork. When using `shared_vpc` provide the host project-id of the subnetwork.

`sap_subnetwork` (required): GCP subnetwork name

`sap_tf_state_bucket` (required): Terraform state bucket name storing the tf state file

`sap_tf_state_bucket_prefix` (required): Terraform state bucket prefix for storing tf state file

`sap_hana_instance_name` (required): GCE instance name

`sap_hana_service_account_name` (required): GCP service account name

`sap_hana_instance_type`: GCE instance type (choose from the below)
```hcl
n1-highmem-32
n1-highmem-64
n1-highmem-96
n2-highmem-32
n2-highmem-48
n2-highmem-64
n2-highmem-80
m1-megamem-96
m1-ultramem-40
m1-ultramem-80
m1-ultramem-160
m2-ultramem-208
m2-ultramem-416
```
`sap_hana_autodelete_boot_disk`: Delete boot disk along with the instance

`sap_hana_boot_disk_size`: GCE instance boto disk size

`sap_hana_boot_disk_type`: pd-ssd

`sap_hana_network_tags`: List of network tags to add to the instances

`sap_hana_pd_kms_key`: Customer managed encryption key to use in persistent disks 

`sap_hana_create_backup_volume`: Provision HANA DB backup disk and attach to instance

`sap_hana_backint_install`: Install SAP HANA backint on the HANA nodes

`sap_hana_password`: Common password to use for all HANA user and system authentication

# Example playbook to deploy SAP HANA Scaleup stack

Below is the example playbook to deploy the HANA scaleup stack. Replace the variable values to fit your need

```yaml
- name: SAP HANA deploy
  hosts: 127.0.0.1
  connection: local
  roles:
  - role: forminator
    vars:
      sap_tf_project_path: ./tf
      sap_state: "present"
      sap_hana_backint_install: true
      sap_hana_backint_bucket_name: "sap-hana-backint-backup"
      sap_tf_variables:
        instance_name: hanaslbg
        project_id: gcp-project-id
        source_image_family: source-image-family
        source_image_project: source-image-project
        subnetwork: subnetwork-name
        service_account_email: "sap-common-sa"
        subnetwork_project: '{{ sap_project_id }}'
        zone: "us-central1-a"
        instance_type: "n1-highmem-32"
        autodelete_disk: true
        boot_disk_size: 30
        boot_disk_type: "pd-ssd"
        network_tags: ["sap-allow-all"]
        pd_kms_key: None
        create_backup_volume: true

- name: SAP HANA configure on both primay and secondary
  hosts: hana
  become: yes
  vars:
    sap_hana_backint_install: true
    sap_hana_backint_bucket_name: "sap-hana-backint-backup"
    sap_hana_shared_size: '{{ terraform.outputs.hana_shared_size.value }}G'
    sap_hana_data_size: '{{ terraform.outputs.hana_data_size.value }}G'
    sap_hana_log_size: '{{ terraform.outputs.hana_log_size.value }}G'
    sap_hana_usr_size: '{{ terraform.outputs.hana_usr_size.value }}G'
    sap_hana_backup_size: '{{ terraform.outputs.hana_backup_size.value - 1 }}G'
  roles:
  - role: sap-hana-scaleup
```

# Deploy HANA scaleup stack

* Use the ansible wrapper script under `sap-iac/ansible-wrapper` to deploy the stack. 

* The ansible wrapper script will setup the environment along with installing the correct terraform and ansible version required for running the code

* Run the below command by changing into the root folder `sap-iac/` for deploying the SAP HANA scaleup stack

`./ansible-wrapper ./stacks/HANA-Scaleup/playbook.yml --extra-vars '@./stacks/HANA-Scaleup/vars/deploy-vars.yml'`

# Destroy HANA scaleup stack

* Run the below command by changing into the root folder `sap-iac/` for destroying the SAP HANA scaleup stack

`./ansible-wrapper ./stacks/HANA-Scaleup/playbook.yml -e state=absent --extra-vars '@./stacks/HANA-Scaleup/vars/deploy-vars.yml'`

# Author Information

Bala Guduru <balabharat.guduru@googlecloud.corp-partner.google.com>