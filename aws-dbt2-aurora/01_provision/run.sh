#!/bin/bash -eux

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $RUNDIR

# Expand any needed paths
RESULTS_DIRECTORY=$(realpath "$RESULTS_DIRECTORY")
TERRAFORM_PROJECT_PATH=$(realpath "$TERRAFORM_PROJECT_PATH")
VARS_FILE=$(realpath "$VARS_FILE")

# Hardcode the template or setup a jinja template to allow for more input options
INFRASTRUCTURE_TEMPLATE=$RUNDIR/templates/infrastructure.yml.j2
INFRASTRUCTURE_FILE=$RUNDIR/../infrastructure.yml

PLAYBOOK=${RUNDIR}/run.yml
ansible-playbook $PLAYBOOK \
      -e "template_file=$INFRASTRUCTURE_TEMPLATE" \
      -e "dest_file=$INFRASTRUCTURE_FILE" \
      -e "@$VARS_FILE"

# edb-terraform saves a backup of infrastructure.yml in <project-name>/infrastructure.yml.bak
#   this also includes the edb-terraform version used to generate the files
INVENTORY_TEMPLATE=$RUNDIR/templates/inventory.yml.tftpl
CLOUD_PROVIDER=aws
edb-terraform generate --project-name ${TERRAFORM_PROJECT_NAME} \
                       --work-path ${TERRAFORM_PROJECT_PATH} \
                       --infra-file ${INFRASTRUCTURE_FILE} \
                       --user-templates ${INVENTORY_TEMPLATE} \
                       --cloud-service-provider ${CLOUD_PROVIDER}

cd "${TERRAFORM_PROJECT_PATH}/${TERRAFORM_PROJECT_NAME}"

# .terraform.lock.hcl will be saved here by terraform to lock provider versions and can be reused
terraform init

# Save terraform plan for inspection/reuse
terraform plan -out="$TERRAFORM_PLAN_FILENAME"

# terraform.tfstate/.tfstate.backup will be left around since we use short-term credentials
terraform apply -auto-approve "$TERRAFORM_PLAN_FILENAME"

# copy files into results directory
mkdir -p "${RESULTS_DIRECTORY}"
# .tfstate might contain secrets
# ssh short term keys currently used
# .terraform created at run-time and controlled by terraform CLI 
rsync --archive \
      --exclude="*tfstate*" \
      --exclude="*ssh*" \
      --exclude=".terraform/" \
      --recursive \
      ./ \
      "$RESULTS_DIRECTORY/terraform"

cd "$ORIGINAL_DIR"
