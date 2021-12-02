# NetWeaver-Standard

This stack builds a SAP application instance with a separate HANA Scaleup instance.

# Architecture Diagram

![NetWeaver-Standard](../images/netweaver-standard.png)

# Prerequisites

## Infrastructure

If not using the provided Terraform, the following infrastructure components must exist.

### HANA

One HANA machine is required.

#### Disks

Two disks must be created and attached to each HANA machine.

`data` - This disk will contain three logical volumes, `data`, `shared`, and `log`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `data` to use the value Ansible uses for it by default. Changing this requires redefining the variable `sap_hana_disks`.

`backup` - The backup disk will have a single logical volume. Attach the disk to the machine with a `device_name` of `backup` to use the value Ansible uses for it by default.

### Application server

One application server machine is required.

#### Disks

Three disks must be created and attached to each application server machine.

`usrsap` - This disk will contain one logical volume to be mounted on `/usr/sap`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `usrsap` to use the value Ansible uses for it by default.

`sapmnt` - This disk will contain one logical volume to be used for `/sapmnt`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `sapmnt` to use the value Ansible uses for it by default.

`swap` - This disk will contain one logical volume to be used for swap.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `swap` to use the value Ansible uses for it by default.

## Inventory

If using Terraform and Ansible together, the inventory is automatically generated. If using Ansible separately from or without Terraform, the inventory must be defined as shown.

### Inventory groups

The following inventory groups must be defined containing the hosts described below. You can choose your own names for the groups.

* HANA group
  * 1 host

* SAP application group
  * 1 host

### Examples

INI format:

```ini
[hana]
abchana

[nw]
abcabap
```

YAML format:

```yaml
all:
  children:
    hana:
      hosts:
        abchana:
    nw:
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
| `sap_hana_instance_type` | The GCE instance type for HANA. Must be one of `n1-highmem-32`, `n1-highmem-64`, `n1-highmem-96`, `n2-highmem-32`, `n2-highmem-48`, `n2-highmem-64`, `n2-highmem-80`, `m1-megamem-96`, `m1-ultramem-40`, `m1-ultramem-80`, `m1-ultramem-160`, `m2-ultramem-208`, or `m2-ultramem-416`. | `string` | `n1-highmem-32` | no |
| `sap_hana_service_account_name` | The name of the service account assigned to HANA instances. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
| `sap_nw_instance_type` | The GCE instance type for NetWeaver or S4HANA instances. | `string` | `n1-standard-8`| no |
| `sap_nw_service_account_name` | The name of the service account assigned to NetWeaver or S4HANA instances. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
| `sap_nw_subnetwork` | The name of the subnetwork used for machines and load balancers. | `string` | n/a | yes |
| `sap_project_id` | The project ID where instances are located. | `string` | n/a | yes |
| `sap_primary_zone` | The zone for primary instances, HANA and ASCS and PAS, for example `us-central1-a`. | `string` | n/a | yes |
| `sap_secondary_zone` | The zone for primary instances, both HANA and ERS, for example `us-central1-b`. | `string` | n/a | yes |
| `sap_subnetwork_project_id` | The name of the subnetwork project, if using a shared VPC. If not given, `sap_project_id` will be used. | `string` | value of `sap_project_id` | no |
| `sap_source_image_family` | The source image family for machines. | `string` | n/a | yes |
| `sap_source_image_project` | The project for the source image. Official SAP images are from `rhel-sap-cloud` for RedHat or `suse-sap-cloud` for Suse. | `string` | n/a | yes |
| `sap_tf_state_bucket` | The GCS bucket where Terraform state is stored. If it does not exist, it will be created. There can only be one bucket globally with a given name (it gets a global DNS name). If there is a permissions error when creating this bucket, it is likely that one already exists in another project with the same name. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |
| `sap_tf_state_bucket_prefix` | This is the prefix for the Terraform state within the bucket defined in `sap_tf_state_bucket`. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |

## Additional Variables

The following variables are used with and without Terraform.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_hana_instance_name` | The name of the HANA instance. | `string` | n/a | yes |
| `sap_hana_instance_number` | Instance number for HANA. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_hana_install_files_bucket` | Bucket where HANA installation files are located. | `string` | n/a | yes |
| `sap_hana_password` | The password for HANA. | `string` | n/a | yes |
| `sap_hana_product_version` | The version of HANA. | `string` | `20SPS03` | no |
| `sap_hana_sid` | The System ID for HANA. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_hana_backup_size` | The size of the `backup` volume's filesystem, for example `415G`. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_data_size` | The size of the `data` volume's filesystem, for example `312G`. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_log_size` | The size of the `log` volume's filesystem, for example `104G`. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_shared_size` | The size of the `shared` volume's filesystem, for example `208G`. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_usr_size` | The size of the `/usr/sap` volume's filesystem, for example `32G`. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_virtual_host` | The hostname used by the application to connect to HANA. | `string` | n/a | yes |
| `sap_nw_ascs_instance_number` | Instance number for ASCS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_nw_ascs_install_gateway` | Whether or not to install the gateway on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_install_web_dispatcher` | Whether or not to install the web dispatcher on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_virtual_host` | The hostname used to access ASCS. | `string` | value of `ansible_hostname` on the application machine | no |
| `sap_nw_install_files_bucket` | Bucket where application install media is located. | `string` | n/a | yes |
| `sap_nw_instance_name` | The name of the application instance. | `string` | n/a | yes |
| `sap_nw_password` | The password for NetWeaver or S4HANA. | `string` | n/a | yes |
| `sap_nw_pas_instance_number` | Instance number for PAS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `01` | no |
| `sap_nw_pas_virtual_host` | The hostname used to access PAS. | `string` | value of `ansible_hostname` on the application machine | no |
| `sap_nw_sid` | The System ID for NetWeaver. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_nw_product` | The SAP product, for example `NetWeaver`, `S4HANA`, or `BW4HANA`. | `string` | `NetWeaver` | no |
| `sap_nw_product_version` | The SAP product version, defaults to a version for NetWeaver. | `string` | `750` | no |
