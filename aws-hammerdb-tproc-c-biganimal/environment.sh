#!/bin/bash -eux
# Generic
export BUCKET_NAME="${BUCKET_NAME:=ebac-reports}"
export BENCHMARK_NAME="${BENCHMARK_NAME:=AWS_HAMMERDB_TPROCC_C_BIGANIMAL}"

# Credentials
export BA_PROJECT_ID="${BA_PROJECT_ID:=<secret>}"
export BA_BEARER_TOKEN="${BA_BEARER_TOKEN:=<secret>}"

# Ansible
export ANSIBLE_VERBOSITY="${ANSIBLE_VERBOSITY:=0}"

# Terraform
export SSH_USER="${SSH_USER:=rocky}"

# TPROCC
export TPROCC_DURATION="${TPROCC_DURATION:=60}"
export TPROCC_WAREHOUSE="${TPROCC_WAREHOUSE:=2000}"
export TPROCC_VUSERS="${TPROCC_VUSERS:=60}"

