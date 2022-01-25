# WebDispatcher

# Architecture Diagram

![WebDispatcher](../images/web-dispatcher.png)

# Prerequisites

## Inventory

Required inventory variables if not using Terraform.

INI format:

```ini
[wd]
abcwd
```

YAML format:

```yaml
all:
  children:
    wd:
      hosts:
        abcwd:
```

## Install Media

See [the instructions](../install-media.md) for uploading install media to your bucket.

# Variables

## Variables related to Terraform

The following variables are only used when Terraform and Ansible are run together.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_project_id` | The project ID where instances are located. | `string` | n/a | yes |
| `sap_source_image_family` | The source image family for machines. | `string` | n/a | yes |
| `sap_source_image_project` | The project for the source image. Official SAP images are from `rhel-sap-cloud` for RedHat or `suse-sap-cloud` for Suse. | `string` | n/a | yes |
| `sap_tf_state_bucket` | The GCS bucket where Terraform state is stored. If it does not exist, it will be created. There can only be one bucket globally with a given name (it gets a global DNS name). If there is a permissions error when creating this bucket, it is likely that one already exists in another project with the same name. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |
| `sap_tf_state_bucket_prefix` | This is the prefix for the Terraform state within the bucket defined in `sap_tf_state_bucket`. Note that the pair `sap_tf_state_bucket`, `sap_tf_state_bucket_prefix` must be unique to avoid conflicts with other stacks. | `string` | n/a | yes |
| `sap_wd_instance_name` | Name of the Web Dispatcher machine. | `string` | n/a | yes |
| `sap_wd_instance_type` | Type of the Web Dispatcher machine. | `string` | `n1-standard-8` | no |
| `sap_wd_service_account_name` | The name of the service account assigned to the Web Dispatcher machine. This should not be a full service account email, just the name before the `@` symbol. | `string` | `sap-common-sa` | no |
| `sap_wd_subnetwork` | The name of the subnetwork used for machines. | `string` | n/a | yes |
| `sap_zone` | The zone where machines are located, for example `us-central1-a`. | `string` | n/a | yes |

## Additional Variables

The following variables are used with and without Terraform.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `sap_wd_install_files_bucket` | Bucket where Web Dispatcher installation files are located. | `string` | n/a | yes |
| `sap_wd_password` | Web Dispatcher password. | `string` | n/a | yes |
| `sap_wd_sid` | The System ID for Web Dispatcher. This is a three character uppercase string which may include digits but must start with a letter. | `string` | n/a | yes |
| `sap_wd_virtual_host` | The virtual hostname used for Web Dispatcher. | `string` | n/a | yes, if terraform is not used |
