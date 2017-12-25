#!/usr/bin/env bash

kill_after=${1}
host=${2}

timeout ${kill_after} traceroute ${host}; echo $?
