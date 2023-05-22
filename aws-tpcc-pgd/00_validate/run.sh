#!/bin/bash -eux

echo "EDB_BENCHMARK_REPO_URL: $EDB_BENCHMARK_REPO_URL"
echo "EDB_BENCHMARK_REPO_BRANCH: $EDB_BENCHMARK_REPO_BRANCH"

if (( $(echo "$tpcc_warehouse < 2000" | bc -l) )); then
   echo "tpcc_warehouse: $tpcc_warehouse";
   echo "HammerDB Warehouses, cannot be lower than 2000!"
   exit 1
fi

if (( $(echo "$tpcc_duration < 5" | bc -l) )); then
   echo "tpcc_duration: $tpcc_duration";
   echo "HammerDB run duration, cannot be lower than 5!"
   exit 1
fi

if (( $(echo "$tpcc_rampup < 10" | bc -l) )); then
   echo "tpcc_rampup: $tpcc_rampup";
   echo "HammerDB RampUp, cannot be lower than 10!"
   exit 1
fi

if (( $(echo "$tpcc_loader_vusers < 75" | bc -l) )); then
   echo "tpcc_loader_vusers: $tpcc_loader_vusers";
   echo "HammerDB Number of virtual users, cannot be lower than 75!"
   exit 1
fi

if (( $(echo "$tpcc_min_vusers < 1" | bc -l) )); then
   echo "tpcc_min_vusers: $tpcc_min_vusers";
   echo "HammerDB Number of Minimum virtual users, cannot be lower than 1!"
   exit 1
fi

if (( $(echo "$tpcc_max_vusers < 14" | bc -l) )); then
   echo "tpcc_max_vusers: $tpcc_max_vusers";
   echo "HammerDB Number of Maximum virtual users, cannot be lower than 14!"
   exit 1
fi


if (( $(echo "$tpcc_step_vusers < 1" | bc -l) )); then
   echo "tpcc_step_vusers: $tpcc_step_vusers";
   echo "HammerDB Increased Virtual Users, cannot be lower than 1!"
   exit 1
fi

if [ -z "${tpa_2q_subscription_token}" ]; then
   echo "tpa_2q_subscription_token: $tpa_2q_subscription_token";
   echo "TPA Exec Subscription Token, cannot be empty!"
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
