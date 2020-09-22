#!/bin/bash

set -e
set -x

sudo mkdir -p /software

sudo /root/DIRECTORY/google-cloud-sdk/bin/gsutil cp gs://${sap_install_files_bucket}/${sap_hostagent_rpm_file_name} /software/
sudo /root/DIRECTORY/google-cloud-sdk/bin/gsutil cp gs://${sap_install_files_bucket}/${sap_hana_bundle_file_name} /software/
sudo /root/DIRECTORY/google-cloud-sdk/bin/gsutil cp gs://${sap_install_files_bucket}/${sap_hana_sapcar_file_name} /software/
