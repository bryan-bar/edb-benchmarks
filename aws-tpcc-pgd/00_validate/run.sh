#!/bin/bash -eux

SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
BENCHMARK_DIRECTORY="$(realpath "${SOURCEDIR}/..")"
ROOT_DIRECTORY="$(realpath "${BENCHMARK_DIRECTORY}/..")"
ANSIBLE_ROLES_PATH="${ROOT_DIRECTORY}/roles"

ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH \
    ansible-playbook "${SOURCEDIR}/run.yml" \
        -e "root_directory=${ROOT_DIRECTORY}" \
        -e "benchmark_directory=${BENCHMARK_DIRECTORY}"
