sap-hana-fast-restart
=====================

This role will fast restart HANA database as part of `HANA-Scaleup`, `HANA-HA` stacks included in the `sap-hana-scaleup`, `sap-hana-ha` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default                  | Choices | Comments                                      |
|----------------------------------|----------|--------------------------|---------|-----------------------------------------------|
| sap_hana_sid                     | yes      | BG1                      |         | HANA SID                                      |
| sap_hana_user                    | yes      | 'bg1adm'                 |         | HANA SID user                                 |
| sap_hana_usr_mountpoint          | yes      | /usr/sap                 |         | Mountpoint for HANA `/usr/sap` volume         |

Dependencies
------------

This role is invoked in the `sap-hana-scaleup`, `sap-hana-ha` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-fast-restart
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
