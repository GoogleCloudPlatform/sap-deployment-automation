sap-hana-backup
=========

This role performs HANA db and System db backup as part of `HANA-HA` stack included in the `sap-hana-ha` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default                          | Choices | Comments                                 |
|----------------------------------|----------|----------------------------------|---------|------------------------------------------|
| sap_hana_instance_number         | yes      | "00"                             |         | HANA instance number                     |
| sap_hana_db_system_password      | yes      | Google123                        |         | HANA DB system password                  |
| sap_hana_backup_file_name        | yes      | "/hanabackup/data/pre_ha_config" |         | HANA backup filename                     |
| sap_hana_user                    | yes      | 'bg1adm'                         |         | HANA SID user                            |
| sap_hana_sid                     | yes      | BG1                              |         | HANA SID                                 |

Dependencies
------------

This role is invoked in the `sap-hana-ha` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-backup
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
