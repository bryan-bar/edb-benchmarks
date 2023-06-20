#!/bin/bash -eux
# Push HammerDB files to the S3 bucket
cd "${RESULTS_DIRECTORY}/tprocc-data"
date=$(date +'%Y-%m-%dT%H:%M:%S')

aws s3 cp ./ "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/" --recursive
