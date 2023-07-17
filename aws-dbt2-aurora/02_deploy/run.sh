#!/bin/bash -eux

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $RUNDIR

# Expand any needed paths
RESULTS_DIRECTORY=$(realpath "$RESULTS_DIRECTORY")
TERRAFORM_PROJECT_PATH=$(realpath "${TERRAFORM_PROJECT_PATH}/${TERRAFORM_PROJECT_NAME}")
VARS_FILE=$(realpath "$VARS_FILE")

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false

ansible-playbook \
	-i ${TERRAFORM_PROJECT_PATH}/inventory.yml \
	-e "@$VARS_FILE" \
	./playbook-deploy.yml

cd $ORIGINAL_DIR
