
#!/usr/bin/env bash

host=${1}
query=${2}

ssh -i /home/axibase/.ssh/def.key ${host} "osqueryi \"${query}\""