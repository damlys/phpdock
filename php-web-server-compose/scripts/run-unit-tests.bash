#!/usr/bin/env bash
set -e

docker-compose exec cgi_server \
  composer run-script unit-tests

docker-compose exec http_tester \
  composer run-script unit-tests
