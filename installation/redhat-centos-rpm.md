# RedHat/CentOS: rpm Package

## Supported Versions

- RedHat Enterprise Linux 7.x
- CentOS 7.x
- Amazon Linux 2014.09.x+

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Configuration

The database will be installed in `/opt/atsd` directory under `axibase` user.

To customize the installation directory, specify `--prefix` option as described below.

## Connection

If the target machine does not have Internet connection to download
dependencies, use the [offline installation option](redhat-centos-offline.md).

## Download

Download the rpm package to the target server:

* `curl -O https://www.axibase.com/public/atsd_amd64.rpm`
* [https://axibase.com/public/atsd_rpm_latest.htm](https://axibase.com/public/atsd_rpm_latest.htm)

## Installation Steps

Install ATSD with dependencies:

```sh
sudo yum install -y atsd_amd64.rpm
```

It may take up to 5 minutes to initialize the database.

## Custom Installation Directory

Install ATSD dependencies:

```sh
sudo yum install java-1.8.0-openjdk-devel which curl net-tools iproute
```

Install ATSD in a custom directory by specifying `--prefix` parameter:

```sh
sudo rpm -Uvh --prefix=/mnt/atsd atsd_amd64.rpm
```

> ATSD cannot be installed in a `/home/user` directory other than `/home/axibase` due to permission issues.

## Check Installation

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

You should see an **ATSD start completed** message at the end of the `start.log`.

Web interface is accessible on port 8088 (http) and 8443 (https).

> Add [firewall](firewall.md) rules if the above ports are not reachable.

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
