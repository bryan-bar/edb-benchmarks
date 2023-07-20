#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
RESULTS_DIRECTORY="${SOURCEDIR}/../results"
date=$(date +'%Y-%m-%dT%H:%M:%S')

# Upload benchmark data
aws s3 cp "$RESULTS_DIRECTORY/" "s3://${BUCKET_NAME}/${BENCHMARK_NAME}/${date}/" --recursive
