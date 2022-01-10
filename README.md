# SAP Deployment Automation

This repository contains code for deploying SAP products in GCP using Ansible and Terraform.

The Terraform modules build machines and other infrastructure required. Ansible is used to configure the machines and install SAP products.

The provided Ansible can be used in two different ways: the first is to run Terraform to create the machines before configuring them, and the second is to run it against existing machines.

# Table of Contents

* [Quickstart](#quickstart)

* [Repository Structure](#repository-structure)

* [Install Media](./docs/install-media.md)

* [Running Playbooks](./docs/running-playbooks.md)

* [Support Matrix](./docs/support-matrix.md)

* Available Stacks

  * [HANA-HA](./docs/stacks/hana-ha.md)

  * [HANA-Scaleout](./docs/stacks/hana-scaleout.md)

  * [HANA-Scaleout-Standby](./docs/stacks/hana-scaleout-standby.md)

  * [HANA-Scaleup](./docs/stacks/hana-scaleup.md)

  * [NetWeaver-DB2-Distributed](./docs/stacks/netweaver-db2-distributed.md)

  * [NetWeaver-DB2-HA](./docs/stacks/netweaver-db2-ha.md)

  * [NetWeaver-DB2-Standard](./docs/stacks/netweaver-db2-standard.md)

  * [NetWeaver-Distributed](./docs/stacks/netweaver-distributed.md)

  * [NetWeaver-HA](./docs/stacks/netweaver-ha.md)

  * [NetWeaver-Standard](./docs/stacks/netweaver-standard.md)

# Quickstart

The fastest way to start is to use Ansible and Terraform together to build a full stack.

1. Upload your [SAP Install Media](./docs/install-media.md) to a bucket according to the provided instructions

2. Choose a stack, for example `NetWeaver-HA`. Define a file containing the variables for the stack by copying `stacks/NetWeaver-HA/vars/deploy-vars.yml` and modifying it to work in your GCP project. Check the [documentation for your stack](./docs/stacks) for more details about the available variables.

3. Assuming your variables file is called `vars.yml`, run the playbook from the root of the repository using the provided `ansible-wrapper` script:

```
./ansible-wrapper stacks/NetWeaver-HA/playbook.yml -e @vars.yml
```

# Repository Structure

`ansible.cfg` - This file contains [Ansible configuration settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html).

`ansible-wrapper` - This script is a wrapper around the `ansible-playbook` command. It first ensures a [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) exist and then installs all of the dependencies from `requirements.txt` into it before finally running `ansible-playbook` from the virtualenv. All arguments to this script will be passed to `ansible-playbook`.

`ansible/roles/` - This directory contains all Ansible roles.

`requirements.txt` - This file contains all Python dependencies, including Ansible, with their versions pinned. Code changes are tested only against these exact versions.

`stacks/` - This directory contains a subdirectory per supported stack, for example `HANA-HA` or `NetWeaver-HA`.

`stacks/<stack>/playbook.yml` - This is the playbook to run Ansible together with Terraform to create the infrastructure and configure the stack.

`stacks/<stack>/playbook-notf.yml` - This is the playbook to run Ansible without Terraform to configure the stack with existing infrastructure.

`stacks/<stack>/tf/` - This directory contains a [root Terraform module](https://www.terraform.io/language/modules#the-root-module) used as the Terraform entry point for the stack.

`stacks/<stack>/vars/` - This directory contains example variables used to configure the stack.

`terraform/modules/` - This directory contains all of the Terraform modules called by the root modules.

`third_party/` - This directory contains vendored third party dependencies.
