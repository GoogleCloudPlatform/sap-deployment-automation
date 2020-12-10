# pacemaker-hana

This is a role for configuring [Pacemaker](https://clusterlabs.org/pacemaker/), whose tasks are intended to be included in other roles. See the tasks for the `pacemaker-hana` and `pacemaker-netweaver` roles for an example.

# Requirements

A RHEL or Suse instance.

# Role Variables

`sap_cluster_name` (Optional, default `hacluster`) - Logical name of cluster.

`sap_cluster_user` (Optional, default `hacluster`) - The local user created for Pacemaker.

`sap_cluster_user_password` (Required) - Password of `sap_cluster_user`.

`sap_ensa_version` (Optional, choice of `1` or `2`, default `2`) - Enqueue server version.

`sap_nw_ascs_health_check_port` (Optional, default `''`) - Health check port for ASCS. Required when ASCS has a load balancer.

`sap_nw_ascs_instance_number` (Required) - ASCS instance number.

`sap_nw_ascs_vip` (Required) - IP address of ASCS load balancer.

`sap_nw_ascs_virtual_host` (Required) - Hostname given to `sap_nw_ascs_vip`.

`sap_nw_ers_health_check_port` (Optional, default `''`) - Health check port for ERS. Required when ERS has a load balancer.

`sap_nw_ers_instance_number` (Required) - ERS instance number.

`sap_nw_ers_vip` (Required) - IP address of ERS load balancer (Suse) or alias IP (RHEL).

`sap_nw_ers_virtual_host` (Required) - Hostname given to `sap_nw_ers_vip`.

`sap_nw_sid` (Required) - NetWeaver system identifier.

# Example Usage

The following shows inclusion of the `pacemaker-netweaver` role in another task role.

```
- name: include pacemaker tasks
  include_role:
    name: pacemaker-netweaver
  vars:
    sap_cluster_user_password: abcxyz123
	sap_nw_ascs_health_check_port: '6666'
	sap_nw_ers_health_check_port: '6667'
	sap_nw_ascs_instance_number: '06'
	sap_nw_ers_instance_number: '16'
	sap_nw_ascs_vip: 10.100.123.123
	sap_nw_ers_vip: 10.100.123.124
	sap_nw_ascs_virtual_host: v-ascs
	sap_nw_ers_virtual_host: v-ers
```

# Author Information

Joseph Wright <joseph.wright@googlecloud.corp-partner.google.com>
