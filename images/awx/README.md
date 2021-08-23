# SAP AWX Image

This uses Packer to build a GCE image for AWX containing job templates for SAP stacks.

## Requirements

Packer and Python 3 should be installed and on the PATH. This was tested with Packer v1.6.0.

GCP credentials must be in scope, by running on a machine with a service account or by setting the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the credentials file.

## Usage

```
packer build \
  -var project-id=project-xyz \
  -var subnetwork=subnet-01 \
  -var image-version=v4 \
  build.json
```

The following variables are required. See `build.json` for optional variables.

`image-version`: The version number that will be appended to the image name.

`project-id`: The ID of the project in which the temporary instance will be created.

`subnetwork`: The subnet in which the temporary instance will be created.

## Updating the AWX version

AWX is vendored in the `sap-deployment-automation` repo in `third_party/github.com/ansible/awx`. This is done by running:

```
cd third_party/github.com/ansible
git clone --depth 1 --branch 14.1.0 https://github.com/ansible/awx
```

To change the version of AWX, remove the vendored `awx` directory and rerun the command with a new version in the `branch` argument.
