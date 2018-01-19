#!/usr/bin/env bash

kill_after=${1}
host=${2}

timeout ${kill_after}s traceroute ${host}

if [[ $? != 0 ]] ; then
  echo -e "\nExceeded ${kill_after} seconds"
fi