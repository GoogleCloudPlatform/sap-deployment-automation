#!/bin/bash

set -e
set -x

# Create directory strcture to store the SAP files
sudo mkdir -p /software/

# Download SAP HANA install files
sudo gsutil cp gs://${sap_install_files_bucket}/${sap_hostagent_rpm_file_name} /software/
sudo gsutil cp gs://${sap_install_files_bucket}/${sap_hana_bundle_file_name} /software/
sudo gsutil cp gs://${sap_install_files_bucket}/${sap_hana_sapcar_file_name} /software/