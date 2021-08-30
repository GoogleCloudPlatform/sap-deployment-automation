# sap-hana-scaleout-standby

A higher level ansible role to install and configure HANA Scaleout.

# Requirements

Ansible version `>= 2.9.2`
Running GCE instance deployed using the terraform code under `stacks/HANA-Scaleout-standby`

# Role Variables

`sap_hana_install_files_bucket`: GCS Bucket storing the SAP install files

`sap_hana_product_version`: SAP HANA product version

`sap_product_and_version`: SAP HANA product and version path storing the install files

`sap_product_vars`: SAP HANA product install file names.

`sap_hostagent_rpm_remote_path`: Remote path for storing the SAP install files

`sap_hana_data_partition_name`: HANA data partition name

`sap_hana_create_backup_volume`: Create HANA backup volume

`sap_hana_backup_partition_name`: HANA backup partition name

`sap_hana_shared_mountpoint`: Mountpoint for HANA shared volume

`sap_hana_data_mountpoint`: Mountpoint for HANA data volume

`sap_hana_log_mountpoint`: Mountpoint for HANA log volume

`sap_hana_usr_mountpoint`: Mountpoint for HANA `usr/sap` volume

`sap_hana_backup_mountpoint`: Mountpoint for HANA backup volume

`sap_hana_sid`: HANA system ID

`sap_hana_user`: HANA sid adm username

`sap_sapsys_gid`: HANA `sapsys` group ID

`sap_hana_system_uid`: HANA system user ID

`sap_hana_instance_number`: HANA instance number

`sap_preconfigure_modify_etc_hosts`: Enable configuring `/etc/hosts`. Options: `true/false`

`sap_domain`: HANA domain name

`sap_hana_env_type`: HANA environment type

`sap_hana_mem_restrict`: Restrict HANA memory usage. Options: `yes/no`

`sap_hana_swapon`: Enable swap memory for HANA

`sap_hana_ini_file`: HANA global ini filename

`sap_hana_ini_section`: HANA global ini section value

`sap_hana_ini_setting`: HANA global ini setting value

`sap_hana_ini_value`: HANA global ini value

`sap_hana_password`: Common SAP password to be used for all users

`sap_hana_ase_user_password`: HANA ase user password. Defaults to `sap_hana_password`

`sap_hana_db_system_password`: HANA db system password. Defaults to `sap_hana_password`

`sap_hana_common_master_password`: HANA master password. Defaults to `sap_hana_password`

`sap_hana_root_password`: HANA root password. Defaults to `sap_hana_password`

`sap_hana_sapadm_password`: HANA sap adm user password. Defaults to `sap_hana_password`

`sap_hana_sidadm_password`: HANA sid adm user password. Defaults to `sap_hana_password`

`backint_temp_path`: Temporary location on the system to store the backint install files/script

`backint_dir`: HANA backint install directory

`backint_config_path`: HANA backint configuration file path

`sap_hana_disks`: List of disks to be partioned, formated and mounted for SAP HANA use

`sap_hana_logvols`: List of logical volumes to create on the system

# Defaults:

All the defaults for this role are defined in `defaults/main.yml`

# Author Information

Bala Guduru <balabharat.guduru@googlecloud.corp-partner.google.com>