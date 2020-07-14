# terraform-awx-module

A Terraform module to set up an [AWX](https://github.com/ansible/awx) instance in GCP.

## Example

```hcl
module "awx" {
  source               = "../modules/terraform-awx-module"

  instance_name        = "sap-awx"
  project_id           = "project-xyz"
  subnetwork           = "subnet-01"
  ssl_certificate_file = "/path/to/cert.pem"
  ssl_key_file         = "/path/to/key.pem"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign\_public\_ip | Whether or not to assign a public IP to instance. | bool | `false` | false |
| awx\_repository | Git repository that hosts AWX installer. | string | `https://github.com/ansible/awx.git` | false |
| awx\_version | Version of AWX. | string | `13.0.0` | false |
| machine\_type | Type of machine. | string | `n1-standard-2` | false |
| instance\_name | Name of instance. | string | n/a | true |
| project\_id | ID of project where instance is located. | string | n/a | true |
| region | Region where instance is located. | string | `us-central1` | false |
| subnetwork | Subnetwork of instance's network interface. | string | n/a | true |
| subnetwork\_project\_id | Project ID where instance subnetwork is located. | string | same as `project_id` | false |
| service\_account | Service account assigned to instance. | object({email = string, scopes = list(string)}) | `{}` | false |
| source\_image\_family | Family of disk source image. | string | `debian-10` | false |
| source\_image\_project | Project of disk source image. | string | `debian-cloud` | false |
| ssl\_certificate\_file | Path to SSL certificate file. If given, `ssl_key_file` must also be defined. | string | `""` | false |
| ssl\_key\_file | Path to SSL private key file. If given, `ssl_certificate_file` must also be defined. | string | `""` | false |
| tags | List of network tags to assign to instance. | list(string) | | false |

## Outputs

| Name | Description |
|------|-------------|
| instance\_self\_link | Self link of instance. |
