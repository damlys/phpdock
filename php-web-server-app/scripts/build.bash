#!/usr/bin/env bash
set -e
. "$(dirname "$0")/_variables.bash"

echo 'Building Docker image...'
docker build --tag="${IMAGE}:${VERSION}" .
