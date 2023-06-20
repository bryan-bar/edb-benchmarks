#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_ARGS="-o ForwardX11=no -o UserKnownHostsFile=/dev/null"
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false

# Run the benchmark
ansible-playbook \
	-u ${SSH_USER} \
	--private-key "${TERRAFORM_PROJECT_PATH}/ssh-id_rsa" \
	-i "${SCRIPT_DIR}/../inventory.yml" \
	-e "@${SCRIPT_DIR}/../vars.yml" \
	-e "dbt2_duration=${DBT2_DURATION}" \
	-e "dbt2_warehouse=${DBT2_WAREHOUSE}" \
	-e "dbt2_connections=${DBT2_CONNECTIONS}" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	"${SCRIPT_DIR}/playbook-dbt2-run.yml"

# Move data to results directory
[[ ! -d "$RESULTS_DIRECTORY/dbt2-data" ]] && mkdir -p "$RESULTS_DIRECTORY/dbt2-data"
# Extract the archive containing the report and data
tar xzf "${SCRIPT_DIR}/tuner-off/tuner-off.tar.gz" -C "${SCRIPT_DIR}"
tar xzf "${SCRIPT_DIR}/tuner-measurement/tuner-measurement.tar.gz" -C "${SCRIPT_DIR}"
tar xzf "${SCRIPT_DIR}/tuner-final/tuner-final.tar.gz" -C "${SCRIPT_DIR}"
mv "${SCRIPT_DIR}/tmp/tuner-off" "${RESULTS_DIRECTORY}/dbt2-data/"
mv "${SCRIPT_DIR}/tmp/tuner-measurement" "${RESULTS_DIRECTORY}/dbt2-data/"
mv "${SCRIPT_DIR}/tmp/tuner-final" "${RESULTS_DIRECTORY}/dbt2-data/"
rm -rf "${SCRIPT_DIR}/tmp"
# Copy infrastructure.yml and vars.yml
cp "${SCRIPT_DIR}/../infrastructure.yml" "${SCRIPT_DIR}/dbt2-data/"
cp "${SCRIPT_DIR}/../vars.yml" "${RESULTS_DIRECTORY}/dbt2-data/"
