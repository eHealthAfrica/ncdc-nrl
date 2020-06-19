#!/usr/bin/env bash

set -Eeuo pipefail

function echo_message {
    if [ -z "$1" ]; then
        echo -e "\033[90m$LINE\033[0m"
    else
        local msg=" $1 "
        local color=${2:-\\033[39m}
        echo -e "\033[90m${LINE:${#msg}}\033[0m$color$msg\033[0m"
    fi
}

function echo_error {
    echo_message "$1" \\033[91m
}

function echo_success {
    echo_message "$1" \\033[92m
}

source .env

docker network rm ncdc_nrl_net || true

echo_message "Generating docker network and database volume..."
{
    docker network create ncdc_nrl_net \
        --attachable
} || true
echo_success "ncdc_nrl_net net work is ready"

VOLUMES=( ncdc_nrl_ckan_data )
for volume in "${VOLUMES[@]}"; do
    docker volume create $volume || true
    echo_success "$volume volume is ready"
done

docker-compose up -d --build
