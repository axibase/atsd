#!/usr/bin/env bash

host=${1}
user=${2}
count=${3}
delay=${4}
rows_n=${5}


ssh -i /home/axibase/.ssh/def.key ${host} top -u ${user} -b -n ${count} -d ${delay} | head -n ${rows_n}