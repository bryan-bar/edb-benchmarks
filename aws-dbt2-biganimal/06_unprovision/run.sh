#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
TERRAFORM_PROJECT_NAME="terraform"
TERRAFORM_PROJECT_PATH="${SOURCEDIR}/../${TERRAFORM_PROJECT_NAME}"

cd ${TERRAFORM_PROJECT_PATH}
terraform destroy -auto-approve
