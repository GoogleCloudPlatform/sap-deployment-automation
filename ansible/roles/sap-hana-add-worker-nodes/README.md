Role Name
=========

This role adds SAP HANA worker nodes to the primary as part of the `sap-hana-scaleout` stack.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables required by this role.

| Variable                | Required | Default | Choices                   | Comments                                 |
|-------------------------|----------|---------|---------------------------|------------------------------------------|
| foo                     | no       | false   | true, false               | example variable                         |
| bar                     | yes      |         | eggs, spam                | example variable                         |

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: all
      roles:
         - ansible-role-template

License
-------

See license.md

Author Information
------------------

https://cyverse.org

# sap-hana-add-worker-nodes

Ansible role to add worker nodes as part of HANA scaleout stack.

# Requirements

Ansible version `>= 2.9.2`

# Role Variables

Worker node add configuration is defined in the `templates/configfile.j2` file.

# Author Information

Bala Guduru <balabharat.guduru@googlecloud.corp-partner.google.com>