# SAP Deployment Automation

This repository contains code for deploying SAP products in GCP using Ansible and Terraform. It also contains code for building an [AWX](https://github.com/ansible/awx) image and deploying an instance of it with Terraform.

Each SAP product has a stack defined in the `stacks` directory, with a `playbook.yml` in each stack's directory.

# Requirements

For running the Ansible playbooks from the command line, Python 3 is required.

# Deploying AWX

The AWX image provides a UI with jobs for all of the stacks in the `stacks` subdirectory of this repository.

The easiest way to get started with AWX is to deploy it with Terraform using the `bootstrap.sh` script included in the Terraform module directory.

Change to the module directory:

```
cd terraform/modules/awx
```

Then run `bootstrap.sh` with the instance name, project name, subnetwork, and region:

```
./bootstrap.sh -i xyz-awx -p project-123 -s subnet-456 -r us-central1
```

# Deploying a Stack with the Ansible CLI

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
