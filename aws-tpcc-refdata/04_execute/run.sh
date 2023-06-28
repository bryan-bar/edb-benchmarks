#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"

# Run the benchmark with refdata enabled and disabled
ansible-playbook \
	-u ${SSH_USER} \
	--private-key ${TERRAFORM_PROJECT_PATH}/ssh-id_rsa \
	-i ${SCRIPT_DIR}/../inventory.yml \
	-e "@${SCRIPT_DIR}/../vars.yml" \
	-e "tpcc_duration=${TPCC_DURATION}" \
	-e "tpcc_rampup=${TPCC_RAMPUP}" \
	-e "tpcc_warehouse=${TPCC_WAREHOUSE}" \
	-e "tpcc_vusers=${TPCC_VUSERS}" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	-e "results_directory=${RESULTS_DIRECTORY}/report-data" \
	${SCRIPT_DIR}/playbook-tpcc-run.yml

# Copy infrastructure.yml and vars.yml
cp "../infrastructure.yml" "$RESULTS_DIRECTORY"
cp "../vars.yml" "$RESULTS_DIRECTORY"
