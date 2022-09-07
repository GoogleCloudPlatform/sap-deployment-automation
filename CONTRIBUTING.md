# Contributing

Thanks for your interest in contributing to the SAP IAC repo!

To get started contributing:

1. Sign a Contributor License Agreement (see details below).
1. Fork the repo, develop and test your code changes.
1. Ensure that your code adheres to the existing style.
1. Submit a pull request.

## Contributor License Agreement

Contributions to this project must be accompanied by a Contributor License
Agreement. You (or your employer) retain the copyright to your contribution;
this simply gives us permission to use and redistribute your contributions as
part of the project. Head over to <https://cla.developers.google.com/> to see
your current agreements on file or to sign a new one.

You generally only need to submit a CLA once, so if you've already submitted one
(even if it was for a different project), you probably don't need to do it
again.

## Code reviews

All submissions, including submissions by project members, require review. We
use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/articles/about-pull-requests/) for more
information on using pull requests.

## Testing
Testing can be done through `sap-gcp-developer-tools` container. To build this
container run `make docker_build`.<br>
The `sap-gcp-developer-tools` container comes with the following tools:
following tools:
- ansible-core
- ansible-lint
- galaxy
- terraform
- gcloud
- shellcheck

More details can be found in [Dockerfile](build/Dockerfile)

### Interactive Execution
Run `make docker_run` to start the testing Docker container in interactive mode.

### Linting and Formatting
Many of the files in the repository can be linted or formatted to
maintain a standard of quality.

Run `make docker_test_lint`.
Linting will verify:
- ansible files using `ansible-lint`
- terraform files using `terraform fmt` and `terraform validate`
- shell files using `shellcheck`
- python files using `flake8`
- License header

#### Running lint on local cloud-build
You can also test the cloud-build configuration locally by running:<br>
`make cbl_lint`


