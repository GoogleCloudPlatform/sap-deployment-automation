sap-hana-install
================

This role will install and configure HANA on the nodes as part of `HANA-Scaleout-Standby`, `HANA-Scaleout`, `HANA-Scaleup`, `HANA-HA` stacks included in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                             | Required | Default                      | Choices | Comments                                                                                                                                                          |
|--------------------------------------|----------|------------------------------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sap_hana_user                        | yes      | `{{ sap_hana_sidlower }}adm` |         | HANA sid adm username                                                                                                                                             |
| sap_hana_instance_number             | yes      | "00"                         |         | HANA instance number                                                                                                                                              |
| sap_hana_sid                         | yes      | BG1                          |         | HANA system ID                                                                                                                                                    |
| sap_hana_shared_mountpoint           | yes      | /hana/shared                 |         | Mountpoint for HANA shared volume                                                                                                                                 |
| sap_hana_preinstall_tasks            | yes      |                              |         | Path to an Ansible task file that will run before HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory |
| sap_hana_postinstall_tasks           | yes      | ``                           |         | Path to an Ansible task file that will run after HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory  |
| sap_product_vars                     | yes      |                              |         | SAP HANA product install file names                                                                                                                               |
| sap_product_and_version              | yes      | 'HANA/20SPS03'               |         | SAP HANA product and version path storing the install files                                                                                                       |
| sap_hostagent_rpm_remote_path        | yes      | "/hana/shared/software"      |         | Remote path for storing the SAP install files                                                                                                                     |
| sap_hana_deployment_hdblcm_extraargs | no       |                              |         | Extra arguments to pass during HANA install                                                                                                                       |
| sap_sapsys_gid                       | yes      | 2626                         |         | HANA `sapsys` group ID                                                                                                                                            |

* HANA install configuration is defined in the `templates/configfile.j2` file.

Dependencies
------------

This role is invoked in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-hsr
```

License
-------

See license.md

Author Information
------------------

Bala Guduru
