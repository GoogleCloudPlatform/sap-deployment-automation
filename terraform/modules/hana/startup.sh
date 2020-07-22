#!/bin/bash

# Install required packages
sudo yum install ansible -y
sudo yum install git -y
sudo yum install libatomic -y
sudo yum install python3 -y
sudo yum install unzip -y

# Create directory strcture to store the SAP files
sudo mkdir -p /software/SAPHOSTAGENT
sudo mkdir -p /software/HANA_installation
#sudo mkdir -p /software/SAPCAR

# Download SAP HANA install files
sudo gsutil cp gs://nw-ansible/saphostagentrpm_44-20009394.rpm /software/SAPHOSTAGENT/
#sudo gsutil cp gs://nw-ansible/IMDB_SERVER20_047_0-80002031.SAR /software/HANA_installation/
sudo gsutil cp gs://saphana2/rev40/51053787.ZIP /software/HANA_installation/
#sudo gsutil cp gs://nw-ansible/SAPCAR_1320-80000935.EXE /software/SAPCAR/

# Executable access to SAPCAR
#sudo chmod +x /software/SAPCAR/SAPCAR_1320-80000935.EXE
