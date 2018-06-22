# Troubleshooting

## Requirements

Verify that the target server meets hardware and OS [requirements](../administration/requirements.md).

## Connection

ATSD is listening on the following ports by default:

* `1099/tcp` - JMX
* `8081/tcp` - Network API (TCP)
* `8082/udp` - Network API (UDP)
* `8088/tcp` - Web Interface/API (http)
* `8443/tcp` - Web Interface/API (https)

In case you are not able to connect to an ATSD network service, make sure that: a) the service is listening, and b) the firewall allows access to the target ports.

* Log in to ATSD server
* Search netstat output for TCP/UDP sockets that are listening on the target port, for example 8081

```sh
netstat -tulnp | grep 8081
```

```txt
...
tcp        0      0 0.0.0.0:8081            0.0.0.0:*               LISTEN
```

* Check connectivity with `telnet` or `netcat` from a remote client to the ATSD server

```sh
$ telnet atsd_host 8081
Trying 192.0.2.1...
Connected to atsd_host.
Escape character is '^]'.
```

```txt
$ netcat -z -v atsd_host 8081
Connection to atsd_host 8081 port [tcp/tproxy] succeeded!
```

* If the connection cannot be established, check that the `iptables` firewall on the ATSD server is [configured to allow](firewall.md) incoming TCP/UDP traffic to the target ports.

## Review Logs

Review the following log files for errors:

* Startup log: `/opt/atsd/atsd/logs/start.log`
* Application log: `/opt/atsd/atsd/logs/atsd.log`

## 32-bit Error

The `Package Not Found` error is displayed when attempting an installation of ATSD deb package on a 32-bit architecture.

Retry installation on a supported [architecture](../administration/requirements.md).
