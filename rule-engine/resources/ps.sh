#!/usr/bin/env bash

host=${1}
pattern=${2}

ssh -i /home/axibase/.ssh/def.key ${host} ps aux | grep ${pattern}