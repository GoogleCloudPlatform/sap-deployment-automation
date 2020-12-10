# pacemaker-hana

This is a role for configuring [Pacemaker](https://clusterlabs.org/pacemaker/), whose tasks are intended to be included in other roles. See the tasks for the `pacemaker-hana` and `pacemaker-netweaver` roles for an example.

# Requirements

A RHEL or Suse instance.

# Role Variables

`sap_cluster_name` (Optional, default `hacluster`) - Logical name of cluster.

`sap_cluster_user` (Optional, default `hacluster`) - The local user created for Pacemaker.

`sap_cluster_user_password` (Required) - Password of `sap_cluster_user`.

`sap_hana_health_check_port` (Optional, default `60000`) - Health check port for HANA.

`sap_hana_instance_number` (Required) - HANA instance number.

`sap_hana_primary_instance_ip` (Required) - IP address of HANA primary instance.

`sap_hana_primary_instance_name` (Required) - Hostname of HANA primary instance.

`sap_hana_secondary_instance_name` (Required) - Hostname of HANA secondary instance.

`sap_hana_sid` (Required) - HANA system identifier.

`sap_hana_vip` (Required) - IP address of HANA load balancer.

# Example Usage

The following shows inclusion of the `pacemaker-hana` role in another task role.

```
- name: Include pacemaker install/config role
  include_role:
    name: pacemaker-hana
  vars:
    sap_cluster_user_password: abcxyz123
	sap_hana_instance_number: '00'
	sap_hana_primary_instance_ip: 10.10.10.10
	sap_hana_primary_instance_hana: hana-pri
	sap_hana_secondary_instance_ip: 10.10.10.11
	sap_hana_secondary_instance_name: hana-sec
	sap_hana_sid: ABC
	sap_hana_vip: 10.123.123.10
```

# Author Information

Joseph Wright <joseph.wright@googlecloud.corp-partner.google.com>
