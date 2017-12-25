#!/usr/bin/env bash

host=$1
id_file=$2
count=$3
delay=$4

ssh -i ${id_file} ${host} top -b -n ${count} -d ${delay}
