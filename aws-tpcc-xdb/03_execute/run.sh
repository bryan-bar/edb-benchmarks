#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
TERRAFORM_PROJECT_PATH="../terraform"

# Run the ramping up benchmark
ansible-playbook \
	-u ${SSH_USER} \
	--private-key ${TERRAFORM_PROJECT_PATH}/ssh-id_rsa \
	-i ${SCRIPT_DIR}/../inventory.yml \
	-e "@${SCRIPT_DIR}/../vars.yml" \
	-e "TPCC_WAREHOUSE=${TPCC_WAREHOUSE}" \
	-e "TPCC_DURATION=${TPCC_DURATION}" \
	-e "TPCC_RAMPUP=${TPCC_RAMPUP}" \
	-e "TPCC_MIN_VUSERS=${TPCC_MIN_VUSERS}" \
	-e "TPCC_MAX_VUSERS=${TPCC_MAX_VUSERS}" \
	-e "TPCC_STEP_VUSERS=${TPCC_STEP_VUSERS}" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	-e "results_directory=${RESULTS_DIRECTORY}/report-data" \
	${SCRIPT_DIR}/playbook-tpcc-run-rampup.yml

# Copy infrastructure.yml and vars.yml
cp "../infrastructure.yml" "$RESULTS_DIRECTORY"
cp "../vars.yml" "$RESULTS_DIRECTORY"
