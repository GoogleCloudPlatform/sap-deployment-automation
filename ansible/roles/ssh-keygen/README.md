ssh-keygen
==============

This role will generate ssh-keys as part of `HANA-Scaleout-Standby`, `HANA-Scaleout` stacks included in the `sap-hana-scaleout-standby`, `sap-hana-scaleout` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

N/A

Dependencies
------------

This is role is invoked in the `sap-hana-scaleout-standby`, `sap-hana-scaleout` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

  - hosts: all
    roles:
        - ssh-keygen

License
-------

See license.md

Author Information
------------------

Bala Guduru
