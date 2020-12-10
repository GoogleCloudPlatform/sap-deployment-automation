# sap-iac

This repository contains code for deploying SAP products in GCP using Ansible and Terraform.

Each SAP product has a stack defined in the `stacks` directory, with a `playbook.yml` in each stack's directory.

# Requirements

Python 3 is required.

# Deploying a Stack

All stacks are deployed in the same way, using the `ansible-wrapper` script at the root of the repository. This script wraps the `ansible-playbook` command with some extra setup, such as creating a Python virtualenv and installing Ansible and all dependencies into it before running `ansible-playbook`. The arguments to `ansible-wrapper` are exactly the same as for `ansible-playbook`.

Always run `ansible-wrapper` from the root of the repository. Pass it the path to the playbook and a variables file with `-e`, for example to build the `NetWeaver-HA` stack you can run:

```
./ansible-wrapper stacks/NetWeaver-HA/playbook.yml -e @vars.yml
```

The `vars.yml` will differ depending on the stack you are deploying. The README of each stack has documentation for all of the variables, and each stack directory has a subdirectory `vars` with example variables to use as a starting point. Note that the `@` symbol causes Ansible to treat the value given to `-e` as a filename, whereas without `@` it treats the value as literal data, such as `-e key=value`.

# Destroying a Stack

Destroying works exactly the same as deploying, but needs an additional variable `state: absent`:

```
./ansible-wrapper stacks/NetWeaver-HA/playbook.yml -e @vars.yml -e state=absent
```
