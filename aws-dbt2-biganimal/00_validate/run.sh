#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
TERRAFORM_PROJECT_NAME="terraform"
TERRAFORM_PROJECT_PATH="${SOURCEDIR}/../${TERRAFORM_PROJECT_NAME}"
TERRAFORM_PLAN_FILENAME="terraform.plan"
RESULTS_DIRECTORY="${SOURCEDIR}/../results"

ansible-playbook "${SOURCEDIR}/run.yml" \
    -e "vars_file=${SOURCEDIR}/../environment.yml" \
    -e "env_file=${SOURCEDIR}/../environment.sh"
