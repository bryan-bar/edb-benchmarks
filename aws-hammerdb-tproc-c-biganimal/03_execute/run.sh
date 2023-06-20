#!/bin/bash -eux

SSH_USER=rocky
export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false

# Run the benchmark
ansible-playbook \
	-u ${SSH_USER} \
	--become-user ${SSH_USER} \
	--private-key "${TERRAFORM_PROJECT_PATH}/ssh-id_rsa" \
	-i ../inventory.yml \
	-e "@../vars.yml" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	./playbook-tprocc-run.yml

# Move data to results directory
[[ ! -d "$RESULTS_DIRECTORY/tprocc-data" ]] && mkdir -p "$RESULTS_DIRECTORY/tprocc-data"
# Copy hammerdb log file
cp -pr "./hammerdb.log" "$RESULTS_DIRECTORY/tprocc-data"
# Copy infrastructure.yml and vars.yml
cp "../infrastructure.yml" "$RESULTS_DIRECTORY/tprocc-data"
cp "../vars.yml" "$RESULTS_DIRECTORY/tprocc-data"
