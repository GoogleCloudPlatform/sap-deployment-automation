#!/bin/sh

set -e

TF_VERSION=${TF_VERSION:-0.12.29}
ARCH=${ARCH:-amd64}

fail()
{
    printf "${1}\n"
    exit 1
}

usage()
{
    msg="Usage: ${0} -i <instance-name> -p <project-id> -s <subnetwork> [-y] [-d] [-h]\n"
    msg="${msg}    -i <instance-name>  Name given to AWX instance.\n"
    msg="${msg}    -p <project-id>     ID of GCP project.\n"
    msg="${msg}    -s <subnetwork>     Subnetwork in which AWX instance is created.\n"
    msg="${msg}    -y                  Answer yes to proceed to create or destroy resources.\n"
    msg="${msg}    -d                  Destroy an instance which was previously\n"
    msg="${msg}                        created with the same parameters.\n"
    msg="${msg}    -h                  Help message.\n"

    fail "${msg}"
}

retrieve_terraform()
{
    local os=`uname -s | tr [:upper:] [:lower:]`
    local tf_archive="terraform_${TF_VERSION}_${os}_${ARCH}.zip"
    local url="https://releases.hashicorp.com/terraform/${TF_VERSION}/${tf_archive}"
    curl -sLO ${url}
    rm -f ./terraform
    unzip -qq ${tf_archive} terraform
    rm -f ${tf_archive}
}

check_terraform_version()
{
    local tf_exec=${1}
    if "${tf_exec}" version | head -n 1 | grep -q "Terraform v${TF_VERSION}"; then
        echo "${tf_exec}"
        return
    fi
    return 1
}

find_existing_terraform()
{
    if [ -x ./terraform ]; then
        check_terraform_version ./terraform && return
    fi
    local tf_exec=`which terraform || true`
    if [ -n "${tf_exec}" ]; then
        check_terraform_version "${tf_exec}" && return
    fi
}

find_terraform()
{
    local tf_exec=`find_existing_terraform`
    if [ -n "${tf_exec}" ]; then
	echo "${tf_exec}"
	return
    fi
    retrieve_terraform
    echo ./terraform
}

run_terraform()
{
    local instance_name=${1}
    local project_id=${2}
    local subnetwork=${3}
    local proceed=${4}

    local tf_exec=`find_terraform`

    ${tf_exec} init
    ${tf_exec} plan -out plan.out \
        -var instance_name=${instance_name} \
        -var project_id=${project_id} \
        -var subnetwork=${subnetwork} ${destroy}

    if [ "${proceed}" != 1 ]; then
        printf "Please review any changes above. Do you wish to proceed? [yN] "
        read input

        proceed=0
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
        gcloud auth application-default login
    fi
    credentials=`find_credentials`
    if [ -z "${credentials}" ]; then
       echo >&2 "No GCP credentials found..."
       return 1
    fi
    export GOOGLE_APPLICATION_CREDENTIALS=${credentials}
}

while getopts "i:p:s:ydh" flag; do
    case ${flag} in
      i) instance_name=${OPTARG}
        ;;
      p) project_id=${OPTARG}
        ;;
      s) subnetwork=${OPTARG}
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

which curl 1>/dev/null    || fail "curl is required"
which gcloud 1>/dev/null  || fail "gcloud is required"
which unzip 1>/dev/null   || fail "unzip is required"

ensure_auth && run_terraform "${instance_name}" "${project_id}" "${subnetwork}" "${proceed}" "${destroy}"
