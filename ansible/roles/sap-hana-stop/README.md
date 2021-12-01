sap-hana-stop
=============

This role will stop HANA service on a node as part of `HANA-Scaleout-Standby`, `HANA-Scaleout`, `HANA-Scaleup`, `HANA-HA` stacks included in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                    | Required | Default   | Choices | Comments                      |
|-----------------------------|----------|-----------|---------|-------------------------------|
| sap_hana_sid                | yes      | BG1       |         | HANA system ID                |
| sap_hana_instance_number    | yes      | "00"      |         | HANA instance number          |
| sap_hana_user               | yes      | 'bg1adm'  |         | HANA SID user                 |


Dependencies
------------

This role is invoked in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-stop
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
