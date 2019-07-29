#!/usr/bin/env bash
set -e

docker-compose exec cgi_server \
  composer install
docker-compose exec cgi_server \
  composer run-script build

docker-compose exec http_tester \
  composer install
docker-compose exec http_tester \
  composer run-script build
