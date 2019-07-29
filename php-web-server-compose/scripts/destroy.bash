#!/usr/bin/env bash
set -e

echo 'Removing containers...'
docker-compose down --remove-orphans
