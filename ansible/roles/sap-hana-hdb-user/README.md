sap-hana-hdb-user
=================

This role will create HANA db user as part of `HANA-HA` stack included in the `sap-hana-ha` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                    | Required | Default                       | Choices      | Comments                  |
|-----------------------------|----------|-------------------------------|--------------|---------------------------|
| sap_hana_monitoring_user    | yes      | hanahamu                      |              | HANA monitoring user name |
| sap_hana_db_system_password | yes      | `{{ sap_hana_password }}`     |              | HANA db system password   |
| sap_hana_user               | yes      | `{{ sap_hana_sid|lower }}adm` |              | HANA sid adm username     |
| sap_hana_instance_number    | yes      | "00"                          |              | HANA instance number      |

Dependencies
------------

This is role is invoked in the `sap-hana-ha` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

  - hosts: all
    roles:
        - sap-hana-hdb-user

License
-------

See license.md

Author Information
------------------

Bala Guduru
