sap-hana-set-parameters
=======================

This role will set tenant parameters on HANA as part of `HANA-Scaleout` stack included in the `sap-hana-scaleout` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                    | Required | Default   | Choices | Comments                      |
|-----------------------------|----------|-----------|---------|-------------------------------|
| sap_hana_user               | yes      | 'bg1adm'  |         | HANA SID user                 |
| sap_hana_sid                | yes      | BG1       |         | HANA system ID                |
| sap_hana_instance_number    | yes      | "00"      |         | HANA instance number          |
| sap_hana_db_system_password | yes      | Google123 |         | HANA DB system password       |
| sap_hana_ini_file           | yes      |           |         | HANA global ini filename      |
| sap_hana_ini_section        | yes      |           |         | HANA global ini section value |
| sap_hana_ini_setting        | yes      |           |         | HANA global ini setting value |
| sap_hana_ini_value          | yes      |           |         | HANA global ini value         |


Dependencies
------------

This role is invoked in the `sap-hana-scaleout` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-set-parameters
```

License
-------

See license.md

Author Information
------------------

Bala Guduru
