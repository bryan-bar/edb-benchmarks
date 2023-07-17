#!/bin/bash -eux

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $SCRIPT_DIR

# Expand any needed paths
TERRAFORM_PROJECT_PATH=$(realpath "${TERRAFORM_PROJECT_PATH}/${TERRAFORM_PROJECT_NAME}")

# Destory resources
cd $TERRAFORM_PROJECT_PATH
terraform destroy -auto-approve

cd $ORIGINAL_DIR
