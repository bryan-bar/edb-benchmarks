#!/bin/bash -eux
# Generic
export BUCKET_NAME=${BUCKET_NAME:=ebac-reports}
export BENCHMARK_NAME=${BENCHMARK_NAME:=AWS_DBT2_AURORA}

# Credentials
export BA_PROJECT_ID="${BA_PROJECT_ID:=<secret>}"
export BA_BEARER_TOKEN="${BA_BEARER_TOKEN:=<secret>}"

# Postgres Settings
export PG_TYPE="${PG_TYPE:=PG}"
export PG_ENGINE="${PG_ENGINE:=postgres}"
export PG_VERSION="${PG_VERSION:=14}"
export PG_OWNER="${PG_OWNER:=edb_admin}"
export PG_GROUP="${PG_GROUP:=$PG_OWNER}"
export PG_SUPERUSER="${PG_SUPERUSER:=$PG_OWNER}"
export PG_PASSWORD="${PG_PASSWORD:=1234567890zyx}"
export PG_PORT="${PG_PORT:=5432}"

# Postgres Instance
export PG_INSTANCE_TYPE="${PG_INSTANCE_TYPE:=r5.8xlarge}"
export PG_STORAGE_TYPE="${PG_STORAGE_TYPE:=io2}"
export PG_STORAGE_PROPERTIES="${PG_STORAGE_PROPERTIES:=io2}"
export PG_STORAGE_SIZE="${PG_STORAGE_SIZE:=4096}"
export PG_STORAGE_IOPS="${PG_STORAGE_IOPS:=64000}"

# Ansible
export ANSIBLE_VERBOSITY="${ANSIBLE_VERBOSITY:=0}"

# TERRAFORM VARIABLES
export REGION="${REGION:=us-east-1}"
export ZONE0="${ZONE0:=us-east-1b}"
export INSTANCE_TYPE="${INSTANCE_TYPE:=c5.9xlarge}"

# DBT2
export DBT2_DURATION="${DBT2_DURATION:=15}"
export DBT2_WAREHOUSE="${DBT2_WAREHOUSE:=15}"
export DBT2_CONNECTIONS="${DBT2_CONNECTIONS:=64}"
