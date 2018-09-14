# Installation: Docker Image

## Host Requirements

* [Docker Engine](https://docs.docker.com/engine/installation/) 1.7+.

## Images

* Image name: `axibase/atsd:latest`
* Base Image: Ubuntu 16.04
* [Dockerfile](https://github.com/axibase/dockers/blob/master/Dockerfile)
* [Docker Hub](https://hub.docker.com/r/axibase/atsd/)

## Start Container

```bash
docker run -d --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  axibase/atsd:latest
```

To automatically create an [account](../administration/collector-account.md) for data collection agents, replace `username` and `password` credential variables in the command below.

```bash
docker run -d --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  --env COLLECTOR_USER_NAME=username \
  --env COLLECTOR_USER_PASSWORD=password \
  --env COLLECTOR_USER_TYPE=api-rw \
  axibase/atsd:latest
```

The password is subject to the following [requirements](../administration/user-authentication.md#password-requirements). If the password contains special characters `$`, `&`, `#`, or `!`, escape them with backslash `\`.

:::tip Note
For installation on Kubernetes refer to this [guide](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html).
:::

## Check Installation

```elm
docker logs -f atsd
```

Watch for **ATSD start completed** message at the end of the `start.log`.

```txt
[ATSD] Waiting for ATSD to accept requests on port 8088 ... ( 4 / 60 )
[ATSD] ATSD user interface:
[ATSD] http://172.17.0.2:8088
[ATSD] https://172.17.0.2:8443
[ATSD] ATSD start completed. Time: 2017-10-03 19-50-16.
```

Web interface is now accessible on port `8443` (HTTPS).

## Launch Parameters

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`--detach` | Yes | Run container in background and print container id. |
|`--hostname` | No | Assign hostname to the container. |
|`--name` | No | Assign a unique name to the container. |
|`--restart` | No | Auto-restart policy.|
|`--publish` | No | Publish container port to the host. |
|`--env` | No | Define a new environment variable inside the container in `key=value` format. |

## Environment Variables

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`ADMIN_USER_NAME` | No | User name for the built-in administrator account. |
|`ADMIN_USER_PASSWORD` | No | [Password](../administration/user-authentication.md#password-requirements) for the built-in administrator.|
|`COLLECTOR_USER_NAME` | No | User name for a data collector account. |
|`COLLECTOR_USER_PASSWORD` | No | [Password](../administration/user-authentication.md#password-requirements) for a data collector account.|
|`COLLECTOR_USER_TYPE` | No | User group for a data collector account, default value is `writer`.|
|`DB_TIMEZONE` | No | Database [time zone identifier](../shared/timezone-list.md).|
|`JAVA_OPTS` | No | Additional arguments passed to ATSD JVM process. |
|`HADOOP_OPTS` | No | Additional arguments passed to Hadoop/HDFS JVM processes. |
|`HBASE_OPTS` | No | Additional arguments passed to HBase JVM processes. |

View additional launch examples [here](#start-container).

## Exposed Ports

* 8088 – HTTP
* 8443 – HTTPS
* 8081 – [TCP network commands](../api/network/README.md#network-api)
* 8082 – [UDP network commands](../api/network/README.md#udp-datagrams)

## Port Mappings

Change port mappings in the launch command in case of port allocation error.

```txt
Cannot start container <container_id>: failed to create endpoint atsd on network bridge:
Bind for 0.0.0.0:8088 failed: port is already allocated
```

```bash
docker run -d --name=atsd \
  --publish 9088:8088 \
  --publish 9443:8443 \
  --publish 9081:8081 \
  --publish 9082:8082/udp \
  axibase/atsd:latest
```

## Custom Data Directories

To start container with [data directories](../administration/change-data-directory.md) mounted on custom external volumes, specify the volumes in the `run` command.

```bash
docker run -d --name=atsd \
  -p 9088:8088 -p 9443:8443 -p 9081:8081 -p 9082:8082/udp \
  -v /path/to/hdfs-cache:/opt/atsd/hdfs-cache \
  -v /path/to/hdfs-data:/opt/atsd/hdfs-data \
  -v /path/to/hdfs-data-name:/opt/atsd/hdfs-data-name \
  axibase/atsd:latest
```

Stop **all** ATSD processes after ATSD start error is display in container logs.

```txt
ls: Call From 2c206c3a3f0c... to localhost:8020 failed on connection exception
[ATSD] HDFS is not available.
```

```bash
docker exec atsd /opt/atsd/bin/atsd-all.sh stop
```

Grant ownership of the base directory `/opt/atsd` to the `axibase` user.

```bash
docker exec -u root atsd chown -R axibase:axibase /opt/atsd
```

Format the new data directory.

```bash
docker exec -u axibase atsd /opt/atsd/hadoop/bin/hdfs namenode -format
```

Start ATSD.

```bash
docker exec atsd /opt/atsd/bin/atsd-all.sh start
```

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
