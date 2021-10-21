#!/usr/bin/env bash
set -e

inject_environment_variables()
{
  envsubst $(printenv | cut -f1 -d'=' | sed 's/.*/\\\${&}/' | tr '\n' ',')
}

if [[ "$(id --user)" == '0' ]]
then
  echo 'Generating the "/etc/nginx/nginx.conf" file.'
  inject_environment_variables < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf
else
  echo 'Skipping generation of "/etc/nginx/nginx.conf" file.'
fi

exec "$@"
