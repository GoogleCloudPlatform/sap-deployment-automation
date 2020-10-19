# terraform-awx-module

A Terraform module to set up an [AWX](https://github.com/ansible/awx) instance in GCP using a preinstalled image.

## Bootstrap Script

A script called `bootstrap.sh` is provided that downloads and runs Terraform in one step. Run it as follows:

```
./bootstrap.sh -i <instance-name> -p <project-id> -s <subnetwork>
```

## Example

You can run Terraform directly without the `bootstrap.sh` script. An example is provided below.

```hcl
module "awx" {
  # Note that your source path may differ depending on where you stored the module.
  source               = "../modules/terraform-awx-module"

  instance_name        = "sap-awx"
  project_id           = "project-xyz"
  subnetwork           = "subnet-01"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign\_public\_ip | Whether or not to assign a public IP to instance. | bool | `false` | false |
| machine\_type | Type of machine. | string | `n1-standard-2` | false |
| instance\_name | Name of instance. | string | n/a | true |
| project\_id | ID of project where instance is located. | string | n/a | true |
| region | Region where instance is located. | string | `us-central1` | false |
| subnetwork | Subnetwork of instance's network interface. | string | n/a | true |
| subnetwork\_project\_id | Project ID where instance subnetwork is located. | string | same as `project_id` | false |
| source\_image\_family | Family of disk source image. | string | `sap-awx` | false |
| source\_image\_project | Project of disk source image. | string | `albatross-duncanl-sandbox-2` | false |
| tags | List of network tags to assign to instance. | list(string) | `[]` | false |

## Outputs

| Name | Description |
|------|-------------|
| instance\_self\_link | Self link of instance. |
