#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

TF_VERSION=${TF_VERSION:-0.13.5}
ARCH=${ARCH:-amd64}

fail()
{
    printf >&2 "${1}\n"
    exit 1
}

warn()
{
    printf >&2 "${1}\n"
    return 1
}

usage()
{
    msg="Usage: ${0} -i <instance-name> -p <project-id> -s <subnetwork> [-P <subnetwork-project-id>] [-r <region>] [-c stable|unstable] [-n] [-y] [-d] [-h]\n"
    msg="${msg}    -i <instance-name>         (Required) Name given to AWX instance.\n"
    msg="${msg}    -p <project-id>            (Required) ID of GCP project.\n"
    msg="${msg}    -s <subnetwork>            (Required) Subnetwork in which AWX instance is created.\n"
    msg="${msg}    -P <subnetwork-project-id> (Optional) ID of subnetwork project, if using a shared VPC.\n"
    msg="${msg}    -r <region>                (Optional) GCP region, defaults to us-central1.\n"
    msg="${msg}    -c <channel>               (Optional) Channel for AWX image, must be one of 'stable' (default) or 'unstable'.\n"
    msg="${msg}    -n                         (Optional) Add a Cloud NAT instance for the subnet, defaults to false.\n"
    msg="${msg}    -y                         (Optional) Answer yes to proceed to create or destroy resources.\n"
    msg="${msg}    -d                         (Optional) Destroy an instance which was previously\n"
    msg="${msg}                                          created with the same parameters.\n"
    msg="${msg}    -h                         (Optional) Help message.\n"

    fail "${msg}"
}

retrieve_terraform()
{
    local os=`uname -s | tr [:upper:] [:lower:]`
    local tf_archive="terraform_${TF_VERSION}_${os}_${ARCH}.zip"
    local url="https://releases.hashicorp.com/terraform/${TF_VERSION}/${tf_archive}"

    echo >&2 "Downloading Terraform archive ${tf_archive}..."
    curl -sLOf ${url} || fail "Failed to download Terraform archive ${tf_archive}..."

    echo >&2 "Extracting ${tf_archive} to ./terraform..."
    rm -f ./terraform
    unzip -qq ${tf_archive} terraform || fail "Failed to extract ${tf_archive}..."
    rm -f ${tf_archive}
}

check_terraform_version()
{
    local tf_exec=${1}
    local tf_version=`${tf_exec} version | head -n 1`
    if [ "${tf_version}" = "Terraform v${TF_VERSION}" ]; then
	echo >&2 "Terraform executable ${tf_exec} version matches v${TF_VERSION}..."
        echo "${tf_exec}"
        return
    fi
    warn "Terraform executable ${tf_exec} has version ${tf_version}, wanted v${TF_VERSION}..."
}

find_terraform()
{
    if [ -x ./terraform ]; then
        check_terraform_version ./terraform && return
    fi
    local tf_exec=`which terraform || true`
    if [ -n "${tf_exec}" ]; then
        check_terraform_version "${tf_exec}" && return
    fi
}

run_terraform()
{
    local instance_name=${1}
    local image_family=${2}
    local project_id=${3}
    local subnetwork=${4}
    local subnetwork_project_id=${5}
    local region=${6}
    local nat_create=${7}
    local proceed=${8}
    local destroy=${9}

    local tf_exec=`find_terraform`
    if [ -z "${tf_exec}" ]; then
	retrieve_terraform
	tf_exec=./terraform
    fi

    ${tf_exec} init
    ${tf_exec} plan -out plan.out \
        -var instance_name="${instance_name}" \
        -var source_image_family="${image_family}" \
        -var project_id="${project_id}" \
        -var subnetwork="${subnetwork}" \
        -var subnetwork_project_id="${subnetwork_project_id}" \
        -var region="${region}" \
        -var nat_create="${nat_create}" \
        ${destroy}

    if [ "${proceed}" != 1 ]; then
        printf "Please review any changes above. Do you want to continue (y/N)?  "
        read input
        echo "${input}" | grep -qE '[Yy]([Ee][Ss])?' && proceed=1
    fi

    if [ "${proceed}" = 1 ]; then
        ${tf_exec} apply plan.out
    else
        echo "No changes will be made, exiting."
    fi
}

find_credentials()
{
    local credentials_file=application_default_credentials.json
    for directory in "${HOME}/.config/gcloud" "${CLOUDSDK_CONFIG}"; do
        if [ -r "${directory}/${credentials_file}" ]; then
            echo "${directory}/${credentials_file}"
            return
        fi
    done
}

ensure_auth()
{
    local credentials=`find_credentials`
    if [ -z "${credentials}" ]; then
        echo >&2 "Retrieving GCP credentials..."
        gcloud --quiet auth application-default login
    fi
    credentials=`find_credentials`
    if [ -z "${credentials}" ]; then
       echo >&2 "No GCP credentials found..."
       return 1
    fi
    export GOOGLE_APPLICATION_CREDENTIALS=${credentials}
}

while getopts "i:p:s:P:r:c:nydh" flag; do
    case ${flag} in
      i) instance_name=${OPTARG}
        ;;
      p) project_id=${OPTARG}
        ;;
      s) subnetwork=${OPTARG}
        ;;
      P) subnetwork_project_id=${OPTARG}
        ;;
      r) region=${OPTARG}
        ;;
      c) channel=${OPTARG}
        ;;
      n) nat_create=true
        ;;
      y) proceed=1
        ;;
      d) destroy="-destroy"
        ;;
      ?) usage
        ;;
    esac
done

[ -n "${instance_name}" ] || usage
[ -n "${project_id}" ]    || usage
[ -n "${subnetwork}" ]    || usage
[ -n "${region}" ]        || region="us-central1"
[ -n "${channel}" ]       || channel=stable
[ -n "${nat_create}" ]    || nat_create=false

if [ "${channel}" = "stable" ]; then
    image_family="sap-awx"
elif [ "${channel}" = "unstable" ]; then
    image_family="sap-awx-unstable"
else
    fail "The AWX image channel must be one of 'stable' or 'unstable'."
fi

which curl 1>/dev/null    || fail "curl is required"
which gcloud 1>/dev/null  || fail "gcloud is required"
which unzip 1>/dev/null   || fail "unzip is required"

ensure_auth && run_terraform \
    "${instance_name}" \
    "${image_family}" \
    "${project_id}" \
    "${subnetwork}" \
    "${subnetwork_project_id}" \
    "${region}" \
    "${nat_create}" \
    "${proceed}" \
    "${destroy}"
