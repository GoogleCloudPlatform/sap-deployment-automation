storage
=======

This role will configure storage for SAP HANA/Netweaver systems as part of all stacks included in all the HANA/Netweaver parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable         | Required | Default                  | Choices    | Comments                                                             |
|------------------|----------|--------------------------|------------|----------------------------------------------------------------------|
| sap_hana_disks   | yes      | `{{ sap_hana_disks }}`   |            | List of disks to be partioned, formated and mounted for SAP HANA use |
| sap_hana_logvols | yes      | `{{ sap_hana_logvols }}` |            | List of logical volumes to create on the system                      |
| sap_hana_swapon  | yes      | false                    | true/false | Enable swap memory for HANA                                          |


Dependencies
------------

This role is invoked in all the parent HANA/Netweaver roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - storage
```

License
-------

See license.md

Author Information
------------------

Bala Guduru
