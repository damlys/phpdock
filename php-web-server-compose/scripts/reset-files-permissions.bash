#!/usr/bin/env bash
set -e

docker-compose exec cgi_server \
  chown --recursive $(id -u):$(id -g) .

docker-compose exec http_tester \
  chown --recursive $(id -u):$(id -g) .
