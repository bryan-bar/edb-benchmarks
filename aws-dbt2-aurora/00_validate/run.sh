#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
BENCHMARK_DIRECTORY="$(realpath "${SOURCEDIR}/..")"
ROOT_DIRECTORY="$(realpath "${BENCHMARK_DIRECTORY}/..")"
ANSIBLE_ROLES_PATH="${ROOT_DIRECTORY}/roles"

ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH \
    ansible-playbook "${SOURCEDIR}/run.yml" \
        -e "root_directory=${ROOT_DIRECTORY}" \
        -e "benchmark_directory=${BENCHMARK_DIRECTORY}"

echo "DBT2_DURATION: $DBT2_DURATION"
echo "DBT2_WAREHOUSE: $DBT2_WAREHOUSE"
echo "DBT2_CONNECTIONS: $DBT2_CONNECTIONS"

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

# Left as comments for template examples of possible latter validations
#if (( $(echo "$PROC_OPT_1 < 1" | bc -l) )); then
#   echo "DBT2_CONNECTIONS: $DBT2_CONNECTIONS   Number of Processors: $NUM_OF_PROCS_1   Result: $PROC_OPT_1";
#   echo "DBT2 Connections is too low, causes zero division error!!!"
#   exit 1
#fi
