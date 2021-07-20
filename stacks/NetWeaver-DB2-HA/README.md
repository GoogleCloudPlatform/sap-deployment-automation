# NetWeaver-DB2-HA

This stack defines an Ansible playbook and a Terraform root module to deploy the NetWeaver-DB2-HA stack.

The stack creates:

* One ASCS instance
* One ERS instance
* One primary DB2 instance
* One secondary DB2 instance
* One or more application server instances (PAS and AAS)

# Deployment Architecture

![NetWeaver-DB2-HA](./images/ha.png)

# Requirements

Python 3.5 or greater is required.

Ansible and its dependencies, defined in `requirements.txt` at the root of the repository, will be installed to a local cache directory automatically when using [`ansible-wrapper`](#usage). The correct version of Terraform will be installed by Ansible.

# Variables

Create a variables file using the example at `stacks/NetWeaver-DB2-HA/vars/deploy-vars.yml`, or see `ansible/roles/nw-db2-ha/defaults/main.yml` for more options.

# Usage

After having created a variables file, use it to either create or delete a stack as shown below. Instructions assume the file is called `vars.yml`.

## Deploy NetWeaver-DB2-HA stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-HA/playbook.yml -e @vars.yml
```

## Destroy NetWeaver-DB2-HA stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-HA/playbook.yml -e @vars.yml -e state=absent
```

# Example playbook

```yaml
- hosts: 127.0.0.1
  connection: local
  roles:
  - role: forminator
    vars:
      sap_state: '{{ state | default("present") }}'
      sap_tf_version: 0.14.11
      sap_tf_project_path: './tf'
      sap_tf_variables:
        disk_size_boot: '{{ sap_nw_disk_size_boot | default(30) }}'
        disk_size_db2: '{{ sap_nw_disk_size_db2 | default(50) }}'
        disk_size_swap: '{{ sap_nw_disk_size_swap | default(25) }}'
        disk_size_usrsap: '{{ sap_nw_disk_size_usrsap | default(25) }}'
        disk_type_boot: '{{ sap_nw_disk_type_boot | default("pd-ssd") }}'
        disk_type_db2: '{{ sap_nw_disk_type_db2 | default("pd-ssd") }}'
        disk_type_swap: '{{ sap_nw_disk_type_swap | default("pd-ssd") }}'
        disk_type_usrsap: '{{ sap_nw_disk_type_usrsap | default("pd-ssd") }}'
        ers_ilb_required: '{{ sap_nw_ers_ilb_required | default(sap_source_image_project == "suse-sap-cloud") }}'
        filestore_name: '{{ sap_filestore_name | default("") }}'
        filestore_size: '{{ sap_filestore_size | default(1024) }}'
        filestore_tier: '{{ sap_filestore_tier | default("STANDARD") }}'
        health_check_port_ascs: '{{ sap_nw_ascs_health_check_port | default(6666) }}'
        health_check_port_db2: '{{ sap_db2_health_check_port | default(6666) }}'
        health_check_port_ers: '{{ sap_nw_ers_health_check_port | default(6667) }}'
        instance_basename_as: '{{ sap_nw_as_instance_basename }}'
        instance_name_ascs: '{{ sap_nw_ascs_instance_name }}'
        instance_name_db2_primary: '{{ sap_db2_instance_name_primary }}'
        instance_name_db2_secondary: '{{ sap_db2_instance_name_secondary }}'
        instance_name_ers: '{{ sap_nw_ers_instance_name }}'
        instance_type_as: '{{ sap_nw_instance_type | default("e2-standard-8") }}'
        instance_type_ascs: '{{ sap_nw_instance_type | default("e2-standard-8") }}'
        instance_type_db2: '{{ sap_db2_instance_type | default("e2-standard-8") }}'
        instance_type_ers: '{{ sap_nw_instance_type | default("e2-standard-8") }}'
        network_tags: '{{ sap_nw_network_tags | default([sap_network_tag | default("sap-allow-all")]) }}'
        num_instances_as: '{{ sap_nw_as_num_instances }}'
        project_id: '{{ sap_project_id }}'
        service_account_email: '{{ sap_nw_service_account_email | default("{}@{}.iam.gserviceaccount.com".format(sap_nw_service_account_name | default("sap-common-sa"), sap_project_id)) }}'
        source_image: '{{ sap_source_image | default("") }}'
        source_image_family: '{{ sap_source_image_family | default("") }}'
        source_image_project_id: '{{ sap_source_image_project }}'
        subnetwork: '{{ sap_nw_subnetwork }}'
        subnetwork_project_id: '{{ sap_subnetwork_project_id | default("") }}'
        zone_primary: '{{ sap_primary_zone }}'
        zone_secondary: '{{ sap_secondary_zone }}'
  tags: [db2, ascs, pas, nw, assertions]

- hosts: nodes
  become: yes
  roles:
  - role: nw-db2-ha
    vars:
      sap_nw_ascs_private_ip: '{{ terraform.outputs.ascs_internal_ip.value }}'
      sap_nw_pas_virtual_host: '{{ sap_nw_as_instance_basename }}-1'
      sap_nw_nfs_src: '{{ terraform.outputs.filestore_ip.value + ":/sap" if sap_filestore_name | default("") != "" else sap_nw_nfs_src | default("") }}'
      sap_nw_ascs_vip: '{{ terraform.outputs.ilb_internal_ip_ascs.value }}'
      sap_nw_ers_vip: '{{ terraform.outputs.ilb_internal_ip_ers.value }}'
      sap_hana_vip: '{{ terraform.outputs.ilb_internal_ip_db2.value }}'
      sap_db2_vip: '{{ terraform.outputs.ilb_internal_ip_db2.value }}'
      sap_db2_primary_ip: '{{ terraform.outputs.db2_primary_internal_ip.value }}'
      sap_db2_secondary_ip: '{{ terraform.outputs.db2_secondary_internal_ip.value }}'
  tags: [ascs, nw]
```
