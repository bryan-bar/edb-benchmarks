#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Push pgbench files to the S3 bucket
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"
cd "$RESULTS_DIRECTORY"
date=$(date +'%Y-%m-%dT%H:%M:%S')

aws s3 cp "${TERRAFORM_PROJECT_PATH}/" "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/${TERRAFORM_PROJECT_NAME}/" --recursive
aws s3 cp ${RESULTS_DIRECTORY}/infrastructure.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/infrastructure.yml
aws s3 cp ${RESULTS_DIRECTORY}/vars.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/vars.yml
aws s3 cp ${RESULTS_DIRECTORY}/report-data/ s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/report-data --recursive
