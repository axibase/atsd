# Installation: RedHat Certified Container

## Host Requirements

* Docker Engine 1.12+.

Install Docker:

```sh
yum install docker device-mapper-libs device-mapper-event-libs
```

```sh
systemctl start docker.service
```

```sh
systemctl enable docker.service
```

## RedHat Container Catalog

* [Axibase Time Series Database](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/atsd)
  * Image name: `registry.connect.redhat.com/axibase/atsd`
  * Base: atsd:latest
  * [Dockerfile](https://github.com/axibase/dockers/blob/atsd-rhel7/Dockerfile)

* [Axibase Collector](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/collector)
  * Image name: `registry.connect.redhat.com/axibase/collector`
  * Base: atsd:collector
  * [Dockerfile](https://github.com/axibase/docker-axibase-collector/blob/rhel7/Dockerfile)

## Start Container

```bash
docker run -d  --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  registry.connect.redhat.com/axibase/atsd:latest
```

To automatically create an [account](../administration/collector-account.md) for data collection agents and storage drivers, replace `cuser` and `cpassword` credential variables in the command below.

```bash
docker run -d --name=atsd -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  --env COLLECTOR_USER_NAME=cuser \
  --env COLLECTOR_USER_PASSWORD=cpassword \
  --env COLLECTOR_USER_TYPE=api-rw \
  registry.connect.redhat.com/axibase/atsd:latest
```

The password is subject to the following [requirements](../administration/user-authentication.md#password-requirements). If the credentials contain special characters `$`, `&`, `#`, or `!`, escape them with backslash `\`.

## Start Container

Launch the container with `docker run`.

```txt
$ docker run \
>   --detach \
>   --name=atsd \
>   --publish 8088:8088 \
>   --publish 8443:8443 \
>   --publish 8081:8081 \
>   --publish 8082:8082/udp \
>   registry.connect.redhat.com/axibase/atsd:latest
Unable to find image 'axibase/atsd:latest' locally
latest: Pulling from axibase/atsd
bf5d46315322: Pull complete
9f13e0ac480c: Pull complete
e8988b5b3097: Pull complete
40af181810e7: Pull complete
e6f7c7e5c03e: Pull complete
ca48528e7708: Pull complete
de225e971cf6: Pull complete
6a3419ba188d: Pull complete
Digest: sha256:f2c2957b1ffc8dbb24501495e98981899d2b018961a7742ff6adfd4f1e176429
Status: Downloaded newer image for axibase/atsd:latest
14d1f27bf0c139027b5f69009c0c5007d35be92d61b16071dc142fbc75acb36a
```

It may take up to 5 minutes to initialize the database.

## Check Installation

```bash
docker logs -f atsd
```

You should see an `ATSD start completed` message at the end of the `start.log` file.

```txt
...
 * [ATSD] Starting ATSD ...
 * [ATSD] ATSD not running.
 * [ATSD] ATSD java version "1.7.0_111"
 * [ATSD] Waiting for ATSD to start. Checking ATSD web-interface port 8088 ...
 * [ATSD] Waiting for ATSD to bind to port 8088 ...( 1 of 20 )
...
 * [ATSD] Waiting for ATSD to bind to port 8088 ...( 11 of 20 )
 * [ATSD] ATSD web interface:
 * [ATSD] http://172.17.0.2:8088
 * [ATSD] https://172.17.0.2:8443
 * [ATSD] ATSD start completed.
```

The ATSD web interface is accessible on port 8088/http and 8443/https.

## Launch Parameters

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`--detach` | Yes | Run container in background and print container id. |
|`--hostname` | No | Assign hostname to the container. |
|`--name` | No | Assign a unique name to the container. |
|`--restart` | No | Auto-restart policy. _Not supported in all Docker Engine versions._ |
|`--publish` | No | Publish a container's port to the host. |

## Environment Variables

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`--env ADMIN_USER_NAME` | No | User name for the built-in administrator account. |
|`--env ADMIN_USER_PASSWORD` | No | [Password](../administration/user-authentication.md#password-requirements) for the built-in administrator.|
|`--env COLLECTOR_USER_NAME` | No | User name for a data collector account. |
|`--env COLLECTOR_USER_PASSWORD` | No | [Password](../administration/user-authentication.md#password-requirements) for a data collector account.|
|`--env COLLECTOR_USER_TYPE` | No | User group for a data collector account, default value is `writer`.|
|`--env DB_TIMEZONE` | No | Database [time zone identifier](../shared/timezone-list.md).|

View additional launch examples [here](https://github.com/axibase/atsd-docs/blob/master/installation/docker.md#option-1-configure-collector-account-automatically).

## Exposed Ports

* 8088 – http
* 8443 – https
* 8081 – [TCP network commands](../api/network#network-api)
* 8082 – [UDP network commands](../api/network#udp-datagrams)

## Port Mappings

Depending on your Docker host network configuration, you may need to change port mappings in case some of the published ports are already taken.

```txt
Cannot start container <container_id>: failed to create endpoint atsd on network bridge:
Bind for 0.0.0.0:8088 failed: port is already allocated
```

```bash
docker run -d \
  --name=atsd \
  --publish 9088:8088 \
  --publish 9443:8443 \
  --publish 9081:8081 \
  --publish 9082:8082/udp \
  registry.connect.redhat.com/axibase/atsd:latest
```

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
