#!/usr/bin/env bash

kill_after=${1}
host=${2}
port=${3}

timeout ${kill_after} bash -c "</dev/tcp/${host}/${port}"

if [[ $? -eq 0 ]]; then
	echo "TCP port ${port} is available"	
else
	echo "TCP port ${port} is unavailable"
fi
