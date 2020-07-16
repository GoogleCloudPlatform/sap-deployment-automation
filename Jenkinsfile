pipeline {
    agent any

    environment {
        HOME = '/opt/bitnami/jenkins/jenkins_home'
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

                if [ ! -x packer ]; then
                    curl -LO https://releases.hashicorp.com/packer/${packer_version}/${packer_archive}
                    unzip ${packer_archive}
                fi

                ./packer build \
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
