# NetWeaver-DB2-Standard

This stack builds a single node SAP application instance with DB2.

# Architecture Diagram

![NetWeaver-DB2-Standard](../images/netweaver-db2-standard.png)

# Prerequisites

## Infrastructure

If not using the provided Terraform, the following infrastructure components must exist.

### Application server

One application server machine is required.

#### Disks

Four disks must be created and attached to the application server machine.

`db2` - This disk will contain one logical volume to be mounted on `/db2`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `db2` to use the value Ansible uses for it by default.

`usrsap` - This disk will contain one logical volume to be mounted on `/usr/sap`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `usrsap` to use the value Ansible uses for it by default.

`sapmnt` - This disk will contain one logical volume to be used for `/sapmnt`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `sapmnt` to use the value Ansible uses for it by default.

`swap` - This disk will contain one logical volume to be used for swap.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `swap` to use the value Ansible uses for it by default.

## Inventory

If using Terraform and Ansible together, the inventory is automatically generated. If using Ansible separately from or without Terraform, the inventory must be defined as shown.

### Inventory groups

The following inventory groups must be defined containing the hosts described below. You can choose your own names for the groups.

* SAP application group
  * 1 host

### Examples

INI format:

```ini
[sap]
abcabap
```

YAML format:

```yaml
all:
  children:
    sap:
      hosts:
        abcabap:
```

## Install Media

See [the instructions](../install-media.md) for uploading install media to your bucket.

# Variables

## Variables related to Terraform

The following variables are only used when Terraform and Ansible are run together.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_nw_instance_type` | The GCE instance type for NetWeaver or S4HANA instances. | `string` | `n1-standard-8`| no |
| `sap_nw_service_account_name` | The name of the service account assigned to NetWeaver or S4HANA instances. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
| `sap_nw_subnetwork` | The name of the subnetwork used for machines and load balancers. | `string` | n/a | yes |
| `sap_project_id` | The project ID where instances are located. | `string` | n/a | yes |
| `sap_subnetwork_project_id` | The name of the subnetwork project, if using a shared VPC. If not given, `sap_project_id` will be used. | `string` | value of `sap_project_id` | no |
| `sap_source_image_family` | The source image family for machines. | `string` | n/a | yes |
| `sap_source_image_project` | The project for the source image. Official SAP images are from `rhel-sap-cloud` for RedHat or `suse-sap-cloud` for Suse. | `string` | n/a | yes |
| `sap_tf_state_bucket` | The GCS bucket where Terraform state is stored. If it does not exist, it will be created. There can only be one bucket globally with a given name (it gets a global DNS name). If there is a permissions error when creating this bucket, it is likely that one already exists in another project with the same name. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |
| `sap_tf_state_bucket_prefix` | This is the prefix for the Terraform state within the bucket defined in `sap_tf_state_bucket`. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |
| `sap_zone` | The zone where machines are located, for example `us-central1-a`. | `string` | n/a | yes |

## Additional Variables

The following variables are used with and without Terraform.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_db2_product_version` | The DB2 version. | `string` | `11.5MP5FP1` | no |
| `sap_nw_ascs_instance_number` | Instance number for ASCS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_nw_ascs_install_gateway` | Whether or not to install the gateway on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_install_web_dispatcher` | Whether or not to install the web dispatcher on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_virtual_host` | The hostname used to access ASCS. | `string` | value of `ansible_hostname` on the application machine | no |
| `sap_nw_db_sid` | The database tenant system ID for NetWeaver. This is a three character uppercase string which may include digits but must start with a letter. | `string` | value of `sap_nw_sid` | no |
| `sap_nw_install_files_bucket` | Bucket where application install media is located. | `string` | n/a | yes |
| `sap_nw_instance_name` | The name of the application instance. | `string` | n/a | yes |
| `sap_nw_password` | The password for NetWeaver or S4HANA. | `string` | n/a | yes |
| `sap_nw_pas_instance_number` | Instance number for PAS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `01` | no |
| `sap_nw_pas_virtual_host` | The hostname used to access PAS. | `string` | value of `ansible_hostname` on the application machine | no |
| `sap_nw_sid` | The System ID for NetWeaver. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_nw_product` | The SAP product, for example `NetWeaver`, `S4HANA`, or `BW4HANA`. | `string` | `NetWeaver` | no |
| `sap_nw_product_version` | The SAP product version, defaults to a version for NetWeaver. | `string` | `750` | no |
