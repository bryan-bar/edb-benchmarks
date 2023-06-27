#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"
TERRAFORM_PLAN_FILENAME="terraform.plan"

# edb-terraform saves a backup of infrastructure.yml in <project-name>/infrastructure.yml.bak
#   this also includes the edb-terraform version used to generate the files
edb-terraform generate --project-name ${TERRAFORM_PROJECT_NAME} \
                       --work-path ${RESULTS_DIRECTORY} \
                       --infra-file ../infrastructure.yml \
                       --cloud-service-provider aws
cd "${TERRAFORM_PROJECT_PATH}"

# .terraform.lock.hcl will be saved here by terraform to lock provider versions and can be reused
terraform init

# Save terraform plan for inspection/reuse
terraform plan -out="$TERRAFORM_PLAN_FILENAME"

# terraform.tfstate/.tfstate.backup will be left around since we use short-term credentials
terraform apply -auto-approve "$TERRAFORM_PLAN_FILENAME"
