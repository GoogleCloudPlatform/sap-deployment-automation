sap-hana-scaleout
=================

This role will install and configure HANA HA as part of `HANA-Scaleout` stacks 

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below

| Variable                          | Required | Default                                                  | Choices      | Comments                                                                                                                                                          |
|-----------------------------------|----------|----------------------------------------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sap_hana_install_files_bucket     | yes      | sap-deployment-media                                     |              | GCS Bucket storing the SAP install files                                                                                                                          |
| sap_hana_product_version          | yes      | 20SPS03                                                  |              | SAP HANA product version                                                                                                                                          |
| sap_product_and_version           | yes      | 'HANA/20SPS03'                                           |              | SAP HANA product and version path storing the install files                                                                                                       |
| sap_product_vars                  | yes      |                                                          |              | SAP HANA product install file names                                                                                                                               |
| sap_hostagent_rpm_remote_path     | yes      | "/hana/shared/software"                                  |              | Remote path for storing the SAP install files                                                                                                                     |
| sap_hana_data_partition_name      | yes      | hanadata                                                 |              | HANA data partition name                                                                                                                                          |
| sap_hana_backup_partition_name    | yes      | hanabackup                                               |              | HANA backup partition name                                                                                                                                        |
| sap_hana_shared_mountpoint        | yes      | /hana/shared                                             |              | Mountpoint for HANA shared volume                                                                                                                                 |
| sap_hana_data_mountpoint          | yes      | /hana/data                                               |              | Mountpoint for HANA data volume                                                                                                                                   |
| sap_hana_log_mountpoint           | yes      | /hana/log                                                |              | Mountpoint for HANA log volume                                                                                                                                    |
| sap_hana_usr_mountpoint           | yes      | /usr/sap                                                 |              | Mountpoint for HANA `usr/sap` volume                                                                                                                              |
| sap_hana_backup_mountpoint        | yes      | /hanabackup                                              |              | Mountpoint for HANA backup volume                                                                                                                                 |
| sap_hana_sid                      | yes      | BG1                                                      |              | HANA system ID                                                                                                                                                    |
| sap_hana_user                     | yes      | `{{ sap_hana_sid                                         | lower }}adm` |                                                                                                                                                                   | HANA sid adm username |
| sap_sapsys_gid                    | yes      | 2626                                                     |              | HANA `sapsys` group ID                                                                                                                                            |
| sap_hana_system_uid               | yes      | 2525                                                     |              | HANA system user ID                                                                                                                                               |
| sap_hana_instance_number          | yes      | "00"                                                     |              | HANA instance number                                                                                                                                              |
| sap_preconfigure_modify_etc_hosts | yes      | true                                                     | true/false   | Enable configuring `/etc/hosts`                                                                                                                                   |
| sap_domain                        | yes      | automation.local                                         |              | HANA domain name                                                                                                                                                  |
| sap_hana_env_type                 | yes      | development                                              |              | HANA environment type                                                                                                                                             |
| sap_hana_mem_restrict             | yes      | "n"                                                      | yes/no       | Restrict HANA memory usage                                                                                                                                        |
| sap_hana_ini_file                 | yes      |                                                          |              | HANA global ini filename                                                                                                                                          |
| sap_hana_ini_section              | yes      |                                                          |              | HANA global ini section value                                                                                                                                     |
| sap_hana_ini_setting              | yes      |                                                          |              | HANA global ini setting value                                                                                                                                     |
| sap_hana_ini_value                | yes      |                                                          |              | HANA global ini value                                                                                                                                             |
| sap_hana_password                 | yes      | ``                                                       |              | Common SAP password to be used for all users                                                                                                                      |
| sap_hana_ase_user_password        | yes      | `{{ sap_hana_password }}`                                |              | HANA ase user password                                                                                                                                            |
| sap_hana_db_system_password       | yes      | `{{ sap_hana_password }}`                                |              | HANA db system password                                                                                                                                           |
| sap_hana_common_master_password   | yes      | `{{ sap_hana_password }}`                                |              | HANA master password                                                                                                                                              |
| sap_hana_root_password            | yes      | `{{ sap_hana_password }}`                                |              | HANA root password                                                                                                                                                |
| sap_hana_sapadm_password          | yes      | `{{ sap_hana_password }}`                                |              | HANA sap adm user password                                                                                                                                        |
| sap_hana_sidadm_password          | yes      | `{{ sap_hana_password }}`                                |              | HANA sid adm user password                                                                                                                                        |
| backint_temp_path                 | yes      | /tmp/backint-gcs-install.sh                              |              | Temporary location on the system to store the backint install files/script                                                                                        |
| backint_dir                       | yes      | `/usr/sap/{{ sap_hana_sid }}/SYS/global/hdb/opt/backint` |              | HANA backint install directory                                                                                                                                    |
| backint_config_path               | yes      | `{{ backint_dir }}/backint-gcs/parameters.txt`           |              | HANA backint configuration file path                                                                                                                              |
| sap_hana_disks                    | yes      | ``                                                       |              | List of disks to be partioned, formated and mounted for SAP HANA use                                                                                              |
| sap_hana_logvols                  | yes      | ``                                                       |              | List of logical volumes to create on the system                                                                                                                   |
| sap_hana_preinstall_tasks         | yes      | ``                                                       |              | Path to an Ansible task file that will run before HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory |
| sap_hana_postinstall_tasks        | yes      | ``                                                       |              | Path to an Ansible task file that will run after HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory  |

Defaults
--------

All the defaults for this role are defined in `defaults/main.yml`

Dependencies
------------

This role is invoked in the `HANA-Scaleout` stack playbook.yml.

Example Playbook
----------------

```yaml
  - hosts: all
    roles:
        - sap-hana-scaleout
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru