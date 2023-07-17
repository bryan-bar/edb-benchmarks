#!/bin/bash -eux
# Left as comments for template examples of possible latter validations
# Assign possible number of processors
#NUM_OF_PROCS_1=1

# Left as comments for template examples of possible latter validations
# Perform division calculations
#PROC_OPT_1=$(echo "$DBT2_CONNECTIONS / $NUM_OF_PROCS_1" | bc)

# Save current path and change to script directory
RUNDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
ORIGINAL_DIR=$(pwd)
cd $RUNDIR

# Expand any needed paths
RESULTS_DIRECTORY=$(realpath "$RESULTS_DIRECTORY")
TERRAFORM_PROJECT_PATH=$(realpath "$TERRAFORM_PROJECT_PATH")
VARS_FILE=$(realpath "$VARS_FILE")
ENV_FILE=$(realpath "$ENV_FILE")

PLAYBOOK=${RUNDIR}/playbook-dbt2-validate.yml
ansible-playbook $PLAYBOOK \
   -e "vars_file=$VARS_FILE" \
   -e "env_file=$ENV_FILE"

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

# Return
cd "$ORIGINAL_DIR"
