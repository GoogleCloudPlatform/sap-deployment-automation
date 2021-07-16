# NetWeaver-DB2-Distributed

This stack defines an Ansible playbook and a Terraform root module to deploy the NetWeaver-DB2-Distributed stack.

The stack creates:

* One ASCS instance
* One DB2 instance
* One or more application server instances (PAS and AAS)

# Requirements

Python 3.5 or greater is required.

Ansible and its dependencies, defined in `requirements.txt` at the root of the repository, will be installed to a local cache directory automatically when using [`ansible-wrapper`](#usage). The correct version of Terraform will be installed by Ansible.

# Variables

Create a variables file using the example at `stacks/NetWeaver-DB2-Distributed/vars/deploy-vars.yml`, or see `ansible/roles/nw-db2-distributed/defaults/main.yml` for more options.

# Usage

After having created a variables file, use it to either create or delete a stack as shown below. Instructions assume the file is called `vars.yml`.

## Deploy NetWeaver-DB2-Distributed stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-Distributed/playbook.yml -e @vars.yml
```

## Destroy NetWeaver-DB2-Distributed stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-Distributed/playbook.yml -e @vars.yml -e state=absent
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
        disk_size_sapmnt: '{{ sap_nw_disk_size_sapmnt | default(25) }}'
        disk_size_swap: '{{ sap_nw_disk_size_swap | default(25) }}'
        disk_size_usrsap: '{{ sap_nw_disk_size_usrsap | default(25) }}'
        disk_type_usrsap: '{{ sap_nw_disk_type_usrsap | default("pd-ssd") }}'
        disk_type_boot: '{{ sap_nw_disk_type_boot | default("pd-ssd") }}'
        disk_type_db2: '{{ sap_nw_disk_type_db2 | default("pd-ssd") }}'
        disk_type_sapmnt: '{{ sap_nw_disk_type_sapmnt | default("pd-ssd") }}'
        disk_type_swap: '{{ sap_nw_disk_type_swap | default("pd-ssd") }}'
        instance_basename_as: '{{ sap_nw_as_instance_basename }}'
        instance_name_ascs: '{{ sap_nw_ascs_instance_name }}'
        instance_name_db2: '{{ sap_db2_instance_name }}'
        instance_type_as: '{{ sap_nw_as_instance_type | default("e2-standard-8") }}'
        instance_type_ascs: '{{ sap_nw_ascs_instance_type | default("e2-standard-8") }}'
        instance_type_db2: '{{ sap_db2_instance_type | default("e2-standard-8") }}'
        network_tags: '{{ sap_nw_network_tags | default([sap_network_tag | default("sap-allow-all")]) }}'
        num_instances_as: '{{ sap_nw_as_num_instances }}'
        project_id: '{{ sap_project_id }}'
        service_account_email: '{{ sap_nw_service_account_email | default("{}@{}.iam.gserviceaccount.com".format(sap_nw_service_account_name | default("sap-common-sa"), sap_project_id)) }}'
        source_image: '{{ sap_source_image | default("") }}'
        source_image_family: '{{ sap_source_image_family | default("") }}'
        source_image_project_id: '{{ sap_source_image_project }}'
        subnetwork: '{{ sap_nw_subnetwork }}'
        subnetwork_project_id: '{{ sap_subnetwork_project_id | default("") }}'
        zone: '{{ sap_zone }}'
  tags: [nw, db2, assertions]

- hosts: nodes
  become: yes
  roles:
  - role: nw-db2-distributed
    vars:
      sap_nw_ascs_private_ip: '{{ terraform.outputs.ascs_internal_ip.value }}'
      sap_nw_ascs_virtual_host: '{{ sap_nw_ascs_instance_name }}'
      sap_nw_pas_virtual_host: '{{ sap_nw_as_instance_basename }}-1'
  tags: [nw, db2]
```
