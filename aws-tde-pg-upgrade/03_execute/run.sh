#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"

# Run the pg_upgrade benchmark with TDE and without TDE
ansible-playbook \
	-u ${SSH_USER} \
	--private-key ${TERRAFORM_PROJECT_PATH}/ssh-id_rsa \
	-i ${SCRIPT_DIR}/../inventory.yml \
	-e "@${SCRIPT_DIR}/../vars.yml" \
	-e "results_directory=${RESULTS_DIRECTORY}/report-data" \
	${SCRIPT_DIR}/playbook-pg-upgrade-timing.yml

# Copy infrastructure.yml and vars.yml
cp "../infrastructure.yml" "$RESULTS_DIRECTORY"
cp "../vars.yml" "$RESULTS_DIRECTORY"
