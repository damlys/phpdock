#!/usr/bin/env bash
set -e

inject_environment_variables()
{
  envsubst $(printenv | cut -f1 -d'=' | sed 's/.*/\\\${&}/' | tr '\n' ',')
}

if [[ "$(id --user)" == '0' ]]
then
  inject_environment_variables < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf

  if [[ "$XDEBUG_ENABLE" == 'on' ]]
  then
    if php -r "exit(extension_loaded(\"xdebug\") ? 1 : 0);"
    then
      docker-php-ext-enable xdebug
    fi
  fi
fi

exec "$@"
