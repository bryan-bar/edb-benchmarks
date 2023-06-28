#!/bin/bash -eux

SSH_USER=rocky
export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"

# Run the benchmark
ansible-playbook \
	-u ${SSH_USER} \
	--become-user ${SSH_USER} \
	--private-key "${TERRAFORM_PROJECT_PATH}/ssh-id_rsa" \
	-i ../inventory.yml \
	-e "@../vars.yml" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	-e "results_directory=${RESULTS_DIRECTORY}/tprocc-data" \
	./playbook-tprocc-run.yml

# Copy infrastructure.yml and vars.yml
cp "../infrastructure.yml" "$RESULTS_DIRECTORY/tprocc-data"
cp "../vars.yml" "$RESULTS_DIRECTORY/tprocc-data"
