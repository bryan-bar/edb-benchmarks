#!/bin/bash -eux

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $RUNDIR

# Expand any needed paths
RESULTS_DIRECTORY=$(realpath "$RESULTS_DIRECTORY")
TERRAFORM_PROJECT_PATH=$(realpath "${TERRAFORM_PROJECT_PATH}/${TERRAFORM_PROJECT_NAME}")

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
VARS_FILE=${RUNDIR}/../vars.yml
VARS_FILE=$(realpath "$VARS_FILE")

# Run the benchmark
ansible-playbook \
	-i ${TERRAFORM_PROJECT_PATH}/inventory.yml \
	-e "@$VARS_FILE" \
	-e "results_directory=${RESULTS_DIRECTORY}/dbt2-data" \
	./playbook-dbt2-run.yml

# Copy infrastructure.yml and vars.yml
cp ../infrastructure.yml "$RESULTS_DIRECTORY/dbt2-data"
cp ../vars.yml "$RESULTS_DIRECTORY/dbt2-data"

cd $ORIGINAL_DIR
