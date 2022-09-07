# Testing
There are two types of testing:
1. Integration testing
2. Lint testing

## Integration testing
Integration tests test various deployments of a stack. Test are based of the [Support matrix](./support-matrix.md).
For now, we have implemented full integration tests only for the [HANA-HA stack](../stacks/HANA-HA/tests)

Other two stacks that have integration tests defined are:
1. HANA-Scaleup
2. NetWeaver-Standard

To manually run tests for two stacks from the above:
1. `make docker_run`
2. `gcloud auth login`
3. `gcloud auth application-default login`
4. `export TF_VAR_org_id=<ORG ID>`
5. `export TF_VAR_folder_id=<FOLDER ID>`
6. `export TF_VAR_billing_account_id=<BILLING ACCOUNT ID>`
7. `export MEDIA_BUCKET=<SAP DEPLOYMENT MEDIA BUCKET>`
8. `ansible-playbook stacks/<HANA-Scaleup | NetWeaver-Standard>/playbook-int-test.yml`

## Lint testing
Lint tests check for proper code syntax. We run the lint tests:
- ansilbe code linting via ansible-lint
- terraform code linting via terraform fmt and terraform validate
- python code linting via flake8
- shell code linting via shellcheck

To run the lint tests manually do the following at the root of this repo:
1. `make docker_run`
2. `/usr/local/bin/test_lint.sh`