sap-hana-mount-nfs
===================

This role will mount nfs vol from primary node on to secondary as part of `HANA-Scaleout` stack included in the `sap-hana-scaleout` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                      | Required | Default      | Choices | Comments                          |
|-------------------------------|----------|--------------|---------|-----------------------------------|
| sap_hana_shared_mountpoint    | yes      | /hana/shared |         | Mountpoint for HANA shared volume |
| sap_hana_master_instance_name | yes      |              |         | SAP HANA master instance name     |
| sap_hana_backup_mountpoint    | yes      | /hanabackup  |         | Mountpoint for HANA backup volume |
| sap_hana_create_backup_volume | yes      | true         |         | Create HANA backup volume         |
| sap_hana_sid                  | yes      | BG1          |         | HANA system ID                    |
| sap_hana_data_mountpoint      | yes      | /hana/data   |         | Mountpoint for HANA data volume   |
| sap_hana_log_mountpoint       | yes      | /hana/log    |         | Mountpoint for HANA log volume    |


Dependencies
------------

This is role is invoked in the `sap-hana-scaleout` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-mount-nfs
```

License
-------

See license.md

Author Information
------------------

Bala Guduru
