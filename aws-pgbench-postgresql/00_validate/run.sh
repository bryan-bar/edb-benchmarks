#!/bin/bash -eux

echo "PGBENCH_SCALE_FACTOR: $PGBENCH_SCALE_FACTOR"
echo "EDB_BENCHMARK_REPO_URL: $EDB_BENCHMARK_REPO_URL"
echo "EDB_BENCHMARK_REPO_BRANCH: $EDB_BENCHMARK_REPO_BRANCH"

if (( $(echo "$PGBENCH_SCALE_FACTOR < 100" | bc -l) )); then
   echo "PGBENCH_SCALE_FACTOR: $PGBENCH_SCALE_FACTOR";
   echo "PGBench Scale Factor, cannot be lower than 100!"
   exit 1
fi

if [ -z "${EDB_BENCHMARK_REPO_URL}" ]; then
   echo "EDB_BENCHMARK_REPO_URL: $EDB_BENCHMARK_REPO_URL";
   echo "EDB Benchmark Repo URL, cannot be empty!"
   exit 1
fi

if [ -z "${EDB_BENCHMARK_REPO_BRANCH}" ]; then
   echo "EDB_BENCHMARK_REPO_BRANCH: $EDB_BENCHMARK_REPO_BRANCH";
   echo "EDB Benchmark Repo URL, cannot be empty!"
   exit 1
fi
