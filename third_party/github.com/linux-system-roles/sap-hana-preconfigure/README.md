sap-hana-preconfigure
=====================

This role configures a RHEL 7.x or RHEL 8 system according to the SAP notes so that SAP HANA is installable

Requirements
------------

To use this role your system needs to be installed with at least the RHEL core packges.
It is strongly recommended that you have run the following roles before this:
- 'linux-system-roles.timesync'
- 'linux-system-roles.sap-base-settings' (for RHEL 7.x until RHEL 7.5)
- 'linux-system-roles.sap-preconfigure' (for RHEL 7.6 and later and RHEL 8.x)

It needs to be properly registered and have at least the following RedHat repositories accessable (see also example playbook):

for RHEL 7.x:
- rhel-7-[server|for-power-le]-e4s-rpms
- rhel-sap-hana-for-rhel-7-[server|for-power-le]-e4s-rpms

for RHEL 8.x:
- rhel-8-for-[x86_64|ppc64le]-baseos-e4s-rpms
- rhel-8-for-[x86_64|ppc64le]-appstream-e4s-rpms
- rhel-8-for-[x86_64|ppc64le]-sap-solutions-e4s-rpms

For details, see the Red Hat knowledge base article: [How to subscribe SAP HANA systems to the Update Services for SAP Solutions](https://access.redhat.com/solutions/3075991))
You can use the [sap_rhsm](https://galaxy.ansible.com/redhat_sap/sap_rhsm) role to automate this process.

To install HANA on Red Hat Enterprise Linux 6, 7, or 8, you need some additional packages
which come in a special repository. To get this repository you need to have one
of the following products:

- [RHEL for SAP Solutions](https://access.redhat.com/solutions/3082481) (premium, standard)
- RHEL for Business Partner NFRs
- [RHEL Developer Subscription](https://developers.redhat.com/products/sap/download/)

To get a personal developer edition of RHEL for SAP solutions, please register as a developer and download the developer edition.

- [Registration Link](http://developers.redhat.com/register) :
  Here you can either register a new personal account or link it to an already existing
  **personal** Red Hat Network account.
- [Download Link](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.2/x86_64/product-software):
  Here you can download the Installation DVD for RHEL with your previously registered
  account

*NOTE:* This is a regular RHEL installation DVD as RHEL for SAP Solutions is no additional
 product but only a special bundling. The subscription grants you access to the additional
 packages through our content delivery network (CDN) after installation.

For supported RHEL releases [click here](https://access.redhat.com/solutions/2479121).

It is also important that your disks are setup according to the [SAP storage requirements for SAP HANA](https://www.sap.com/documents/2015/03/74cdb554-5a7c-0010-8F2c7-eda71af511fa.html). This [BLOG](https://blogs.sap.com/2017/03/07/the-ultimate-guide-to-effective-sizing-of-sap-hana/) is also quite helpful when sizing HANA systems.
You can use the [storage](https://galaxy.ansible.com/linux-system-roles/storage) role to automate this process

If you want to use this system in production, make sure that the time service is configured correctly. You can use [rhel-system-roles](https://access.redhat.com/articles/3050101) to automate this.

Note
----
For finding out which SAP notes will be used by this role, please check the contents of variable `__sap_hana_preconfigure_sapnotes` in files `vars/*.yml` (choose the file which matches your OS distribution and version).

Do not run this role against an SAP HANA or other production system. The role will enforce a certain configuration on the managed node(s), which might not be intended.

Role Variables
--------------

- set in `defaults/main.yml`:

### Execute only certain steps of SAP notes
If the following variable is set to no, only certain steps of SAP notes will be executed or checked as per setting of variable `sap_hana_preconfigure_<sap_note_number>_<step>`. If this variable is undefined or set to no, all installation and configuration steps of applicable SAP notes will be executed.
```yaml
sap_hana_preconfigure_config_all
```

### Perform installation or configuration steps, or both
If you have set `sap_hana_preconfigure_config_all` (see above) to `no`, you can limit the scope of the role to only execute the installation or the configuration steps. For this purpose, set one of the following variables, or both, to `yes`. The default for both is `no`.
```yaml
sap_hana_preconfigure_installation
sap_hana_preconfigure_configuration
```

### Define configuration steps of SAP notes
For defining one or more configuration steps of SAP notes to be executed or checked only, set variable `sap_hana_preconfigure_config_all` to `no`, `sap_hana_preconfigure_configuration` to `yes`, and one or more of the following variables to `yes`:
```yaml
sap_hana_preconfigure_2777782_[02...10], example: sap_hana_preconfigure_2777782_05
sap_hana_preconfigure_2772999_09
sap_hana_preconfigure_2292690_[01...07,09,10], example: sap_hana_preconfigure_2292690_02
sap_hana_preconfigure_2009879_3_9
sap_hana_preconfigure_2009879_3_13
sap_hana_preconfigure_2009879_3_14_[1...4]
sap_hana_preconfigure_2009879_3_15
sap_hana_preconfigure_2382421
```

### Repo checking and enabling
If you want the role to check and if necessary enable SAP HANA repos, set the following variable to `yes`. Default is `no`.
```yaml
sap_hana_preconfigure_enable_sap_hana_repos
```

### Override default repo list(s)
If you want to provide you own list(s) of repositories for checking and enabling, override one or more of the following variables. Otherwise, the defaults as set in vars/RedHat_*.yml will be used.
```yaml
sap_hana_preconfigure_req_repos_RedHat_7_x86_64
sap_hana_preconfigure_req_repos_RedHat_7_ppc64le
sap_hana_preconfigure_req_repos_RedHat_8_x86_64
sap_hana_preconfigure_req_repos_RedHat_8_ppc64le
```

### Set the RHEL release to a certain fixed minor release
If you want the role to set the RHEL release to a certain fixed minor release (according to installed RHEL release), set the following variable to `yes`. Default is `no`.
```yaml
sap_hana_preconfigure_set_minor_release
```

### Add the repository for IBM service and productivity tools for POWER (ppc64le only)
In case you do *not* want to automatically add the repository for the IBM service and productivity tools, set the following variable to `no`. Default is `yes`, meaning that the role will download and install the package specified in variable sap_hana_preconfigure_ibm_power_repo_url (see below) and also run the command /opt/ibm/lop/configure to accept the license.
```yaml
sap_hana_preconfigure_add_ibm_power_repo
```

### URL for IBM service and productivity tools for POWER (ppc64le only)
The following variable is set to the location of package ibm-power-repo-lastest.noarch.rpm or a package with similar contents, as defined by variable __sap_hana_preconfigure_ibm_power_repo_url in vars/RedHat_7.yml and vars/RedHat_8.yml.
You can replace it by your own URL by setting this variable to a different URL.
```yaml
sap_hana_preconfigure_ibm_power_repo_url
```

### How to behave if reboot is required
The following variable will ensure that the role will fail if a reboot is required, if undefined or set to `yes`, which is also the default. Rebooting the managed node can be done in the playbook which is calling this role. By setting the variable to `no`, the role will not fail if a reboot is required.
```yaml
sap_hana_preconfigure_fail_if_reboot_required
```

### Switch to tuned profile sap-hana
If you do not want the role to switch to tuned profile sap-hana, set the following variable to `no`. Default is `yes`. In case of `yes`, variable `sap_hana_preconfigure_use_tuned_where_possible` (see below) should be set to `yes` as well.
```yaml
sap_hana_preconfigure_switch_to_tuned_profile_sap_hana
```

### Use tuned profile sap-hana where possible
If you do not want to use the tuned profile sap-hana for configuring kernel parameters (where possible), and have the role configure them by changing the kernel command line instead, set the following variable to `no`. Default is `yes`. In case of `yes`, variable `sap_hana_preconfigure_switch_to_tuned_profile_sap_hana` (see above) should be set to `yes` as well.
Note: If this variable is set to `yes`, the role will not modify GRUB_CMDLINE_LINUX in /etc/default/grub, no matter how `sap_hana_preconfigure_modify_grub_cmdline_linux` (see below) is set.
```yaml
sap_hana_preconfigure_use_tuned_where_possible
```

### Modify grub2 line GRUB_CMDLINE_LINUX
If you do not want to modify the grub2 line GRUB_CMDLINE_LINUX in /etc/default/grub, set the following variable to `no`. The default is `yes`. Setting this variable to `no` probably only makes sense if `sap_hana_preconfigure_run_grub2_mkconfig` (see below) is also set to `no`.
Note: Even if this variable is set to `yes`, GRUB_CMDLINE_LINUX will only be modified if variable `sap_hana_preconfigure_use_tuned_where_possible` (see above) is set to `no`.
```yaml
sap_hana_preconfigure_modify_grub_cmdline_linux
```

### Run grub2-mkconfig
If you do not want to run grub2-mkconfig to regenerate the grub2 config file after a change to /etc/default/grub, set the following variable to `no`. The default is `yes`. Setting this variable to `no` probably only makes sense if `sap_hana_preconfigure_modify_grub_cmdline_linux` (see above) is also set to `no`.
```yaml
sap_hana_preconfigure_run_grub2_mkconfig
```

### HANA Major and minor version
These variables are used in all sap-hana roles so that they are only prefixed with `sap-hana`. If you use `sap-hana-mediacheck` role, these variables are read in automatically. The variable is used in the checks for [SAP Note 2235581](https://launchpad.support.sap.com/#/notes/2235581).

```yaml
sap_hana_version: "2"
sap_hana_sps: "0"
```

###  HANA kernel parameters
[SAP Note 238241](https://launchpad.support.sap.com/#/notes/238241) defines kernel parameters that all Linux systems need to set.
The default parameter recomendations are dependent on the OS release. Hence the OS dependant default setting is defined in
./vars/{{ansible_os_release}}.yml. If you need to add or change parameters for your system, copy these parameters from the vars file
into the variable sap_hana_preconfigure_kernel_parameters and add or change your settings, as in the following example:

```yaml
sap_hana_preconfigure_kernel_parameters:
  - { name: net.core.somaxconn, value: 4096 }
  - { name: net.ipv4.tcp_max_syn_backlog, value: 8192}
  - { name: net.ipv4.tcp_timestamps, value: 1 }
  - { name: net.ipv4.tcp_slow_start_after_idle, value: 0 }
```

Example Playbook
----------------

Here is an example playbook that prepares a server for hana installation.

```yaml
---
- hosts: hana
  remote_user: root

  vars:
      # subscribe-rhn role variables
      reg_activation_key: myregistration
      reg_organization_id: 123456

      repositories:
          - rhel-7-server-rpms
          - rhel-sap-hana-for-rhel-7-server-rpms

          # If you want to use 4 years update services, use:
          #       - rhel-7-server-e4s-rpms
          #       - rhel-sap-hana-for-rhel-7-server-e4s-rpms

          # If you want to use 2 years extend updates, use:
          #       - rhel-7-server-eus-rpms
          #       - rhel-sap-hana-for-rhel-7-server-eus-rpms


          # rhel-system-roles.timesync variables

  roles:
        - { role: redhat_sap.sap_rhsm }
        - { role: linux-system-roles.sap-base-settings }
        - { role: linux-system-roles.sap-hana-preconfigure }
```

Here is a simple playbook:

```yaml
---
    - hosts: all
      roles:
         - role: sap-preconfigure
         - role: sap-hana-preconfigure
```

Contribution
------------

Please read the [developer guidelines](./README.DEV.md) if you want to contribute

License
-------

GNU General Public License v3.0

Author Information
------------------

Markus Koch, Thomas Bludau, Bernd Finger, Than Ngo

Please leave comments in the github repo issue list
