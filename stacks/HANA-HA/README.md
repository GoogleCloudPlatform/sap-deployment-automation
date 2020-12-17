# SAP HANA installation and configuration using Terraform and Ansible

Terraform module and ansible roles to deploy the SAP HANA HA stack. This stack deploys a primary HANA node along with the seconddary HA node to form a cluster. Primary and secondary instancesa are deployed in seperate zones. HANA HA config is performed by a higher ansible role `ansible/roles/sap-hana-ha` that in turn calls lower ansible roles to do a specific task as part of the ha config.

# Deployment Architecture

### <img src="images/ha.png" width="500px">

# Requirements

* Terraform version `>=0.12`
* Ansible version `>= 2.9.2`

# Usage

1. Terraform code for deploying the infrastructure required for installing and configuring SAP HANA HA nodes is stored under `tf/`.

2. Ansible roles for configuring HANA HA on the GCE instances is stored under `sap-iac/ansible/roles`.

3. Ansible playbook to deploy the HANA HA stack is `playbook.yml`.

# Variables

* All the ansible SAP HANA HA configuration default values are defined in the higher level ansible role under `sap-iac/ansible/roles/sap-hana-ha/defaults/main.yml`.

* All the variables required for deploying stack are defined in the `vars/deploy-vars.yml` file.

`sap_primary_zone` (required): GCP zone to deploy the primary sap instance 

`sap_secondary_zone` (required): GCP zone to deploy the secondary sap instance 

`sap_project_id` (required): GCP project-id to deploy the resources

`sap_source_image_family` (required): GCE instances image family

`sap_source_image_project` (required): GCE instances image family project

`sap_subnetwork_project_id` (required): GCP project-id hosting the subnetwork. When using `shared_vpc` provide the host project-id of the subnetwork.

`sap_hana_subnetwork` (required): GCP subnetwork name

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

`sap_hana_target_instance_size`: Target instances number in the HA cluster

`sap_hana_pd_kms_key`: Customer managed encryption key to use in persistent disks 

`sap_hana_create_backup_volume`: Provision HANA DB backup disk and attach to instance

`sap_hana_backint_install`: Install SAP HANA backint on the HANA nodes

`sap_hana_password`: Common password to use for all HANA user and system authentication

# Example playbook to deploy SAP HANA HA stack

Below is the example playbook to deploy the HANA HA stack. Replace the variable values to fit your need

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
        primary_zone: "us-central1-a"
        secondary_zone: "us-central1-b"
        instance_type: "n1-highmem-32"
        autodelete_disk: true
        boot_disk_size: 30
        boot_disk_type: "pd-ssd"
        network_tags: ["sap-allow-all"]
        target_size: 1
        pd_kms_key: None
        create_backup_volume: true

- name: SAP HANA configure on both primay and secondary
  hosts: hana
  become: yes
  vars:
    sap_hana_backint_install: true
    sap_hana_backint_bucket_name: "sap-hana-backint-backup"
    sap_hana_primary_instance_name: '{{ terraform.outputs.primary_instance_name.value }}'
    sap_hana_secondary_instance_name: '{{ terraform.outputs.secondary_instance_name.value }}'
    sap_hana_primary_instance_ip: '{{ terraform.outputs.primary_instance_ip.value }}'
    sap_hana_secondary_instance_ip: '{{ terraform.outputs.secondary_instance_ip.value }}'
    sap_hana_vip: '{{ terraform.outputs.hana_ilb_ip.value }}'
    sap_hana_health_check_port: '{{ terraform.outputs.health_check_port.value }}'
    sap_hana_shared_size: '{{ terraform.outputs.hana_shared_size.value }}G'
    sap_hana_data_size: '{{ terraform.outputs.hana_data_size.value }}G'
    sap_hana_log_size: '{{ terraform.outputs.hana_log_size.value }}G'
    sap_hana_usr_size: '{{ terraform.outputs.hana_usr_size.value }}G'
    sap_hana_backup_size: '{{ terraform.outputs.hana_backup_size.value - 1 }}G'
  roles:
  - role: sap-hana-ha
```

# Deploy HANA HA stack

* Use the ansible wrapper script under `sap-iac/ansible-wrapper` to deploy the stack. 

* The ansible wrapper script will setup the environment along with installing the correct terraform and ansible version required for running the code

* Run the below command by changing into the root folder `sap-iac/` for deploying the SAP HANA HA stack

`./ansible-wrapper ./stacks/HANA-HA/playbook.yml --extra-vars '@./stacks/HANA-HA/vars/deploy-vars.yml'`

# Destroy HANA HA stack

* Run the below command by changing into the root folder `sap-iac/` for destroying the SAP HANA HA stack

`./ansible-wrapper ./stacks/HANA-HA/playbook.yml -e state=absent --extra-vars '@./stacks/HANA-HA/vars/deploy-vars.yml'`

# Author Information

Bala Guduru <balabharat.guduru@googlecloud.corp-partner.google.com>