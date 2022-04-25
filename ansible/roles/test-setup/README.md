test-setup
=======
This role creates and sets up a test system for CI/CD runs

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below.

| Variable                   | Required | Default      | Comments                                   |
|----------------------------|----------|--------------|--------------------------------------------|
| test_setup_media_bucket    | yes      | n/a          | Name of the bucket with installation media |
| test_setup_tf_path         | yes      | n/a          | Path to the test-setup terraform code      |
| test_setup_ssh_folder      | yes      | /root/.ssh   | Path of the ssh folder to be created       |
| test_setup_ssh_private_key | yes      | ida_rsa      | SSH private key to be created              |
| test_setup_ssh_public_key  | yes      | ida_rsa.pub  | SSH public key to be created               |
| test_setup_ssh_config      | yes      | config       | SSH config to be created                   |

Outputs
To access output variables from the terraform we regster the `setup` variable. Terraform outputs are accessed via
`setup.outpouts`

Example Playbook
----------------

```yaml
- hosts: 127.0.0.1
  roles:
    - name: test-setup
      vars:
        test_setup_media_bucket: "sap-download-media"
        test_setup_tf_path: ./test-setup

```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
