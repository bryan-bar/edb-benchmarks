#!/bin/bash -eux

echo "DBT2_DURATION: $DBT2_DURATION"
echo "DBT2_WAREHOUSE: $DBT2_WAREHOUSE"
echo "DBT2_CONNECTIONS: $DBT2_CONNECTIONS"
echo "EDB_BENCHMARK_REPO_URL: $EDB_BENCHMARK_REPO_URL"
echo "EDB_BENCHMARK_REPO_BRANCH: $EDB_BENCHMARK_REPO_BRANCH"

# Left as comments for template examples of possible latter validations
# Assign possible number of processors
#NUM_OF_PROCS_1=1

# Left as comments for template examples of possible latter validations
# Perform division calculations
#PROC_OPT_1=$(echo "$DBT2_CONNECTIONS / $NUM_OF_PROCS_1" | bc)

if (( $(echo "$DBT2_WAREHOUSE < 10" | bc -l) )); then
   echo "DBT2_WAREHOUSE: $DBT2_WAREHOUSE";
   echo "DBT2 Number of Warehouses is too low, causes zero division error!!!"
   exit 1
fi

if (( $(echo "$DBT2_CONNECTIONS < 64" | bc -l) )); then
   echo "DBT2_CONNECTIONS: $DBT2_CONNECTIONS";
   echo "DBT2 Number of Connections is too low, causes zero division error!!!"
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

# Left as comments for template examples of possible latter validations
#if (( $(echo "$PROC_OPT_1 < 1" | bc -l) )); then
#   echo "DBT2_CONNECTIONS: $DBT2_CONNECTIONS   Number of Processors: $NUM_OF_PROCS_1   Result: $PROC_OPT_1";
#   echo "DBT2 Connections is too low, causes zero division error!!!"
#   exit 1
#fi
