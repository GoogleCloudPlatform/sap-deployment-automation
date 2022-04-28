# HANA-HA integration tests
The integration tests for HANA-HA are based of the support matrix defined in [support-matrix](../../../docs/support-matrix.md)

## Generating tests
All tests and test configuration are created from the [test-matrix](test-matrix.json) and the test config templates.

To generate all the tests run:
```shell
python test-matrix-boilerplate.py
```

To add more tests based on the support matrix edit the [test-matrix.json](test-matrix.json) file and rerun the above
command.

### Templates
The following files are important templates used to generate tests:
* [playbook.yml.tmpl](playbook.yml.tmpl)
  * This is an integration test playbook. If you need to modify test inputs do that in this file. Playbooks generated
    are in named `<PRODUCT_ID>-<OS IMAGE>.yml`
* [setups/main.tf.tmpl](setups/main.tf.tmpl)
  * This is terraform for test setup. It is used to create test setups for each test from test-matrix. Setups are
    created in [setups](setups) directory
* [tf/forminator_tf](tf/forminator_tf)
  * This directory holds the same files as [tf](../tf) for the stack. This is necessary to make forminator work with
    multiple tests running in parallel. Test case forminator terraform files are linked to the files in this directory.
* [cloudbuild.yml.tmpl](cloudbuild.yml.tmpl)
  * This template will generate [test-hana-ha.cloudbuild.yaml](test-hana-ha.cloudbuild.yaml). This is used to run tests
    in Google Cloud Build

### Running tests locally
1. Go to the root of this repo
2. `make docker_run`
3. `gcloud auth login`
4. `gcloud auth application-default login`
5. `export TF_VAR_org_id=<ORG ID>`
6. `export TF_VAR_folder_id=<FOLDER ID>`
7. `export TF_VAR_billing_account_id=<BILLING ACCOUNT ID>`
8. `export MEDIA_BUCKET=<SAP DEPLOYMENT MEDIA BUCKET>`
9. `ansible-playbook stacks/HANA-HA/tests/<PRODUCT_ID>-<OS-IMAGE>.yml`