#!/bin/bash -eux

export ANSIBLE_PIPELINING=true
export ANSIBLE_SSH_PIPELINING=true
export ANSIBLE_HOST_KEY_CHECKING=false
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"

# Run the benchmark
ansible-playbook \
	-u ${SSH_USER} \
	--private-key ${TERRAFORM_PROJECT_PATH}/ssh-id_rsa \
	-i ../inventory.yml \
	-e "@../vars.yml" \
	-e "dbt2_duration=${DBT2_DURATION}" \
	-e "dbt2_warehouse=${DBT2_WAREHOUSE}" \
	-e "dbt2_connections=${DBT2_CONNECTIONS}" \
	-e "terraform_project_path=${TERRAFORM_PROJECT_PATH}" \
	./playbook-dbt2-run.yml

# Move data to results directory
[[ ! -d "$RESULTS_DIRECTORY/dbt2-data" ]] && mkdir -p "$RESULTS_DIRECTORY/dbt2-data"
mv ./dbt2_data/* "$RESULTS_DIRECTORY/dbt2-data"
# Extract the archive containing the report and data
tar xzf "$RESULTS_DIRECTORY/dbt2-data/dbt2-data.tar.gz" -C .
mv ./tmp/dbt2-data/* "$RESULTS_DIRECTORY/dbt2-data"
rm -rf ./tmp
# Copy infrastructure.yml and vars.yml
cp ../infrastructure.yml "$RESULTS_DIRECTORY/dbt2-data"
cp ../vars.yml "$RESULTS_DIRECTORY/dbt2-data"
