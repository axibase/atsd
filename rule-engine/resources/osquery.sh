#!/usr/bin/env bash

key_location=${1}
host=${2}

ssh -i ${key_location} ${host} 'osqueryi "SELECT DISTINCT processes.name, listening_ports.port, processes.pid FROM listening_ports JOIN processes USING (pid) WHERE listening_ports.address = '\''0.0.0.0'\'';"'