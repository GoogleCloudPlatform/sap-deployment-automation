# NetWeaver-DB2-Standard

This stack defines an Ansible playbook and a Terraform root module to deploy the NetWeaver-DB2-Standard stack. A single instance is created that runs DB2, ASCS, and PAS.
# Deployment Architecture

![NetWeaver-DB2-Standard](./images/standard.png)

# Requirements

Python 3.5 or greater is required.

Ansible and its dependencies, defined in `requirements.txt` at the root of the repository, will be installed to a local cache directory automatically when using [`ansible-wrapper`](#usage). The correct version of Terraform will be installed by Ansible.

# Support Matrix

The following OS and DB2 version combinations have been tested with images from the `rhel-sap-cloud` and `suse-sap-cloud` projects.

|                    | rhel-7-4-sap       | rhel-7-6-sap-ha    | rhel-7-7-sap-ha    | sles-12-sp3-sap    | sles-12-sp4-sap    | sles-12-sp5-sap    | sles-15-sap        | sles-15-sp1-sap    | sles-15-sp2-sap    | sles-15-sp3-sap    |
| ------------------ | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: |
| **DB2 10.5FP9**    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x:                | :x:                | :x:                | :x:                |
| **DB2 11.1MP4FP6** | :x:                | :white_check_mark: | :white_check_mark: | :x:                | :white_check_mark: | :white_check_mark: | :x:                | :x:                | :x:                | :x:                |
| **DB2 11.5MP5FP1** | :x:                | :white_check_mark: | :white_check_mark: | :x:                | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |

# Variables

Create a file containing variables as follows. An example is provided at `stacks/NetWeaver-DB2-Standard/vars/deploy-vars.yml`.

`sap_db2_product_version`: (Optional, type _string_, default `11.5MP5FP1`) - The version of DB2. Supported versions are `10.5FP9`, `11.1MP4FP6`, and `11.5MP5FP1`.

`sap_nw_instance_name`: (Required, type _string_) - The name of the instance.

`sap_nw_disk_size_boot` (Optional, type _int_, default `30`) - The size of the boot disk in GB.

`sap_nw_disk_size_db2`: (Optional, type _int_, default `50`) - The size of the `/db2` disk in GB.

`sap_nw_disk_size_sapmnt`: (Optional, type _int_, default `25`) - The size of the `/sapmnt` disk in GB.

`sap_nw_disk_size_swap`: (Optional, type _int_, default `25`) - The size of the swap disk in GB.

`sap_nw_disk_size_usrsap`: (Optional, type _int_, default `25`) - The size of the `/usr/sap` disk in GB.

`sap_nw_disk_type_boot`: (Optional, type _string_, default `pd-ssd`) - The type of the boot disk.

`sap_nw_disk_type_db2`: (Optional, type _string_, default `pd-ssd`) - The type of the `/db2` disk.

`sap_nw_disk_type_sapmnt`: (Optional, type _string_, default `pd-ssd`) - The type of the `/sapmnt` disk.

`sap_nw_disk_type_swap`: (Optional, type _string_, default `pd-ssd`) - The type of the swap disk.

`sap_nw_disk_type_usrsap`: (Optional, type _string_, default `pd-ssd`) - The type of the `/usr/sap` disk.

`sap_nw_instance_type`: (Optional, type _string_, default `e2-standard-8`) - The type of the instance.

`sap_nw_service_account_name`: (Optional, type _string_, default `sap-common-sa`) - The name of the service account assigned to the instance. This should not be a full service account email, just the name before the `@` symbol.

`sap_project_id`: (Required, type _string_) - The project ID where the instance and all cloud resources are located.

`sap_source_image`: (Conditional, type _string_, default `""`) - The image used to create the instance. If this string is empty, `sap_source_image_family` must be defined. If both are defined, `sap_source_image` takes precedence.

`sap_source_image_family`: (Conditional, type _string_, default `""`) - The image family used to create the instance. If this string is empty, `sap_source_image` must be defined.

`sap_source_image_project`: (Required, type _string_) - The project in which `sap_source_image` or `sap_source_image_family` are located.

`sap_nw_subnetwork`: (Required, type _string_) - The subnetwork in which the instance is located.

`sap_nw_network_tags`: (Optional, type _list_ of _string_, default `[sap-allow-all]`) - A list of network tags for the instance.

`sap_zone`: (Optional, type _string_, default `us-central1-a`) - The zone where the instance is located.

`sap_nw_sid`: (Required, type _string_) - The System ID for NetWeaver. This is a three character uppercase string which may include digits but must start with a letter.

`sap_nw_ascs_instance_number`: (Optional, type _string_, default `01`) - The instance number for ASCS. This is a two digit number, but the variable must be defined as a string surrounded by quotes.

`sap_nw_pas_instance_number`: (Optional, type _string_, default `00`) - The instance number for PAS. This is a two digit number, but the variable must be defined as a string surrounded by quotes.

`sap_nw_password`: (Conditional, type _string_) - The password for all users. If this is not defined, the variables `sap_nw_master_password`, `sap_nw_sapadm_password`, `sap_nw_db2sid_password`, `sap_nw_sapsid_password`, and `sap_nw_sidadm_password` must be defined.

`sap_nw_master_password`: (Conditional, type _string_) - The master password for NetWeaver. If not defined, the value of `sap_nw_password` is used.

`sap_nw_sapadm_password`: (Conditional, type _string_) - The sapadm password. If not defined, the value of `sap_nw_password` is used.

`sap_nw_db2sid_password`: (Conditional, type _string_) - The db2sid password. If not defined, the value of `sap_nw_password` is used.

`sap_nw_sapsid_password`: (Conditional, type _string_) - The sapsid password. If not defined, the value of `sap_nw_password` is used.

`sap_nw_sidadm_password`: (Conditional, type _string_) - The sidadm password. If not defined, the value of `sap_nw_password` is used.

`sap_nw_install_files_bucket`: (Required, type _string_) - The bucket where the SAP install media is located.

`sap_tf_state_bucket`: (Required, type _string_) - The bucket used for storing Terraform state.

`sap_tf_state_bucket_prefix`: (Required, type _string_) - The path in `sap_tf_state_bucket` where the Terraform state is stored.

# Usage

After having created a variables file, use it to either create or delete a stack as shown below. Instructions assume the file is called `vars.yml`.

## Deploy NetWeaver-DB2-Standard stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-Standard/playbook.yml -e @vars.yml
```

## Destroy NetWeaver-DB2-Standard stack

From the root of the repository, run:

```
./ansible-wrapper stacks/NetWeaver-DB2-Standard/playbook.yml -e @vars.yml -e state=absent
```

# Example playbook

```yaml
- hosts: 127.0.0.1
  connection: local
  roles:
  - role: forminator
    vars:
      sap_tf_project_path: ./tf
      sap_state: '{{ state | default("present") }}'
      sap_tf_version: 0.14.11
      sap_tf_variables:
        disk_size_boot: '{{ sap_nw_disk_size_boot | default(30) }}'
        disk_size_db2: '{{ sap_nw_disk_size_db2 | default(50) }}'
        disk_size_sapmnt: '{{ sap_nw_disk_size_sapmnt | default(25) }}'
        disk_size_swap: '{{ sap_nw_disk_size_swap | default(25) }}'
        disk_size_usrsap: '{{ sap_nw_disk_size_usrsap | default(25) }}'
        disk_type_boot: '{{ sap_nw_disk_type_boot | default("pd-ssd") }}'
        disk_type_db2: '{{ sap_nw_disk_type_db2 | default("pd-ssd") }}'
        disk_type_sapmnt: '{{ sap_nw_disk_type_sapmnt | default("pd-ssd") }}'
        disk_type_swap: '{{ sap_nw_disk_type_swap | default("pd-ssd") }}'
        disk_type_usrsap: '{{ sap_nw_disk_type_usrsap | default("pd-ssd") }}'
        instance_name: '{{ sap_nw_instance_name }}'
        instance_type: '{{ sap_nw_instance_type | default("n1-highmem-32") }}'
        network_tags: '{{ sap_nw_network_tags | default([sap_network_tag | default("sap-allow-all")]) }}'
        project_id: '{{ sap_project_id }}'
        service_account_email: '{{ sap_nw_service_account_email | default("{}@{}.iam.gserviceaccount.com".format(sap_nw_service_account_name | default("sap-common-sa"), sap_project_id)) }}'
        source_image: '{{ sap_source_image | default("") }}'
        source_image_family: '{{ sap_source_image_family | default("") }}'
        source_image_project: '{{ sap_source_image_project }}'
        subnetwork: '{{ sap_nw_subnetwork }}'
        subnetwork_project_id: '{{ sap_subnetwork_project_id | default("") }}'
        zone: '{{ sap_zone | default("us-central1-a") }}'
  tags: [assertions]

- hosts: nw
  become: yes
  vars:
    sap_nw_ascs_virtual_host: '{{ sap_nw_instance_name }}'
    sap_nw_pas_virtual_host: '{{ sap_nw_instance_name }}'
  roles:
  - role: nw-db2-standard
```
