#!/usr/bin/env bash
set -e

cgi_ping_response_content="$(REQUEST_METHOD='GET' SCRIPT_FILENAME='/ping' SCRIPT_NAME='/ping' cgi-fcgi -bind -connect "127.0.0.1:9000" 2>/dev/null)"
if [[ "$cgi_ping_response_content" != *'pong' ]]
then
  exit 1
fi

exit 0
