# SAP Deployment Automation

This repository contains code for deploying SAP products in GCP using Ansible and Terraform.

The Terraform modules build machines and other infrastructure required. Ansible is used to configure the machines and install SAP products.

The provided Ansible can be used in two different ways: the first is to run Terraform to create the machines before configuring them, and the second is to run it against existing machines.

# Table of Contents

* [Prerequisites](#prerequisites)

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

  * [WebDisp](./docs/stacks/web-dispatcher.md)

# Prerequisites

## Installation Media

[SAP installation media](./docs/install-media.md) must be stored in a bucket according to the provided instructions.

## Cloud NAT

Machines need outbound internet access to download packages and register for licensing. Typically this is done by creating a [Cloud Nat](https://cloud.google.com/nat/docs/overview) instance in each region where machines are located.

Note, although it is possible to deploy SAP without outbound internet access, it requires additional work and the creation of custom [images](https://cloud.google.com/compute/docs/images).

## Service Account

A service account must be created with credentials that enable downloading files from the storage bucket where installation media is located. Machines that are clustered with [Pacemaker](https://wiki.clusterlabs.org/wiki/Pacemaker) also need credentials to access compute APIs for [STONITH](https://clusterlabs.org/pacemaker/doc/crm_fencing.html) to work. Clustered machines include HANA HA primary and secondary, ASCS, and ERS.

The name of the service account must be passed as a variable and it is attached to the machines automatically when they are created.

## Firewall

The firewall must enable traffic between machines and load balancers as required. For example, PAS and AAS machines need access to the HANA load balancer if you are running HA, or to the HANA machine directly if not running HA. Clustered machines will need access to each other for pacemaker to work.

The firewall rules need to be created beforehand, but can be controlled using tags that are configurable through the variables `sap_hana_network_tags` and `sap_nw_network_tags`. Machines will be created with the tags defined in these variables.

## SAP-Prerequisites Stack

To enable getting started quickly, a stack `SAP-Prerequisites` is provided that creates a service account `sap-common-sa` and open firewall rules for machines tagged `sap-allow-all`. The other stacks in this repository default to using that service account and network tag. The playbook in the `SAP-Prerequisites` stack only needs to be run one time before building any other stack.

# Quickstart

The fastest way to start is to use Ansible and Terraform together to build a full stack.

1. Upload your [SAP Install Media](./docs/install-media.md) to a bucket according to the provided instructions

2. Choose a stack, for example `NetWeaver-HA`. Define a file containing the variables for the stack by copying `stacks/NetWeaver-HA/vars/deploy-vars.yml` and modifying it to work in your GCP project. Check the [documentation for your stack](./docs/stacks) for more details about the available variables.

3. Assuming your variables file is called `vars.yml`, run the playbook from the root of the repository using the provided `ansible-wrapper` script:

```
./ansible-wrapper stacks/NetWeaver-HA/playbook.yml -e @vars.yml
```

See [Running Playbooks](./docs/running-playbooks.md) for more details on running playbooks.

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
