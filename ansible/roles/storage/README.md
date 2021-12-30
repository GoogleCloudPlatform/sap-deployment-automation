storage
=======

This role will configure storage for SAP HANA/Netweaver systems as part of all stacks included in all the HANA/Netweaver parent roles.

Requirements
------------

Ansible version `>= 2.9.2`

Role Variables
--------------

List of variables accepted by the role are shown below.

| Variable | Required | Default | Choices | Comments                                             |
|----------|----------|---------|---------|------------------------------------------------------|
| disks    | yes      | n/a     |         | List of disks to be partioned, formated and mounted. |
| logvols  | yes      | n/a     |         | List of logical volumes to create on the system.     |

The `disks` variable is defined as a list of dicts, each with the following keys:

| Variable       | Required | Default | Choices | Comments                                                         |
|----------------|----------|---------|---------|------------------------------------------------------------------|
| name           | yes      | n/a     |         | Name given to volume group created on the disk.                  |
| partition_path | yes      | n/a     |         | The device name as given when attaching the disk to the machine. |


The `logvols` variable is defined as a dictionary, where the keys must map to one of the `name` values in `disks`, and the values are as follows:

| Variable   | Required | Default | Choices | Comments                                                                                    |
|------------|----------|---------|---------|---------------------------------------------------------------------------------------------|
| size       | yes      | n/a     |         | The size of the logical volume using LVM format.                                            |
| vol        | yes      | n/a     |         | The name of the logical volume.                                                             |
| mountpoint | no       | n/a     |         | The mount point of the filesystem, use `none` for swap. Not required if `mount` is `false`. |
| mount      | no       | `true`  |         | Whether or not to mount the filesystem after formatting it.                                 |
| fstype     | no       | `xfs`   |         | The type of the filesystem, use `swap` for a swap disk.                                     |

Dependencies
------------

This role is invoked in all the parent HANA/Netweaver roles and can be ran independently with caution by providing the required variables in the format expected.

Example Playbook
----------------

```yaml
- hosts: all
  roles:
    - name: storage
      vars:
        disks:
          - name: usrsap
            partition_path : usrsap
          - name: swap
            partition_path : swap
        logvols:
          usrsap: # This maps to a `name` value in `disks` (representing the volume group name).
            size: 100%VG
            vol: usrsap
            mountpoint: /usr/sap
          swap: # Also maps to a `name` value in `disks`.
            size: 100%VG
            vol: swap
            fstype: swap
            mountpoint: none
```

License
-------

See LICENSE file

Author Information
------------------

Bala Guduru
