#!/bin/bash -eux

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
export TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"

python3 ./build-inventory.py ${TERRAFORM_PROJECT_PATH}
mv inventory.yml ../.

ansible-playbook \
	-u ${SSH_USER} \
	--private-key ${TERRAFORM_PROJECT_PATH}/ssh-id_rsa \
	-i ../inventory.yml \
	-e "@../vars.yml" \
	./playbook-deploy.yml
