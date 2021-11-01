# forminator

An Ansible role to deploy infrastructure using Terraform.

# Requirements

Terraform must be installed and on the `PATH`.

This role operates either in "push mode" or not, as defined by the variable `sap_ansible_is_push_mode`. If the value of this variable is `true`, which is the default, then it is expected that the Terraform module will create machines that Ansible will connect to. In push mode, the role will create an Ansible inventory with ssh keys to use for authentication, then wait for the hosts to be available. If `sap_ansible_is_push_mode` is `false`, then no connection will be made to any machines.

If `sap_ansible_is_push_mode` is `true`, then the Terraform module that is passed in the `sap_tf_project_path` variable _must_ do the following:

1. It must provide an output called `inventory`. See [Terraform Inventory Output](#terraform-inventory-output) below for a full description.

2. It must define the variables `gce_ssh_user` and `gce_ssh_pub_key_file`, and use them to set the `ssh-keys` instance metadata, for example: `ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"`. This must be done for all machines that are present in the `inventory` output.

## Terraform Inventory Output

The Terraform `inventory` output is an array of maps, with each map representing a host in the inventory. Each one contains the following keys:

`host` (Required, type _string_) - The hostname or IP address of the inventory host.

`groups` (Required, type _array_ of _string_) - Inventory groups to which the host belongs.

`vars` (Optional, type _map_) - An arbitrary map of variables that will be defined as Ansible [host variables](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-one-machine-host-variables).

Example Terraform inventory output:

```
output "inventory" {
  value = [
    {
      host    = 10.10.10.10,
      groups  = ["abc"],
      vars    = {
        foo   = var.foo,
      },
    },
    {
      host    = 10.10.10.11,
      groups  = ["xyz"],
    },
    {
      host    = 10.10.10.12,
      groups  = ["abc", "xyz"],
      vars    = {
        foo   = var.foo,
        bar   = local.bar,
        baz   = {
          xyz = [{ a = 123 }, { b = 456 }],
        },
      },
    },
  ]
}
```

# Role Variables

`sap_ansible_is_push_mode`: (Optional, type _bool_, default `true`) - Whether or not to operate Ansible in push mode.

`sap_tf_state_bucket`: (Required, type _string_) - A bucket for storing Terraform state. The bucket must already exist.

`sap_tf_state_bucket_prefix`: (Required, type _string_) - The prefix in the bucket where the Terraform state file will be stored.

`sap_tf_project_path`: (Required, type _string_) - The path to the Terraform module which will be applied.

`sap_ssh_priv_key`: (Optional, type _string_, default `~/.ssh/id_rsa`) - Private ssh key for `sap_ssh_user`.

`sap_ssh_pub_key`: (Optional, type _string_, default `~/.ssh/id_rsa.pub`) - Public ssh key for `sap_ssh_user`.

`sap_ssh_user`: (Optional, type _string_, default `ansible`) - User to be added to machines along with a public ssh key, for use by Ansible.

`sap_state`: (Optional, choice of `present` or `absent`, default `present`) - Whether or not the Terraform resources should be present or absent.

`sap_tf_variables`: (Optional, type _map_, default `{}`) - Variables to be passed to Terraform. The variables `gce_ssh_user` and `gce_ssh_pub_key_file` will always be passed, regardless of the value of this variable.

# Example Playbook

```
- hosts: localhost
  connection: local
  roles:
  - role: forminator
    vars:
      sap_tf_state_bucket: jw-tf-state-xyz
      sap_tf_state_bucket_prefix: '{{ sap_instance_name }}'
      sap_tf_project_path: './tf'
      sap_tf_variables:
        gce_ssh_user: '{{ sap_ssh_user }}'
        gce_ssh_pub_key_file: '{{ playbook_dir }}/ssh-key.pub'
        boot_disk_size: 30
```

# Author Information

Joseph Wright <joseph.wright@googlecloud.corp-partner.google.com>
