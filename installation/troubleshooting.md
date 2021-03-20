# Troubleshooting

## Requirements

Verify that the target server meets hardware and OS [requirements](./requirements.md).

## Connection

ATSD listens on the following ports by default:

* `8443/tcp`: Web Interface / [REST API](../api/data/README.md) (HTTPS)
* `8088/tcp`: Web Interface / [REST API](../api/data/README.md) (HTTP)
* `8084/udp`: [Python pickle format](../integration/graphite/pickle-protocol.md)
* `8082/udp`: [Network API](../api/network/README.md)
* `8081/tcp`: [Network API](../api/network/README.md)
* `1099/tcp`: [JMX](../administration/monitoring-metrics/jmx.md)

In case you are not able to connect to an ATSD network service, check that the service is listening and the firewall allows access to the target port.

* Log in to ATSD server
* Search `netstat` output for TCP/UDP sockets that are listening on the target port, for example `8081`.

```sh
netstat -tulnp | grep 8081
```

```txt
...
tcp        0      0 0.0.0.0:8081            0.0.0.0:*               LISTEN
```

* Check connectivity with `telnet` or `netcat` from a remote client to the ATSD server

```sh
$ telnet atsd_hostname 8081
Trying 192.0.2.1...
Connected to atsd_hostname.
Escape character is '^]'.
```

```txt
$ netcat -z -v atsd_hostname 8081
Connection to atsd_hostname 8081 port [tcp/tproxy] succeeded!
```

* If the connection cannot be established, check that the `iptables` firewall on the ATSD server is [configured to allow](firewall.md) incoming TCP/UDP traffic to the target ports.

## Review Logs

Review the following log files for errors.

* Startup log: `/opt/atsd/atsd/logs/start.log`
* Application log: `/opt/atsd/atsd/logs/atsd.log`

```sh
tail -n 200 -f /opt/atsd/atsd/logs/atsd.log
```

If ATSD is launched in a Docker container, run:

```bash
docker exec -it atsd tail -f /opt/atsd/atsd/logs/atsd.log
```

To view ATSD, HBase, and HDFS files in the same stream, enumerate the paths.

```sh
tail -F /opt/atsd/atsd/logs/atsd.log \
  /opt/atsd/hbase/logs/* \
  /opt/atsd/hadoop/logs/*
```

## 32-bit Error

`Package Not Found` error is displayed when attempting an installation of ATSD deb package on 32-bit architecture.

Retry installation on a supported [architecture](./requirements.md).

## Technical Support

Contact us at `support-atsd@axibase.com` with any technical questions.

Attach [relevant details](../administration/support.md) to your ticket.
