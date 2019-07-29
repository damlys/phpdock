#!/usr/bin/env bash
set -e

echo 'Validating Docker Compose manifest...'
docker-compose config --quiet
