#!/usr/bin/env bash
#
# Copyright (C) 2019 by eHealth Africa : http://www.eHealthAfrica.org
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
set -Eeuo pipefail

source .env

docker-compose -f ckan/docker-compose.yml kill
docker-compose -f ckan/docker-compose.yml down

docker-compose -f ckan/docker-compose.yml up --build -d
CKAN_ID=$(docker-compose -f ckan/docker-compose.yml ps -q ckan)

retries=1
until docker exec -it $CKAN_ID /usr/local/bin/ckan-paster \
    --plugin=ckan \
    user add $CKAN_SYSADMIN_NAME \
    email=$CKAN_SYSADMIN_EMAIL \
    name=$CKAN_SYSADMIN_NAME \
    password=$CKAN_SYSADMIN_PASSWORD \
    -c /etc/ckan/production.ini
do
    echo "waiting for ckan container to be ready... $retries"
    sleep 5

        ((retries++))
        if [[ $retries -gt 30 ]]; then
            echo "It was not possible to start CKAN"
            exit 1
        fi
done

retries=1
until docker exec -it $CKAN_ID /usr/local/bin/ckan-paster \
    --plugin=ckan \
    sysadmin add $CKAN_SYSADMIN_NAME \
    -c /etc/ckan/production.ini
do
    echo "waiting for ckan container to be ready... $retries"
    sleep 5

        ((retries++))
        if [[ $retries -gt 30 ]]; then
            echo "It was not possible to start CKAN"
            exit 1
        fi
done

docker-compose -f ckan/docker-compose.yml kill
docker-compose -f ckan/docker-compose.yml down
