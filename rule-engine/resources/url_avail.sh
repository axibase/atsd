#!/usr/bin/env bash

url=${1}
dir=$(dirname $(readlink -f $0))
status=$(curl -sS --insecure -X GET -m 10 -D ${dir}/headers -w "\nResponse Time: %{time_total}\n" "${url}" > ${dir}/response 2>&1)
if [[ $? == 0 ]] ; then
  code=$(head -n 1 ${dir}/headers | grep -oiE "[0-9]{3}[a-z ]*")
  echo "Status code: ${code}"
  echo "$(tail -n 1 ${dir}/response)" # Response Time
  length=$(head -n -1 ${dir}/response | wc -c)
  echo "Content Length: ${length} bytes"
else
  head -n 1 ${dir}/response
fi

rm  ${dir}/response  ${dir}/headers
