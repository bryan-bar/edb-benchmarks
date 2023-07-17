#!/bin/bash -eux

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $RUNDIR

# Expand any needed paths
RESULTS_DIRECTORY=$(realpath "$RESULTS_DIRECTORY")

# Push DBT2 files to the S3 bucket
date=$(date +'%Y-%m-%dT%H:%M:%S')

# Upload benchmark data
aws s3 cp "$RESULTS_DIRECTORY/" s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/ --recursive

cd $ORIGINAL_DIR
