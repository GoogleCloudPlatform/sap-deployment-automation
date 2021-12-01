sap-hana-copy-ssh-keys
=========

This role will copy ssh keys b/w primary and seconday node as part of `HANA-Scaleout`, `HANA-Scaleout-Standby` stacks included in the `sap-hana-scaleout` and `sap-hana-scaleout-standby` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------
N/A

Dependencies
------------

This role is invoked in the `sap-hana-scaleout` and `sap-hana-scaleout-standby` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-copy-ssh-keys
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
