#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
BENCHMARK_DIRECTORY="$(realpath "${SOURCEDIR}/..")"
ROOT_DIRECTORY="$(realpath "${BENCHMARK_DIRECTORY}/..")"
ANSIBLE_ROLES_PATH="${ROOT_DIRECTORY}/roles"

ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH \
    ansible-playbook "${SOURCEDIR}/run.yml" \
        -e "root_directory=${ROOT_DIRECTORY}" \
        -e "benchmark_directory=${BENCHMARK_DIRECTORY}"

if (( $(echo "$TPCC_WAREHOUSE < 2000" | bc -l) )); then
   echo "TPCC_WAREHOUSE: $TPCC_WAREHOUSE";
   echo "HammerDB Warehouses, cannot be lower than 2000!"
   exit 1
fi

if (( $(echo "$TPCC_DURATION < 5" | bc -l) )); then
   echo "TPCC_DURATION: $TPCC_DURATION";
   echo "HammerDB run duration, cannot be lower than 5!"
   exit 1
fi

if (( $(echo "$TPCC_RAMPUP < 10" | bc -l) )); then
   echo "TPCC_RAMPUP: $TPCC_RAMPUP";
   echo "HammerDB RampUp, cannot be lower than 10!"
   exit 1
fi

if (( $(echo "$TPCC_LOADER_VUSERS < 75" | bc -l) )); then
   echo "TPCC_LOADER_VUSERS: $TPCC_LOADER_VUSERS";
   echo "HammerDB Number of virtual users, cannot be lower than 75!"
   exit 1
fi

if (( $(echo "$TPCC_MIN_VUSERS < 1" | bc -l) )); then
   echo "TPCC_MIN_VUSERS: $TPCC_MIN_VUSERS";
   echo "HammerDB Number of Minimum virtual users, cannot be lower than 1!"
   exit 1
fi

if (( $(echo "$TPCC_MAX_VUSERS < 14" | bc -l) )); then
   echo "TPCC_MAX_VUSERS: $TPCC_MAX_VUSERS";
   echo "HammerDB Number of Maximum virtual users, cannot be lower than 14!"
   exit 1
fi


if (( $(echo "$TPCC_STEP_VUSERS < 1" | bc -l) )); then
   echo "TPCC_STEP_VUSERS: $TPCC_STEP_VUSERS";
   echo "HammerDB Increased Virtual Users, cannot be lower than 1!"
   exit 1
fi

if [ -z "${TPA_2Q_SUBSCRIPTION_TOKEN}" ]; then
   echo "TPA_2Q_SUBSCRIPTION_TOKEN: $TPA_2Q_SUBSCRIPTION_TOKEN";
   echo "TPA Exec Subscription Token, cannot be empty!"
   exit 1
fi
