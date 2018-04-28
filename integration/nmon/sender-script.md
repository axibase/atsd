# Sender Script

**SSH Tunnel**

The sender script is used to stream nmon data into ATSD as it is written into the nmon file.

The `nmon_sender_ssh.sh` script creates an ssh-tunnel and uses it to send nmon data to ATSD.

[resources/nmon_sender_ssh.sh](https://github.com/axibase/nmon/blob/master/nmon_sender_ssh.sh)

The [SSH Tunneling](https://axibase.com/products/axibase-time-series-database/writing-data/nmon/ssh-tunneling/) guide explains how to setup and test the tunnel manually.

Unpack the script to the `/opt/nmon` directory, as described in the [SSH File Streaming guide](https://axibase.com/products/axibase-time-series-database/writing-data/nmon/file-streaming/).

**Telnet**

The `nmon_sender_telnet.sh script` uses Telnet to send nmon data to ATSD.

[resources/nmon_sender_telnet.sh](https://github.com/axibase/nmon/blob/master/nmon_sender_telnet.sh)

Unpack the script to the `/opt/nmon directory`, as described in the [Telnet File Streaming guide](https://axibase.com/products/axibase-time-series-database/writing-data/nmon/nmon-file-streaming/).

#### Script Arguments

Example crontab setup:

```sh
0 0 * * * /opt/nmon/nmon -f -s 60 -c 1440 -T -m /opt/nmon/nmon_logs/
0 0 * * * /opt/nmon/nmon_sender_ssh.sh {atsdhostname} -p 22 -s 60 -c 1440 -m /opt/nmon/nmon_logs/ -i /opt/nmon/id_rsa_atsdreadonly >>/opt/nmon/full.log 2>&1
```

The first line is a task to start nmon.

The second line is a task to run the script. The `{atsdhostname}` must be replaced with a hostname or IP address where the ATSD is installed (NAT address if you are using port forwarding).

Argument `-p` specifies the port of the machine where the ATSD is installed.

`-s` , `-c`, and `-m` arguments must have the same values in both lines.

All arguments, except `-h`, must have a value.

To stop the script and all involved processes, just run (with the correct pid of nmon sender script):

```sh
kill $nmonsenderPID
```

You can find the right `$nmonsenderPID` in output of command:

```sh
ps -ef | grep nmon_sender_ssh.sh
```

| Argument | Description |
| --- | --- |
|  `-h`  |  Show help message.  |
|  `-s [second]`  |  Set period of making snapshot of nmon (60 by default).  |
|  `-c [count]`  |  Set count of snapshot (1440 by default).  |
|  `-m [dir]`  |  Set nmon output directory or filename (`./` by default).  |
|  `-u [user]`  |  Set user for ssh-connect (`atsdreadonly` by default).  |
|  `-i [keypath]`  |  Set path to private key (`~/.ssh/id_rsa_atsdreadonly` by default).  |
|  `-p [port]`  |  Set port to connect by ssh (22 by default).  |
|  `-r [parser_id]`  |  Set parser id (`default` by default).  |
