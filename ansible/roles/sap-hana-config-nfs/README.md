sap-hana-config-nfs
===================

This role configure NFS on a HANA node as part of `HANA-Scaleout` stack included in the `sap-hana-scaleout` parent role.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default          | Choices | Comments                                 |
|----------------------------------|----------|------------------|---------|------------------------------------------|
| sap_hana_shared_mountpoint       | yes      | /hana/shared     |         | Mountpoint for HANA shared volume        |
| sap_hana_worker_node_names       | yes      | N/A              |         | HANA worker node names                   |

Dependencies
------------

This is role is invoked in the `sap-hana-scaleout` parent role and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-config-nfs
```

License
-------

See license.md

Author Information
------------------

Bala Guduru
