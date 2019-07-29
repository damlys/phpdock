#!/usr/bin/env bash
set -e
. "$(dirname "$0")/_variables.bash"

echo 'Running installation tests...'
docker run --rm "${IMAGE}:${VERSION}" bash -ce '
  php --version
  php-fpm --version
  pear version
  pecl version
  composer --version
  which cgi-fcgi
  nginx -v
  envsubst --version
  curl --version
  git --version

  composer config --global cache-dir
  if [[ "$(composer config --global cache-dir)" != "/var/cache/composer" ]]
  then
    echo "ERROR: Composer cache directory for user root is not correct."
    exit 1
  fi
'

docker run --rm --user=deploy "${IMAGE}:${VERSION}" bash -ce '
  composer config --global cache-dir
  if [[ "$(composer config --global cache-dir)" != "/var/cache/composer" ]]
  then
    echo "ERROR: Composer cache directory for user deploy is not correct."
    exit 1
  fi
'

docker run --rm "${IMAGE}:${VERSION}" bash -ce '
  if php -r "exit(extension_loaded(\"xdebug\") ? 1 : 0);"
  then
    echo "OK: Xdebug is disabled by default."
  else
    echo "ERROR: Xdebug is enabled by default."
    exit 1
  fi
'

docker run --rm "${IMAGE}:${VERSION}" bash -ce '
  docker-php-ext-enable xdebug
  if php -r "exit(extension_loaded(\"xdebug\") ? 1 : 0);"
  then
    echo "ERROR: Xdebug can not be enabled."
    exit 1
  else
    echo "OK: Xdebug can be enabled."
  fi
'
