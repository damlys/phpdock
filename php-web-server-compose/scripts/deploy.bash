#!/usr/bin/env bash
set -e

echo 'Creating containers...'
docker-compose up --detach --remove-orphans
