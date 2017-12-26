#!/usr/bin/env bash

url=${1}
status=$(curl --head ${1} 2>/dev/null | head -n 1 | grep -oiE "[0-9]{3}[a-z ]*")
if [[ $? == 0 ]] ; then
  echo ${status}
else
  echo "Incorrect url ${1}"
fi
