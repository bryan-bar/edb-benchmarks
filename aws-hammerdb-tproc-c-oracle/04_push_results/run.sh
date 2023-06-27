#!/bin/bash -eux
# Push HammerDB files to the S3 bucket
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"
cd "${RESULTS_DIRECTORY}/tprocc-data"
date=$(date +'%Y-%m-%dT%H:%M:%S')

aws s3 cp "${TERRAFORM_PROJECT_PATH}/" "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/${TERRAFORM_PROJECT_NAME}/" --recursive
aws s3 cp ./ "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/" --recursive
