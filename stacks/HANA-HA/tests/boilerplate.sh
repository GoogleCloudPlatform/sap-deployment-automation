#!/bin/bash

mkdir -p setups/$1
mkdir -p tf/$1
cp setups/20SPS03-sles-12-sp4-sap/main.tf setups/$1/
cp tf/20SPS03-sles-12-sp4-sap/* tf/$1/
cp 20SPS03-sles-12-sp4-sap.yml $1.yml

