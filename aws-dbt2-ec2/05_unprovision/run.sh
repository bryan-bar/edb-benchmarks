#!/bin/bash -eux

# We need the absolute path of $TERRAFORM_PROJECT_PATH in this script.
TERRAFORM_PROJECT_PATH=$(realpath "${TERRAFORM_PROJECT_PATH}")

cd "${TERRAFORM_PROJECT_PATH}"
terraform destroy -auto-approve
