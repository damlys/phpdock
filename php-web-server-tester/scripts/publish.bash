#!/usr/bin/env bash
set -e
. "$(dirname "$0")/_variables.bash"

echo 'Pushing Docker image...'
docker push "${IMAGE}:${VERSION}"
