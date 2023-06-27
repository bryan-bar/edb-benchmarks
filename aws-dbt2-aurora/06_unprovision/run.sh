#!/bin/bash -eux

TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"
cd "${TERRAFORM_PROJECT_PATH}"
terraform destroy -auto-approve
