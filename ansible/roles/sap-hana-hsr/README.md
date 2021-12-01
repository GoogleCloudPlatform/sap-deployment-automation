sap-hana-hsr
============

This role will configure HANA system replication (HSR) on HANA nodes as part of `HANA-HA` stack included in the `sap-hana-ha` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                       | Required | Default                           | Choices | Comments                               |
|--------------------------------|----------|-----------------------------------|---------|----------------------------------------|
| sap_hana_user                  | yes      | `{{ sap_hana_sid|lower }}adm`     |         | HANA sid adm username                  |
| sap_hana_instance_number       | yes      | "00"                              |         | HANA instance number                   |
| sap_hana_sid                   | yes      | BG1                               |         | HANA system ID                         |
| sap_hana_primary_instance_name | yes      | Defined in the stack playbook.yml |         | Primary HANA instance name             |
| sap_hana_hsr_replication_mode  | yes      | syncmem                           |         | HANA system replication mode           |
| sap_hana_hsr_operation_mode    | yes      | logreplay                         |         | HANA system replication operation mode |
| sap_hana_shared_mountpoint     | yes      | /hana/shared                      |         | Mountpoint for HANA shared volume      |

* HANA HSR configuration is defined in the `templates/etc/sudoers.d/sap_hana_sr.j2` file.

Dependencies
------------

This role is invoked in the `sap-hana-ha` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-hsr
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
