# Installation on Docker

## Host Requirements

* [Docker Engine](https://docs.docker.com/engine/installation/) 1.7+.

## Images

* Image name: `axibase/atsd:latest`
* Base Image: Ubuntu 16.04
* [Dockerfile](https://github.com/axibase/dockers/blob/master/Dockerfile)
* [Docker Hub](https://hub.docker.com/r/axibase/atsd/)

## Start Container

```properties
docker run -d --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  axibase/atsd:latest
```

To automatically create an [account](../administration/collector-account.md) for data collection agents, replace `cuser` and `cpassword` credential variables in the command below.

```properties
docker run -d --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  --env COLLECTOR_USER_NAME=cuser \
  --env COLLECTOR_USER_PASSWORD=cpassword \
  --env COLLECTOR_USER_TYPE=api-rw \
  axibase/atsd:latest
```

The password is subject to the following [requirements](../administration/user-authentication.md#password-requirements). If the password contains special characters `$`, `&`, `#`, or `!`, escape them with backslash `\`.

## Check Installation

```
docker logs -f atsd
```

You should see an **ATSD start completed** message once the database is ready.

```
[ATSD] Waiting for ATSD to accept requests on port 8088 ... ( 4 / 60 )
[ATSD] ATSD user interface:
[ATSD] http://172.17.0.2:8088
[ATSD] https://172.17.0.2:8443
[ATSD] ATSD start completed. Time: 2017-10-03 19-50-16.
```

The ATSD user interface is accessible on port 8443/https.

## Launch Parameters

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`--detach` | Yes | Run container in background and print container id. |
|`--hostname` | No | Assign hostname to the container. |
|`--name` | No | Assign a unique name to the container. |
|`--restart` | No | Auto-restart policy. _Not supported in all Docker Engine versions._ |
|`--publish` | No | Publish a container's port to the host. |
|`--env` | No | Define a new environment variable inside the container in _key=value_ format. |

## Environment Variables

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`ADMIN_USER_NAME` | No | User name for the built-in administrator account. |
|`ADMIN_USER_PASSWORD` | No | [Password](https://github.com/axibase/atsd-docs/blob/master/administration/user-authentication.md#password-requirements) for the built-in administrator.|
|`COLLECTOR_USER_NAME` | No | User name for a data collector account. |
|`COLLECTOR_USER_PASSWORD` | No | [Password](https://github.com/axibase/atsd-docs/blob/master/administration/user-authentication.md#password-requirements) for a data collector account.|
|`COLLECTOR_USER_TYPE` | No | User group for a data collector account, default value is `writer`.|
|`DB_TIMEZONE` | No | Database [timezone identifier](https://github.com/axibase/atsd/blob/master/api/network/timezone-list.md).|
|`JAVA_OPTS` | No | Additional arguments to be passed to ATSD JVM process. |
|`HADOOP_OPTS` | No | Additional arguments to be passed to Hadoop/HDFS JVM processes. |
|`HBASE_OPTS` | No | Additional arguments to be passed to HBase JVM processes. |

View additional launch examples [here](#start-container).

## Exposed Ports

* 8088 – http
* 8443 – https
* 8081 – [TCP network commands](../api/network#network-api)
* 8082 – [UDP network commands](../api/network#udp-datagrams)

## Port Mappings

Change port mappings in the launch command in case of port allocation error.

```sh
Cannot start container <container_id>: failed to create endpoint atsd on network bridge:
Bind for 0.0.0.0:8088 failed: port is already allocated
```

```properties
docker run -d --name=atsd \
  --publish 9088:8088 \
  --publish 9443:8443 \
  --publish 9081:8081 \
  --publish 9082:8082/udp \
  axibase/atsd:latest
```

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
