#!/bin/bash -eux
# Generic
export BUCKET_NAME="${BUCKET_NAME:=ebac-reports}"
export BENCHMARK_NAME="${BENCHMARK_NAME:=AWS_PSR_3_NODES}"

# Credentials
export EDB_REPO_USERNAME="${EDB_REPO_USERNAME:=<secret>}"
export EDB_REPO_PASSWORD="${EDB_REPO_PASSWORD:=<secret>}"

# Ansible
export ANSIBLE_VERBOSITY="${ANSIBLE_VERBOSITY:=0}"

# Terraform
export SSH_USER="${SSH_USER:=rocky}"

# TPCC
export TPCC_DURATION="${TPCC_DURATION:=20}"
export TPCC_WAREHOUSE="${TPCC_WAREHOUSE:=2000}"
export TPCC_RAMPUP="${TPCC_RAMPUP:=1}"
export TPCC_LOADER_VUSERS="${TPCC_LOADER_VUSERS:=75}"
export TPCC_MIN_VUSERS="${TPCC_MIN_VUSERS:=5}"
export TPCC_MAX_VUSERS="${TPCC_MAX_VUSERS:=100}"
export TPCC_STEP_VUSERS="${TPCC_STEP_VUSERS:=5}"
