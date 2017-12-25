#!/usr/bin/env bash

url=$1

curl --head ${url} 2>/dev/null | head -n 1 | grep -q "HTTP/... [23].."
if [[ $? -eq 0 ]] ; then
  echo URL ${url} is available
else
  echo URL ${url} is unavailable
fi
