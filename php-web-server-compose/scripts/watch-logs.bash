#!/usr/bin/env bash
set -e

docker-compose logs --timestamps --tail 0 --follow
