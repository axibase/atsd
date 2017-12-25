#!/usr/bin/env bash

key_location=${1}
user=${2}
host=${3}

ssh -i ${key_location} ${user}@${host} 'osqueryi --json  "SELECT DISTINCT processes.name, listening_ports.port, processes.pid FROM listening_ports JOIN processes USING (pid) WHERE listening_ports.address = '\''0.0.0.0'\'';"'
