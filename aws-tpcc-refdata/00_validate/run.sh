#!/bin/bash -eux

echo "EDB_BENCHMARK_REPO_URL: $EDB_BENCHMARK_REPO_URL"
echo "EDB_BENCHMARK_REPO_BRANCH: $EDB_BENCHMARK_REPO_BRANCH"

if (( $(echo "$tpcc_warehouse < 15" | bc -l) )); then
   echo "tpcc_warehouse: $tpcc_warehouse";
   echo "HammerDB Warehouses, cannot be lower than 15!"
   exit 1
fi

if (( $(echo "$tpcc_duration < 15" | bc -l) )); then
   echo "tpcc_duration: $tpcc_duration";
   echo "HammerDB run duration, cannot be lower than 15!"
   exit 1
fi

if (( $(echo "$tpcc_rampup < 15" | bc -l) )); then
   echo "tpcc_rampup: $tpcc_rampup";
   echo "HammerDB RampUp, cannot be lower than 15!"
   exit 1
fi

if (( $(echo "$tpcc_vusers < 15" | bc -l) )); then
   echo "tpcc_vusers: $tpcc_vusers";
   echo "HammerDB Number of virtual users, cannot be lower than 15!"
   exit 1
fi

if (( $(echo "$tpcc_loader_vusers < 15" | bc -l) )); then
   echo "tpcc_loader_vusers: $tpcc_loader_vusers";
   echo "HammerDB Number of Loader virtual users, cannot be lower than 15!"
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
