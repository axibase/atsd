#!/usr/bin/env bash

key_location=${1}
host=${2}
user=${3}
count=${4}
delay=${5}
rows_n=${6}


ssh -i ${key_location} ${host} top -u ${user} -b -n ${count} -d ${delay} | head -n ${rows_n}