#!/usr/bin/env bash
set -e

http_ping_status_code="$(curl --output /dev/null --silent --fail --max-time 3 --write-out '%{http_code}' 'http://127.0.0.1:80/_ping.txt')"
if [[ "$http_ping_status_code" != '200' ]]
then
  exit 1
fi

exit 0
