#!/usr/bin/env bash

kill_after=${1}
host=${2}
dir=$(dirname $(readlink -f $0))

timeout ${kill_after}s traceroute ${host} 2>${dir}/error

if [ $? != 0 ] && [ $(wc -c < ${dir}/error) == 0 ]; then
  echo -e "\nExceeded ${kill_after} seconds"
else
  cat ${dir}/error
fi

rm  ${dir}/error