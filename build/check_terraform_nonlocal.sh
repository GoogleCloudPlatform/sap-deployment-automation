#!/bin/bash

# search "bad" Terraform files that reference non-local modules
# - output: file paths
# - exit status: 1 if any non-locals found, 0 otherwise

! egrep -r 'source.+git.+ssh' $(find . -name '*.tf')
