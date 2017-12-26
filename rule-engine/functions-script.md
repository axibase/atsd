# Functions: script

## Overview

Function `scriptOut` returns standard output/error of a bash or python script stored on the ATSD file system.
For security purposes, the script must exist in the directory `./atsd/conf/script/`.

## Syntax

```java
scriptOut(String scriptFileName, List arguments)
```

## Examples

### ping

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/ping.sh) to test ping of host n number of times.

#### Script text

```bash
#!/usr/bin/env bash
 
host=${1}
count=${2}
 
ping -c ${count} ${host}

```
#### Function command

```bash
Output is: ${scriptOut('ping.sh', ['axibase.com','3'])}
```

#### Launch command

```
ping -c 3 axibase.com
```
   
#### Output

```bash
PING axibase.com (78.47.207.156) 56(84) bytes of data.
64 bytes from axibase.com (78.47.207.156): icmp_seq=1 ttl=52 time=45.5 ms
64 bytes from axibase.com (78.47.207.156): icmp_seq=2 ttl=52 time=40.0 ms
64 bytes from axibase.com (78.47.207.156): icmp_seq=3 ttl=52 time=43.9 ms

--- axibase.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 40.078/43.189/45.588/2.305 ms
```

#### Notification Example

Telegram:

![](images/script-ping-telegram.png)

Discord:

![](images/script-ping-discord.png)

Slack:

![](images/script-ping-slack.png)


### traceroute

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/traceroute.sh) to return traceroute to host.

#### Script text

```bash
#!/usr/bin/env bash

kill_after=${1}
host=${2}

timeout ${kill_after} traceroute ${host}; echo $?

```

#### Function command

```bash
Output is: ${scriptOut('traceroute.sh', ['3','axibase.com'])}
```
    
#### Launch command

```bash
timeout 3 traceroute axibase.com; echo $?
```
#### Output

```bash
traceroute to axibase.com (78.47.207.156), 30 hops max, 60 byte packets
 1  NURSWGVML102(10.102.0.1)  0.149 ms  0.059 ms  0.032 ms
 2  static.129.38.9.5.clients.your-server.de (5.9.38.129)  0.438 ms  0.430 ms  0.481 ms
 3  core23.fsn1.hetzner.com (213.239.229.233)  0.402 ms core24.fsn1.hetzner.com (213.239.229.237)  0.341 ms core23.fsn1.hetzner.com (213.239.229.233)  0.399 ms
 4  ex9k2.dc8.fsn1.hetzner.com (213.239.229.18)  0.442 ms  0.438 ms ex9k2.dc8.fsn1.hetzner.com (213.239.229.22)  0.416 ms
 5  cnode3.6.fsn1.your-cloud.host (136.243.180.196)  0.306 ms  0.297 ms  0.313 ms
 6  axibase.com (78.47.207.156)  0.348 ms  0.363 ms  0.308 ms
```

#### Notification Example

 Telegram:
 
 ![](images/script-traceroute-telegram.png)
 
 Discord:
 
 ![](images/script-traceroute-discord.png)
 
 Slack:
 
 ![](images/script-traceroute-slack.png)


### top

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/top.sh) that returns output of top (in batch mode) from a remote server (using ssh with key authentication, key stored in a known location).

#### Script text

```bash
#!/usr/bin/env bash

key_location=${1}
host=${2}
user=${3}
count=${4}
delay=${5}
rows_n=${6}


ssh -i ${key_location} ${host} top -u ${user} -b -n ${count} -d ${delay} | head -n ${rows_n}

```
#### Function command

```bash
${scriptOut('remote_top_batch.sh', ['/home/axibase/ssh_host_rsa_key','axibase.com','www-data', '1', '1', '15'])}
```
#### Launch command

```bash
ssh -i /home/axibase/ssh_host_rsa_key axibase.com top -u www-data -b -n 1 -d 1 | head -n 15
```

#### Output

```bash
top - 13:01:25 up 96 days, 23:05,  1 user,  load average: 0.02, 0.04, 0.05
Tasks: 139 total,   1 running, 138 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.3 us,  0.6 sy,  0.0 ni, 97.8 id,  0.2 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem:   2049052 total,  1951460 used,    97592 free,    25364 buffers
KiB Swap:        0 total,        0 used,        0 free.  1363820 cached Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 8831 www-data  20   0  346044  67436  50140 S   0.0  3.3   0:05.49 php5-fpm
10145 www-data  20   0  341676  58756  45816 S   0.0  2.9   1:16.71 php5-fpm
21890 www-data  20   0  338204  54772  43288 S   0.0  2.7   0:14.65 php5-fpm
25001 www-data  20   0   94860   8576   2724 S   0.0  0.4  55:42.36 nginx
25002 www-data  20   0   93864   7488   2552 S   0.0  0.4  56:01.59 nginx
25003 www-data  20   0   93816   6408   1536 S   0.0  0.3  53:06.12 nginx
25005 www-data  20   0   96512   8184    696 S   0.0  0.4  54:38.85 nginx
28047 www-data  20   0  339860  57372  44236 S   0.0  2.8   0:02.34 php5-fpm
```

#### Notification Example

 Telegram:
 
 ![](images/script-top-telegram.png)
 
 Discord:
 
 ![](images/script-top-discord.png)
 
 Slack:
 
 ![](images/script-top-slack.png) 
   
      
### ps

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/ps.sh) that returns ps output for the specified grep pattern
 
#### Script text

```bash
#!/usr/bin/env bash

pattern=${1}

ps aux | grep ${pattern}

```
#### Function command

```bash
Output is: ${scriptOut('ps.sh', ['bash'])}
```
#### Launch command

```bash
ps aux | grep bash
```

#### Output

```bash
axibase      1  0.0  0.0  19712  3304 ?        Ss   11:07   0:00 /bin/bash /entrypoint.sh
axibase   2807  0.0  0.0  19828  3464 ?        S    11:09   0:00 bash /opt/atsd/hbase/bin/hbase-daemon.sh --config /opt/atsd/hbase/bin/../conf foreground_start master
root      5993  0.0  0.0  19944  3736 ?        Ss   11:24   0:00 bash
root      6015  0.0  0.0  12944  1016 ?        S+   11:24   0:00 grep --color=auto bash
```

#### Notification Example   
 
 Telegram:
 
 ![](images/script-ps-telegram.png)
 
 Discord:
 
 ![](images/script-ps-discord.png)
 
 Slack:
 
 ![](images/script-ps-slack.png)   
      

### URL availability

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/url_avail.sh) that tests URL availability.

#### Script text

```bash
#!/usr/bin/env bash

url=${1}
status=$(curl --head ${1} 2>/dev/null | head -n 1 | grep -oiE "[0-9]{3}[a-z ]*")
if [[ $? == 0 ]] ; then
  echo ${status} 
else
  echo "Incorrect url ${1}"
fi
```

#### Function command

```bash
Status code is: ${scriptOut('url_avail.sh', ['https://axibase.com'])}
```
#### Launch command

```bash
curl --head https://axibase.com 2>/dev/null | head -n 1 | grep -oiE "[0-9]{3}[a-z ]*"
```
#### Output

```bash
200 OK
```
#### Notification Example  

 Telegram:
 
 ![](images/script-url_avail-telegram.png)
 
 Discord:
 
 ![](images/script-url_avail-discord.png)
 
 Slack:
 
 ![](images/script-url_avail-slack.png)   


### TCP availability

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/tcp.sh) that tests TCP availability.

#### Script text

```bash
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
```
#### Function command

```bash
Output is: ${scriptOut('tcp.sh', ['2','axibase.com', '443'])}
```
#### Launch command

```bash
timeout 2 bash -c "</dev/tcp/axibase.com/443"
```
#### Output

```bash
TCP port 443 is available
```
#### Notification Example

 Telegram:
 
 ![](images/script-tcp-telegram.png)
 
 Discord:
 
 ![](images/script-tcp-discord.png)
 
 Slack:
 
 ![](images/script-tcp-slack.png)  


### osquery

[Script](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/osquery.sh) that executes a [osquery](https://osquery.io/) query against a remote server via ssh command (key stored in a known location).

#### Script text

```bash
#!/usr/bin/env bash

key_location=${1}
host=${2}

ssh -i ${key_location} ${host} 'osqueryi "SELECT DISTINCT processes.name, listening_ports.port, processes.pid FROM listening_ports JOIN processes USING (pid) WHERE listening_ports.address = '\''0.0.0.0'\'';"'
```
#### Function command

```bash
${scriptOut('osquery.sh', ['/home/axibase/ssh_host_rsa_key', 'axibase.com'])}
```
`scriptOut` should be surrounded with backticks for output formatting:

 ![](images/script-osquery-bacticks.png)  
 
 
#### Launch command

```bash
ssh -i /home/axibase/ssh_host_rsa_key axibase.com 'osqueryi "SELECT DISTINCT processes.name, listening_ports.port, processes.pid FROM listening_ports JOIN processes USING (pid) WHERE listening_ports.address = '\''0.0.0.0'\'';"'
```
#### Output

```markdown
+------+-------+------+
| name | port  | pid  |
+------+-------+------+
| java | 50010 | 9112 |
| java | 50075 | 9112 |
| java | 50020 | 9112 |
| java | 50090 | 9365 |
| java | 50070 | 8921 |
+------+-------+------+
```
#### Notification Example

 Telegram:
 
 ![](images/script-osquery-telegram.png)
 
 Discord:
 
 ![](images/script-osquery-discord.png)
 
 Slack:
 
 ![](images/script-osquery-slack.png)    