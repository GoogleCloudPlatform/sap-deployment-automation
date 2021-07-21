# Web Dispatcher-Standard

This stack builds a Web Dispatcher .

# Deployment Architecture

![Web Dispatcher-Standard](./images/wd-standard.png)

# Requirements

Python 3 is required.

# Usage

See the README at the root of the repository for instructions common to all stacks.

# General Remarks

Web Dispatcher version 7.77 (latest SP) should be used with RHEL 7.7 and SuSe 12. There might be some package inconsistencies with WD 7.81. I used SAPWEBDISP_SP_341-80004425.SAR
Together with SAP Web Dispatcher SAR file, you should provide a SAP Host Agent SAR file  (ie SAPHOSTAGENT51_51-20009394.SAR) should be uploaded to a GCS bucket.
Also, SWPM2.0 will be used for the installation. 
Example GCS bucket structure & contents:

gs://<bucket-name>/WebDispatcher/750/WEBDISP/SAPHOSTAGENT51_51-20009394.SAR
gs://<bucket-name>/WebDispatcher/750/WEBDISP/SAPWEBDISP_SP_341-80004425.SAR
gs://<bucket-name>/WebDispatcher/750/SWPM2.0 -> UNPACKED SWPM, NOT SAR!

## Deploying the stack

Copy stacks/WebDisp/vars/deploy-vars.yml and populate it with the variables as described below.

From the root of the repository, run:

```
./ansible-wrapper stacks/WebDisp/playbook.yml -e @vars.yml
```

## Destroying the stack

Use the same command as for deploying, but add the `state: absent` variable:

```
./ansible-wrapper stacks/WebDisp/playbook.yml -e @vars.yml -e state=absent
```

# Variables

`sap_wd_instance_type`: (Optional, default `n1-standard-2`) - The GCE instance type for Web Dispatcher or S4HANA instances.

`sap_wd_install_files_bucket`: (Required) - Bucket where Web Dispatcher or S4HANA installation files are located.

`sap_wd_instance_name`: (Required) - Name of application instance.

`sap_wd_password`: (Required) - The password for Web Dispatcher or S4HANA.

`sap_wd_product_version`: (Optional, default `750`) - The SAP product version. If `sap_wd_product` is `Web Dispatcher` it must be `750`.

`sap_wd_service_account_name`: (Optional, default `sap-common-sa`) - The name of the service account assigned to Web Dispatcher or S4HANA instances. This should not be a full service account email, just the name before the `@` symbol.

`sap_wd_sid`: (Required) - The System ID for Web Dispatcher or S4HANA. This is a three character uppercase string which may include digits but must start with a letter.

`sap_project_id`: (Required) - The project ID where instances are located.

`sap_source_image_family`: (Required) - The source image family for machines.

`sap_source_image_project`: (Required) - The project for the source image. Official SAP images are from `rhel-sap-cloud` for RedHat or `suse-sap-cloud` for Suse.

`sap_wd_subnetwork`: (Required) - The name of the subnetwork used for machines and load balancers.

`sap_subnetwork_project_id`: (Optional, default `''`) - The name of the subnetwork project, if using a shared VPC. If not given, `sap_project_id` will be used.

`sap_tf_state_bucket`: (Required) - The GCS bucket where Terraform state is stored. If it does not exist, it will be created. Note that the name must be unique, as there can only be one bucket with a given name (it gets a global DNS name). If there is a permissions error when creating this bucket, it is likely that one already exists in another project with the same name.

`sap_tf_state_bucket_prefix`: (Required) - This is the prefix for the Terraform state within the bucket defined in `sap_tf_state_bucket`. This should be unique for each instance of a stack, or there will be conflicts between resources. For example, if creating more than one `Web Dispatcher-HA` stack, give each one its own `sap_tf_state_bucket_prefix`.

`sap_zone`: (Required) - The zone where all resources are created.
