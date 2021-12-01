sap-hana-scaleout-add-standby-nodes
===================================

This role will mount HANA shared and backup mount point on HANA nodes as part of `HANA-Scaleout-Standby` stack included in the `sap-hana-scaleout-standby` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default                       | Choices | Comments                             |
|----------------------------------|----------|-------------------------------|---------|--------------------------------------|
| sap_hana_sid                     | yes      | BG1                           |         | HANA system ID                       |
| sap_hana_usr_mountpoint          | yes      | /usr/sap                      |         | Mountpoint for HANA `usr/sap` volume |
| sap_hana_instance_number         | yes      | "00"                          |         | HANA instance number                 |
| sap_hana_user                    | yes      | 'bg1adm'                      |         | HANA SID user                        |
| sap_hana_gce_storage_client_path | yes      | /hana/shared/gceStorageClient |         | HANA gceStorageClient install path   |
| sap_hana_data_mountpoint         | yes      | /hana/data                    |         | Mountpoint for HANA data volume      |
| sap_hana_log_mountpoint          | yes      | /hana/log                     |         | Mountpoint for HANA log volume       |
| sap_hana_shared_mountpoint       | yes      | /hana/shared                  |         | Mountpoint for HANA shared volume    |
| sap_hana_standby_instance_name   | yes      |                               |         | SAP HANA standby instance name       |

Dependencies
------------

This role is invoked in the `sap-hana-scaleout-standby` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-scaleout-add-standby-nodes
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
