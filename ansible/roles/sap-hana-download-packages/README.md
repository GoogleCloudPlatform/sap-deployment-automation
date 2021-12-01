sap-hana-download-packages
=========

This role will download SAP install files from a GCS bucket as part of `HANA-Scaleout-Standby`, `HANA-Scaleout`, `HANA-Scaleup`, `HANA-HA` stacks included in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                         | Required | Default                  | Choices | Comments                                      |
|----------------------------------|----------|--------------------------|---------|-----------------------------------------------|
| sap_hostagent_rpm_remote_path    | yes      | "/hana/shared/software"  |         | Remote path for storing the SAP install files |
| sap_hana_install_files_bucket    | yes      | sap-deployment-media     |         | GCS Bucket storing the SAP install files      |
| sap_product_and_version          | yes      | 'HANA/20SPS03'           |         | SAP HANA product and version path storing the install files |
| cloudsdk_python_export_path      | yes      | /usr/bin/python3         |         | Python3 system install path                   |

Dependencies
------------

This role is invoked in the `sap-hana-scaleout-standby`, `sap-hana-scaleout`, `sap-hana-scaleup`, `sap-hana-ha` parent roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-download-packages
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
