#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
TERRAFORM_PROJECT_NAME="terraform"
TERRAFORM_PROJECT_PATH="${SOURCEDIR}/../${TERRAFORM_PROJECT_NAME}"
RESULTS_DIRECTORY="${SOURCEDIR}/../results"

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_ARGS="-o ForwardX11=no -o UserKnownHostsFile=/dev/null"
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false

# Run the benchmark
ansible-playbook "${SOURCEDIR}/playbook-dbt2-run.yml" \
    -i "${TERRAFORM_PROJECT_PATH}/inventory.yml" \
    -e "@$SOURCEDIR/../environment.yml" \
    -e "@$SOURCEDIR/../vars.yml" \
    -e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
    -e "results_directory=${RESULTS_DIRECTORY}/dbt2-data"

# Copy infrastructure.yml and vars.yml
cp "${SOURCEDIR}/../infrastructure.yml" "$RESULTS_DIRECTORY/dbt2-data"
cp "${SOURCEDIR}/../vars.yml" "$RESULTS_DIRECTORY/dbt2-data"
