# HANA-HA

This stack builds HANA HA instances.

# Architecture Diagram

![HANA-HA](../images/hana-ha.png)

# Prerequisites

## Infrastructure

If not using the provided Terraform, the following infrastructure components must exist.

### HANA

Two HANA machines are required, one for the primary and one for the secondary.

#### Disks

Two disks must be created and attached to each HANA machine.

`data` - This disk will contain four logical volumes, `data`, `shared`, `log`, and `usr` (for `/usr/sap`).  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `data` to use the value Ansible uses for it by default, otherwise it requires redefining the variable `sap_hana_disks`. See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#hana-minimum-pd-sizes-ssd-balanced) for disk sizing.

`backup` - The backup disk will have a single logical volume. Attach the disk to the machine with a `device_name` of `backup` to use the value Ansible uses for it by default. See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#hana-minimum-pd-sizes-ssd-balanced) for disk sizing.

### Load balancer

First, there must be one unmanaged instance group (UMIG) for the primary instance and one for the secondary instance.

An internal load balancer (ILB) is then created with two backends: one whose group is the primary UMIG and another whose group is the secondary UMIG. The primary backend must have `failover` set to `false`, and the secondary backend must have `failover` set to `true`. The backends should have a [`failover_policy`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service#failover_policy) with `disable_connection_drain_on_failover` set to `true`, `drop_traffic_if_unhealthy` set to `true`, and `failover_ratio` set to `1`.

## Inventory

If using Terraform and Ansible together, the inventory is automatically generated. If using Ansible separately from or without Terraform, the inventory must be defined as shown.

### Inventory groups

The following inventory groups must be defined containing the hosts described below. You can choose your own names for the groups.

* HANA group
  * 1 Primary host
  * 1 Secondary host

### HANA inventory host variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_hana_is_primary` | Whether or not this is the primary host. | `bool` | n/a | yes |

### Examples

INI format:

```ini
# Note: when using INI formatted inventory, boolean inventory values
# must be in uppercase or Ansible will convert them to strings.

[hana]
abchanapri sap_hana_is_primary=True
abchanasec sap_hana_is_primary=False
```

YAML format:

```yaml
all:
  children:
    hana:
      hosts:
        abchanapri:
          sap_hana_is_primary: true
        abchanasec:
          sap_hana_is_primary: false
```

## Install Media

See [the instructions](../install-media.md) for uploading install media to your bucket.

# Variables

## Variables related to Terraform

The following variables are only used when Terraform and Ansible are run together.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_hana_instance_name` | Base name of HANA instances. The names of the primary and secondary instances will be automatically derived from this. To set explicit names for the primary and secondary instances, define `sap_hana_instance_name_primary` and `sap_hana_instance_name_secondary` instead. | `string` | n/a | yes, if `sap_hana_instance_name_primary` and `sap_hana_instance_name_secondary` are not defined |
| `sap_hana_instance_name_primary` | Name of primary HANA instance. Use instead of `sap_hana_instance_name` to explicitly set the name of the primary instance. | `string` | n/a | yes, if `sap_hana_instance_name` is not defined |
| `sap_hana_instance_name_secondary` | Name of secondary HANA instance. Use instead of `sap_hana_instance_name` to explicitly set the name of the secondary instance. | `string` | n/a | yes, if `sap_hana_instance_name` is not defined |
| `sap_hana_instance_type` | The GCE instance type for HANA. Must be one of `n1-highmem-32`, `n1-highmem-64`, `n1-highmem-96`, `n2-highmem-32`, `n2-highmem-48`, `n2-highmem-64`, `n2-highmem-80`, `m1-megamem-96`, `m1-ultramem-40`, `m1-ultramem-80`, `m1-ultramem-160`, `m2-ultramem-208`, or `m2-ultramem-416`. | `string` | `n1-highmem-32` | no |
| `sap_hana_service_account_name` | The name of the service account assigned to HANA instances. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
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
| `sap_hana_backint_bucket_name` | Name of bucket used by backint. | `string` | `''` | no |
| `sap_hana_backint_install` | Whether or not to install backint. | `bool` | n/a | yes |
| `sap_hana_fast_restart` | Whether or not to enable [HANA fast restart](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/ce158d28135147f099b761f8b1ee43fc.html). | `bool` | `false` | no |
| `sap_hana_instance_name_primary` | Name of primary HANA instance. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_instance_name_secondary` | Name of secondary HANA instance. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_instance_number` | Instance number for HANA. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_hana_install_files_bucket` | Bucket where HANA installation files are located. | `string` | n/a | yes |
| `sap_hana_password` | The password for HANA. | `string` | n/a | yes |
| `sap_hana_product_version` | The version of HANA. | `string` | `20SPS03` | no |
| `sap_hana_sid` | The System ID for HANA. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_hana_backup_size` | The size of the `backup` volume's filesystem in [LVM format](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html#parameter-size). See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#persistent_disk_size_requirements_for_scale-up_systems) for partition sizing. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_data_size` | The size of the `data` volume's filesystem in [LVM format](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html#parameter-size). See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#persistent_disk_size_requirements_for_scale-up_systems) for partition sizing. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_log_size` | The size of the `log` volume's filesystem in [LVM format](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html#parameter-size). See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#persistent_disk_size_requirements_for_scale-up_systems) for partition sizing. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_shared_size` | The size of the `shared` volume's filesystem in [LVM format](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html#parameter-size). See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#persistent_disk_size_requirements_for_scale-up_systems) for partition sizing. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_usr_size` | The size of the `/usr/sap` volume's filesystem in [LVM format](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html#parameter-size). See the [GCP SAP HANA planning guide](https://cloud.google.com/solutions/sap/docs/sap-hana-planning-guide#persistent_disk_size_requirements_for_scale-up_systems) for partition sizing. | `string` | n/a | yes, if terraform is not used |
| `sap_hana_virtual_host` | The hostname given to the HANA load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_hana_vip` | The IP address of the HANA load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
