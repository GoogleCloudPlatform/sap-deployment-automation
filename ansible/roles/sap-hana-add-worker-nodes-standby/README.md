sap-hana-add-worker-nodes-standby
=========

This role will add sap hana worker nodes as part of `HANA-Scaleout-Standby` stack included in the `sap-hana-scaleout-standby` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default                       | Choices | Comments                           |
|----------------------------------|----------|-------------------------------|---------|------------------------------------|
| sap_hana_shared_mountpoint       | yes      | /hana/shared                  |         | Mountpoint for HANA shared volume  |
| sap_hana_data_mountpoint         | yes      | /hana/data                    |         | Mountpoint for HANA data volume    |
| sap_hana_log_mountpoint          | yes      | /hana/log                     |         | Mountpoint for HANA log volume     |
| sap_hana_sid                     | yes      | BG1                           |         | HANA SID                           |
| sap_hana_worker_node_names       | yes      | N/A                           |         | HANA worker node names             |
| sap_hana_gce_storage_client_path | yes      | /hana/shared/gceStorageClient |         | HANA gceStorageClient install path |

* Worker node add configuration is defined in the `templates/configfile.j2` file.

Dependencies
------------

This is role is invoked in the `sap-hana-scaleout-standby` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

  - hosts: all
    roles:
        - sap-hana-add-worker-nodes-standby

License
-------

See license.md

Author Information
------------------

Bala Guduru
