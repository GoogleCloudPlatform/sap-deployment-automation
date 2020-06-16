#!/bin/bash

sudo yum install ansible -y
sudo yum install git -y
sudo yum install tree -y
sudo yum install libatomic -y
sudo yum install python3 -y
sudo alias python=/usr/bin/python3

sudo mkdir -p /software/SAPHOSTAGENT
sudo mkdir -p /software/HANA_installation
sudo mkdir -p /software/SAPCAR

sudo gsutil cp gs://nw-ansible/saphostagentrpm_44-20009394.rpm /software/SAPHOSTAGENT/
sudo gsutil cp gs://nw-ansible/IMDB_SERVER20_047_0-80002031.SAR /software/HANA_installation/
sudo gsutil cp gs://nw-ansible/SAPCAR_1320-80000935.EXE /software/SAPCAR/

sudo chmod +x /software/SAPCAR/SAPCAR_1320-80000935.EXE
