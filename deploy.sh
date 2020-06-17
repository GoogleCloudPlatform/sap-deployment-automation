#!/bin/bash

set -e
set -x

# set up the infrastructure
cd infra/
terraform init
terraform apply -auto-approve

# pull the instance information from Terraform, and run the Ansible playbook against it to configure
cd modules/ansible/plays/

# download ansible roles
ansible-galaxy install -r requirements.yml -p roles --force

# adding sleep statement to wait for system to become online.
# TODO: Add healthcheck
sleep 2m

ansible-playbook -i inventory sap-hana-deploy.yml --extra-vars "@../vars/sap_hosts.yml"

echo "SAP Hana Deployment Success!"

cd ../../../ && terraform output