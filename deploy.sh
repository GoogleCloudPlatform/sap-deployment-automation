#!/bin/bash

set -e
set -x

# set up the infrastructure and install sap hana
cd infra/
terraform init
terraform apply -auto-approve

echo "SAP Hana Deployment Success!"

terraform output