sap-preconfigure
================

This role configures a RHEL 7 or RHEL 8 system according to applicable SAP notes so that any SAP software can be installed. Future implementation may reduce the scope of this role, for example if certain installation or configuration steps are done in more specialized roles.

Requirements
------------

To use this role, your system needs to be installed according to:
- RHEL 7: SAP note 2002167, Red Hat Enterprise Linux 7.x: Installation and Upgrade, section "Installing Red Hat Enterprise Linux 7"
- RHEL 8: SAP note 2772999, Red Hat Enterprise Linux 8.x: Installation and Configuration, section "Installing Red Hat Enterprise Linux 8".

Note
----
Do not run this role against an SAP or other production system. The role will enforce a certain configuration on the managed node(s), which might not be intended.

Role Variables
--------------

- set in `defaults/main.yml`:

### Execute only certain steps of SAP notes
If the following variable is set to no, only certain steps of SAP notes will be executed or checked as per setting of variable `sap_preconfigure_<sap_note_number>_<step>`. If this variable is undefined or set to no, all steps of applicable SAP notes will be executed.
```yaml
sap_preconfigure_config_all
```

### Define configuration steps of SAP notes
For defining one or more steps of SAP notes to be executed or checked only, set variable `sap_preconfigure_config_all` to `no` and one or more of the following variables to `yes`:
```yaml
sap_preconfigure_2002167_0[2...6], example: sap_preconfigure_2002167_03
sap_preconfigure_1391070
sap_preconfigure_2772999_[02...10], example: sap_preconfigure_2772999_10
```

### Minimum package check
The following variable will make sure packages are installed at minimum required versions as defined in files `vars/*.yml`. Default is `yes`.
```yaml
sap_preconfigure_min_package_check
```

### Perform a yum update
If the following variable is set to `yes`, the role will run a `yum update` before performing configuration changes. Default is `no`. \
*Note*: The outcome of a `yum update` depends on the managed node's configuration for sticky OS minor version, see the description of the release option in `man subscription-manager`. For SAP HANA installations, setting a certain minor version with `subscscription-manager release --set=X.Y` is a strict requirement.
```yaml
sap_preconfigure_update
```

### How to behave if reboot is required
The following variable will ensure that the role will fail if a reboot is required, if undefined or set to `yes`, which is also the default. Rebooting the managed node can be done in the playbook which is calling this role. By setting the variable to `no`, the role will not fail if a reboot is required.
```yaml
sap_preconfigure_fail_if_reboot_required
```

### Define SELinux state
The following variable allows for defining the desired SELinux state. Default is `disabled`.
```yaml
sap_preconfigure_selinux_state
```

### size of TMPFS in GB:
The following variable contains a formula for setting the size of TMPFS according to SAP note 941735.
```yaml
sap_preconfigure_size_of_tmpfs_gb
```

### Locale
The following variable contains the locale to be check. This check is currently not implemented.
```yaml
sap_preconfigure_locale
```

### Modify /etc/hosts
If you not want the role to check and if necessary modify `/etc/hosts` according to SAP's requirements, set the following variable to `no`. Default is `yes`.
```yaml
sap_preconfigure_modify_etc_hosts
```

### hostname
If the role should not use the hostname as reported by Ansible (=`ansible_hostname`), set the following variable according to your needs:
```yaml
sap_hostname
```

### DNS domain name
If the role should not use the DNS domain name as reported by Ansible (=`ansible_domain`), set the following variable according to your needs:
```yaml
sap_domain
```

### IP address
If the role should not use the primary IP address as reported by Ansible (=`ansible_default_ipv4.address`), set the following variable according to your needs:
```yaml
sap_ip
```

### Linux group name of the database user
The following variable contains the name of the group which is used for the database(s), e.g. dba.
```yaml
sap_preconfigure_db_group_name
```

Dependencies
------------

This role does not depend on any other role.

Example Playbook
----------------

```yaml
---
    - hosts: all
      roles:
         - role: sap-preconfigure
```

Example Usage
-------------
ansible-playbook -l remote_host site.yml

License
-------

GNU General Public License v3.0

Author Information
------------------

Bernd Finger
