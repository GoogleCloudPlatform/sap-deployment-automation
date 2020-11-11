# Ansible Role Development with Molecule

## Setup: Install Molecule and dependent tools

    pip install 'molecule[docker]' ansible-lint

## Lint to check syntax

This is quite fast, checking Ansible scripts and dependencies for minor errors.

    molecule lint

### Automatically lint when any file changes

This gives a very fast feedback loop.

    TBD more here -- git ls-files | entr -c molecule lint

## Deploy role to testing Hana instance

TBD more here

    molecule converge

