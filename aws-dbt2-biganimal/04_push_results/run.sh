#!/bin/bash -eux
# Push DBT2 files to the S3 bucket
TERRAFORM_PROJECT_PATH="${RESULTS_DIRECTORY}/${TERRAFORM_PROJECT_NAME}"
cd $RESULTS_DIRECTORY/dbt2-data
date=$(date +'%Y-%m-%dT%H:%M:%S')

aws s3 cp "${TERRAFORM_PROJECT_PATH}/" "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/${TERRAFORM_PROJECT_NAME}/" --recursive
aws s3 cp readme.txt s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/
aws s3 cp infrastructure.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/
aws s3 cp vars.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/
aws s3 cp report.html s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/
aws s3 cp db/ s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/db --recursive
aws s3 cp driver/ s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/driver --recursive
aws s3 cp txn/ s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/txn --recursive
