#!/bin/bash -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Push pgbench files to the S3 bucket

# Copy collected data and generated data & charts
cp -r ${SCRIPT_DIR}/../04_execute/benchmark_data ${SCRIPT_DIR}/report-data

date=$(date +'%Y-%m-%dT%H:%M:%S')

aws s3 cp ${SCRIPT_DIR}/../infrastructure.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/infrastructure.yml
aws s3 cp ${SCRIPT_DIR}/../vars.yml s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/vars.yml
aws s3 cp ${SCRIPT_DIR}/report-data/ s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/report-data --recursive
