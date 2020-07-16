pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('terraform-managed-sa')
    }
    stages {
        stage('Build image') {
            steps {
                sh '''
                packer_version=1.6.0
                packer_archive=packer_${packer_version}_linux_amd64.zip
                project_id=albatross-duncanl-sandbox-2
                subnetwork=app2

                export PACKER_TMP_DIR=`mktemp -d`
                export PACKER_CACHE_DIR=`mktemp -d`
                export CHECKPOINT_DISABLE=1
                export PACKER_CONFIG=${PACKER_TMP_DIR}/.packerconfig
                trap "rm -rf ${PACKER_TMP_DIR} ${PACKER_CACHE_DIR}" 0

                if [ ! -x packer ]; then
                    curl -LO https://releases.hashicorp.com/packer/${packer_version}/${packer_archive}
                    unzip ${packer_archive}
                fi

                PACKER_LOG=1 ./packer build \
                  -var project-id=${project_id} \
                  -var subnetwork=${subnetwork} \
                  -var image-version=v5 \
                  -var awx-version=13.0.0 \
                  build.json
                '''
            }
        }
    }
}
