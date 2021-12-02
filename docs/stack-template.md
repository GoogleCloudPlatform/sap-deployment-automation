# Stack Name

# Architecture Diagram

![Stack-Name](./images/stack-name.png)

# Prerequisites

## Inventory

Required inventory variables if not using Terraform.

INI format:

```ini
# Note: boolean values must begin with uppercase when using the
# INI formatted inventory or Ansible will treat them as strings.

[hana]
10.150.0.49 sap_hana_is_primary=False
10.150.0.50 sap_hana_is_primary=True

[sap]
10.150.0.46 sap_is_ascs=True sap_is_scs=True
10.150.0.40 sap_is_ers=True sap_is_scs=True
10.150.0.44 sap_is_pas=True
10.150.0.48 sap_is_aas=True
```

YAML format:

```yaml
all:
  children:
    hana:
      hosts:
        10.150.0.49:
          sap_hana_is_primary: false
        10.150.0.50:
          sap_hana_is_primary: true
    sap:
      hosts:
        10.150.0.46:
          sap_is_ascs: true
          sap_is_scs: true
        10.150.0.40:
          sap_is_ers: true
          sap_is_scs: true
        10.150.0.44:
          sap_is_pas: true
        10.150.0.48:
          sap_is_aas: true
```

## Install Media

See [the instructions](../install-media.md) for uploading install media to your bucket.

# Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `variable_name` | Variable description. | `string` | n/a | yes |
