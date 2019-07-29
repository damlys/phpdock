#!/usr/bin/env bash
set -e

docker-compose exec http_tester \
  composer run-script target-api-tests
