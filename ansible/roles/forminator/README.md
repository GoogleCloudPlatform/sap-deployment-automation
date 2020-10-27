# forminator

An Ansible role to deploy infrastructure using Terraform.

# Requirements

Terraform must be installed and on the `PATH`.

This role operates either in "push mode" or not, as defined by the variable `sap_ansible_is_push_mode`. If the value of this variable is `true`, which is the default, then it is expected that the Terraform module will create machines that Ansible will connect to. In push mode, the role will create an Ansible inventory with ssh keys to use for authentication, then wait for the hosts to be available. If `sap_ansible_is_push_mode` is `false`, then no connection will be made to any machines.

If `sap_ansible_is_push_mode` is `true`, then the Terraform module that is passed in the `sap_tf_project_path` variable _must_ do the following:

1. It must provide an output called `inventory` that is a map structured as `{ abc = [10.10.10.10], xyz = [10.10.10.11, 10.10.10.12] }`, where `abc` and `xyz` are host groups that will be converted into an Ansible inventory.

2. It must receive the variables `gce_ssh_user` and `gce_ssh_pub_key_file`, which will be added to all machine metadata as `ssh-keys = "${var.gce_ssh_user}:${file("${var.gce_ssh_pub_key_file}")}"`.

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
