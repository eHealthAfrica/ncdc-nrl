#!/usr/bin/env bash

set -Eeuo pipefail

docker-compose kill
docker-compose down
