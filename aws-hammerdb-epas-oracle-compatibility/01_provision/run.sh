#!/bin/bash -eux
SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
BENCHMARK_DIRECTORY="$(realpath "${SOURCEDIR}/..")"
ROOT_DIRECTORY="$(realpath "${BENCHMARK_DIRECTORY}/..")"
ANSIBLE_ROLES_PATH="${ROOT_DIRECTORY}/roles"

ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH \
    ansible-playbook "${SOURCEDIR}/generate.yml" \
        -e "template_file=$SOURCEDIR/templates/infrastructure.yml.j2" \
        -e "dest_file=$SOURCEDIR/../infrastructure.yml" \
        -e "user_templates=$SOURCEDIR/templates" \
        -e "@$SOURCEDIR/../environment.yml" \
        -e "@$SOURCEDIR/../credentials.yml"

mkdir -p "${BENCHMARK_DIRECTORY}/results/prepare"
mkdir -p "${BENCHMARK_DIRECTORY}/results/execute"
