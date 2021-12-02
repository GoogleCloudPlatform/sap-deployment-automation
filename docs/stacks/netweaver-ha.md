# NetWeaver-HA

This stack builds SAP application instances such as NetWeaver or S4HANA in HA mode, which includes a HANA HA instance.

# Architecture Diagram

![NetWeaver-HA](../images/netweaver-ha.png)

# Prerequisites

## Infrastructure

If not using the provided Terraform, the following infrastructure components must exist.

### HANA

Two HANA machines are required, one for the primary and one for the secondary.

#### Disks

Two disks must be created and attached to each HANA machine.

`data` - This disk will contain three logical volumes, `data`, `shared`, and `log`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `data` to use the value Ansible uses for it by default. Changing this requires redefining the variable `sap_hana_disks`.

`backup` - The backup disk will have a single logical volume. Attach the disk to the machine with a `device_name` of `backup` to use the value Ansible uses for it by default.

### SCS

One ASCS machine is required.

One ERS machine is required.

#### Disks

Two disks must be created and attached to each SCS machine.

`usrsap` - This disk will contain one logical volume to be mounted on `/usr/sap`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `usrsap` to use the value Ansible uses for it by default.

`swap` - This disk will contain one logical volume to be used for swap.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `swap` to use the value Ansible uses for it by default.

### Application servers

One PAS machine is required.

Zero or more AAS machines are required.

#### Disks

Two disks must be created and attached to each application server machine.

`usrsap` - This disk will contain one logical volume to be mounted on `/usr/sap`.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `usrsap` to use the value Ansible uses for it by default.

`swap` - This disk will contain one logical volume to be used for swap.  Attach the disk to the machine with a [`device_name`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk#device_name) of `swap` to use the value Ansible uses for it by default.

### NFS

An NFS share must exist and be mountable from the SCS and application server machines. You can use Cloud Filestore, NetApp, or create the share on a GCE instance. The value of this NFS share will be passed in the variable `sap_nw_nfs_src`, for example `10.1.2.3:/sap`.

### Load balancers

There must be an internal load balancer (ILB) for HANA, one for ASCS, and when running Suse, one for ERS (RedHat uses an alias IP for ERS instead).

#### HANA

First, there must be one unmanaged instance group (UMIG) for the primary instance and one for the secondary instance.

The HANA ILB is then created with two backends: one whose group is the primary UMIG and another whose group is the secondary UMIG. The primary backend must have `failover` set to `false`, and the secondary backend must have `failover` set to `true`. The backends should have a [`failover_policy`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service#failover_policy) with `disable_connection_drain_on_failover` set to `true`, `drop_traffic_if_unhealthy` set to `true`, and `failover_ratio` set to `1`.

#### ASCS

There must be a UMIG created for the ASCS instance.

The ASCS ILB is created with two backends: one whose group is the ASCS UMIG and another whose group is the ERS UMIG. The ASCS backend must have `failover` set to `false`, and the ERS backend must have `failover` set to `true`. The backends should have a [`failover_policy`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service#failover_policy) with `disable_connection_drain_on_failover` set to `true`, `drop_traffic_if_unhealthy` set to `true`, and `failover_ratio` set to `1`.

#### ERS

There must be a UMIG created for the ERS instance (note this is true even for RedHat which does not use an ILB for ERS).

The ERS ILB is created with two backends: one whose group is the ASCS UMIG and another whose group is the ERS UMIG. These are the same UMIGs used for the ASCS ILB. The ERS backend must have `failover` set to `false`, and the ASCS backend must have `failover` set to `true`. The backends should have a [`failover_policy`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service#failover_policy) with `disable_connection_drain_on_failover` set to `true`, `drop_traffic_if_unhealthy` set to `true`, and `failover_ratio` set to `1`.

### Alias IPs

If running RedHat, the ERS machine does not use an internal load balancer and will use an alias IP instead. Reserve an internal IP address whose value will be passed to Ansible via `sap_nw_ers_vip`, and Pacemaker will handle attaching the IP to the machine.

## Inventory

If using Terraform and Ansible together, the inventory is automatically generated. If using Ansible separately from or without Terraform, the inventory must be defined as shown.

### Inventory groups

The following inventory groups must be defined containing the hosts described below. You can choose your own names for the groups.

* HANA group
  * 1 Primary host
  * 1 Secondary host

* SAP application group
  * 1 ASCS host
  * 1 ERS host
  * 1 PAS host
  * 0 or more AAS hosts

### HANA inventory host variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_hana_is_primary` | Whether or not this is the primary host. | `bool` | n/a | yes |

### SAP application inventory host variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_is_ascs` | Whether or not this is the ASCS host. | `bool` | n/a | yes, on the ASCS host |
| `sap_is_ers` | Whether or not this is the ERS host. | `bool` | n/a | yes, on the ERS host |
| `sap_is_scs` | Whether or not this is an ASCS or ERS host. | `bool` | n/a | yes, on the ASCS and ERS hosts |
| `sap_is_pas` | Whether or not this is the PAS host. | `bool` | n/a | yes, on the PAS host |
| `sap_is_aas` | Whether or not this an AAS host. | `bool` | n/a | yes, on the AAS hosts |

### Examples

INI format:

```ini
# Note: when using INI formatted inventory, boolean inventory values
# must be in uppercase or Ansible will convert them to strings.

[hana]
abchanapri sap_hana_is_primary=True
abchanasec sap_hana_is_primary=False

[sap]
abcascs sap_is_ascs=True sap_is_scs=True
abcers sap_is_ers=True sap_is_scs=True
abcpas sap_is_pas=True
abcaas01 sap_is_aas=True
abcaas02 sap_is_aas=True
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
    sap:
      hosts:
        abcascs:
          sap_is_ascs: true
          sap_is_scs: true
        abcers:
          sap_is_ers: true
          sap_is_scs: true
        abcpas:
          sap_is_pas: true
        abcaas01:
          sap_is_aas: true
        abcaas02:
          sap_is_aas: true
```

## Install Media

See [the instructions](../install-media.md) for uploading install media to your bucket.

# Variables

## Variables related to Terraform

The following variables are only used when Terraform and Ansible are run together.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_ascs_instance_name` | Base name of ASCS instance. | `string` | n/a | yes |
| `sap_ers_instance_name` | Base name of ERS instance. | `string` | n/a | yes |
| `sap_pas_instance_name` | Base name of application server instances. | `string` | n/a | yes |
| `sap_hana_instance_name` | Base name of HANA instances. The names of the primary and secondary instances will be automatically derived from this. To set explicit names for the primary and secondary instances, define `sap_hana_instance_name_primary` and `sap_hana_instance_name_secondary` instead. | `string` | n/a | yes, if `sap_hana_instance_name_primary` and `sap_hana_instance_name_secondary` are not defined |
| `sap_hana_instance_name_primary` | Name of primary HANA instance. Use instead of `sap_hana_instance_name` to explicitly set the name of the primary instance. | `string` | n/a | yes, if `sap_hana_instance_name` is not defined |
| `sap_hana_instance_name_secondary` | Name of secondary HANA instance. Use instead of `sap_hana_instance_name` to explicitly set the name of the secondary instance. | `string` | n/a | yes, if `sap_hana_instance_name` is not defined |
| `sap_hana_instance_type` | The GCE instance type for HANA. Must be one of `n1-highmem-32`, `n1-highmem-64`, `n1-highmem-96`, `n2-highmem-32`, `n2-highmem-48`, `n2-highmem-64`, `n2-highmem-80`, `m1-megamem-96`, `m1-ultramem-40`, `m1-ultramem-80`, `m1-ultramem-160`, `m2-ultramem-208`, or `m2-ultramem-416`. | `string` | `n1-highmem-32` | no |
| `sap_hana_service_account_name` | The name of the service account assigned to HANA instances. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
| `sap_nw_instance_type` | The GCE instance type for NetWeaver or S4HANA instances. | `string` | `n1-standard-8`| no |
| `sap_nw_as_num_instances` | Number of application server instances. The first instance will be the PAS, and additional instances will be AAS. | `int` | `1` | no |
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
| `sap_hana_virtual_host` | The hostname given to the HANA load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_hana_vip` | The IP address of the HANA load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_nw_ascs_instance_number` | Instance number for ASCS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_nw_ascs_install_gateway` | Whether or not to install the gateway on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_install_web_dispatcher` | Whether or not to install the web dispatcher on the ASCS node. | `bool` | `false` | no |
| `sap_nw_ascs_virtual_host` | The hostname given to the ASCS load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_nw_ascs_vip` | The IP address of the ASCS load balancer, added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_nw_ers_instance_number` | Instance number for ERS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `10` | no || `sap_nw_ers_instance_number` | Instance number for ERS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `10` | no |
| `sap_nw_ers_virtual_host` | The hostname given to the ERS load balancer (when using Suse) or IP alias (when using RHEL), added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_nw_ers_vip` | The IP address of the ERS load balancer (when using Suse), or IP alias (when using RHEL), added to `/etc/hosts` of instances. | `string` | n/a | yes |
| `sap_nw_install_files_bucket` | Bucket where NetWeaver or S4HANA installation files are located. | `string` | n/a | yes |
| `sap_nw_nfs_src` | The NFS share for NetWeaver or S4HANA, for example `10.0.0.100:/sap`. | `string` | n/a | yes |
| `sap_nw_password` | The password for NetWeaver or S4HANA. | `string` | n/a | yes |
| `sap_nw_pas_instance_number` | Instance number for PAS. This is a two digit number that must be in quotes, or Ansible will convert it into single digits, for example `00` without surrounding quotes gets converted to the number `0`. | `string` | `00` | no |
| `sap_nw_sid` | The System ID for NetWeaver. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_nw_product` | The SAP product, for example `NetWeaver`, `S4HANA`, or `BW4HANA`. | `string` | `NetWeaver` | no |
| `sap_nw_product_version` | The SAP product version, defaults to a version for NetWeaver. | `string` | `750` | no |
