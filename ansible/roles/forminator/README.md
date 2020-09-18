# forminator

An Ansible role to deploy infrastructure using Terraform.

# Requirements

Terraform must be installed and on the `PATH`.

The Terraform module that is passed in the `sap_tf_project_path` variable must do the following:

1. It must provide an output called `inventory` that is a map structured as `{ abc = [10.10.10.10], xyz = [10.10.10.11, 10.10.10.12] }`, where `abc` and `xyz` are host groups that will be converted into an Ansible inventory.

2. It must receive the variables `gce_ssh_user` and `gce_ssh_pub_key_file`, which will be added to all machine metadata as `ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"`.

# Role Variables

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
