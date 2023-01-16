#!/bin/bash -eux

edb-terraform ${TERRAFORM_PROJECT_PATH} ../infrastructure.yml --validate
cd ${TERRAFORM_PROJECT_PATH}
terraform apply -auto-approve
