#!/bin/bash -eux
SOURCEDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
BENCHMARK_DIRECTORY="$(realpath "${SOURCEDIR}/..")"
ROOT_DIRECTORY="$(realpath "${BENCHMARK_DIRECTORY}/..")"
ANSIBLE_ROLES_PATH="${ROOT_DIRECTORY}/roles"

ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH \
    ansible-playbook \
        -e "@$BENCHMARK_DIRECTORY/environment.yml" \
        -e "@$BENCHMARK_DIRECTORY/credentials.yml" \
        /dev/stdin <<'EOF'
---
- hosts: localhost
  name: Destroy resources
  gather_facts: false

  tasks:
    - name: Role - benchmark-steps | Task - 06_unprovision.yml
      ansible.builtin.include_role:
        name: benchmark-steps
        tasks_from: 06_unprovision.yml
EOF
