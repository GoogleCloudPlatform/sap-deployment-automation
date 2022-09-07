# Copyright 2019 Google LLC
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

# Please note that this file was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template).
# Please make sure to contribute relevant changes upstream!

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

DOCKER_IMAGE_DEVELOPER_TOOLS := us-docker.pkg.dev/sap-iac-cicd/cicd/developer-tools
DOCKER_TAG_VERSION_DEVELOPER_TOOLS := 0.3
DOCKER_BIN ?= docker

# Build docker container for local development
.PHONY: docker_build
docker_build:
	$(DOCKER_BIN) build -t ${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} -f build/Dockerfile .

# Enter docker container for local development
.PHONY: docker_run
docker_run:
	$(DOCKER_BIN) run --rm -it \
		-v "$(CURDIR)":/workspace \
		${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/bin/bash

# Run lint
.PHONY: docker_lint
docker_lint:
	$(DOCKER_BIN) run --rm -it \
		-v "$(CURDIR)":/workspace \
		${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/test_lint.sh

# Run cloud build locally. This is meant only for local testing of the cloud-build configuration
.PHONY: cbl_lint
cbl_lint:
	cloud-build-local --config=build/lint.cloudbuild.yaml --dryrun=false  .
