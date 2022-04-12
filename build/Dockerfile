FROM python:3.9-slim
ENV TF_VERSION=1.1.7
ENV CLOUD_SDK_VERSION=397.0.0
ENV PATH /usr/local/google-cloud-sdk/bin:$PATH
ENV WORKSPACE /workspace
ENV TF_PLUGIN_CACHE_DIR ${WORKSPACE}/test/integration/tmp/.terraform

RUN mkdir -p ${WORKSPACE}
RUN apt-get update
RUN apt-get install git curl gnupg zip unzip shellcheck jq vim -y

# Setup terraform
RUN curl https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip --output /tmp/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip  /tmp/terraform_${TF_VERSION}_linux_amd64.zip -d /tmp
RUN mv /tmp/terraform /usr/local/bin/terraform_${TF_VERSION}
RUN chmod a+x /usr/local/bin/terraform_${TF_VERSION}
# Version 0.12.29 is necessary for forminator to work
RUN curl https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip --output /tmp/terraform_0.12.29_linux_amd64.zip
RUN unzip  /tmp/terraform_0.12.29_linux_amd64.zip -d /tmp
RUN mv /tmp/terraform /usr/local/bin/terraform
RUN chmod a+x /usr/local/bin/terraform
# Set TF cache dir
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}

# Setup gcloud
RUN mkdir -p build
COPY build/scripts/install_cloud_sdk.sh /build/
RUN chmod a+x  /build/install_cloud_sdk.sh
RUN /build/install_cloud_sdk.sh ${CLOUD_SDK_VERSION}

# Setup ansible
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm -rf /tmp/requirements.txt

# Setup ansible-lint
# ansible-lint can not run in the same environment with ansible due to coalision with ansible-core.
# This is a known issue
RUN pip install virtualenv
RUN virtualenv /root/lint
RUN /root/lint/bin/pip install ansible-lint flake8
RUN /root/lint/bin/ansible-galaxy collection install community.general
RUN /root/lint/bin/ansible-galaxy collection install google.cloud

COPY build/scripts/task_helper_functions.sh /usr/local/bin/task_helper_functions.sh
COPY build/scripts/terraform_validate /usr/local/bin/terraform_validate
COPY build/scripts/.bashrc /root/.bashrc
COPY build/scripts/test_lint.sh /usr/local/bin/test_lint.sh
RUN chmod a+x /usr/local/bin/terraform_validate
RUN chmod a+x /usr/local/bin/test_lint.sh

WORKDIR ${WORKSPACE}
CMD ["/bin/bash"]