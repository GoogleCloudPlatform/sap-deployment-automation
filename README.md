# sap-awx-image

This repository uses Packer to build a GCE image for AWX.

## Requirements

Packer and Python 3 should be installed and on the PATH. This was tested with Packer v1.6.0.

GCP credentials must be in scope, by running on a machine with a service account or by setting the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the credentials file.

## Usage

```
packer build \
  -var project-id=project-xyz \
  -var subnetwork=subnet-01 \
  -var image-version=v4 \
  -var awx-version=13.0.0 \
  build.json
```
