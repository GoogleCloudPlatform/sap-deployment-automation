sap-hana-mount-nfs
===================

This role will mount HANA shared and backup mount point on HANA nodes as part of `HANA-Scaleout-Standby` stack included in the `sap-hana-scaleout-standby` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                       | Required | Default      | Choices | Comments                          |
|--------------------------------|----------|--------------|---------|-----------------------------------|
| sap_hana_sid                   | yes      | BG1          |         | HANA system ID                    |
| sap_hana_data_mountpoint       | yes      | /hana/data   |         | Mountpoint for HANA data volume   |
| sap_hana_log_mountpoint        | yes      | /hana/log    |         | Mountpoint for HANA log volume    |
| sap_hana_shared_mountpoint     | yes      | /hana/shared |         | Mountpoint for HANA shared volume |
| sap_hana_backup_mountpoint     | yes      | /hanabackup  |         | Mountpoint for HANA backup volume |
| sap_hana_data_partition_name   | yes      | hanadata     |         | HANA data partition name          |
| sap_hana_shared_fs_mount_point | yes      |              |         | Mount point for shared filesystem |
| sap_hana_backup_fs_mount_point | yes      |              |         | Mount point for backup filesystem |
| sap_sapsys_gid                 | yes      | 2626         |         | HANA `sapsys` group ID            |
| sap_hana_system_uid            | yes      | 2525         |         | HANA system user ID               |

* Auto hana configuration is defined in the `templates/auto.hana.j2` file.

Dependencies
------------

This role is invoked in the `sap-hana-scaleout-standby` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-mount-nfs
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
