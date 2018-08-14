# Installation: RPM

## Supported Versions

* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* Amazon Linux `2014.09.x+`

## Requirements

* Minimum RAM: `2` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Configuration

The database is installed in `/opt/atsd` directory under `axibase` user.

To customize the installation directory, specify `--prefix` as [described below](#custom-installation-directory).

## Connection

If the target server does not have Internet connection to download
dependencies, follow the [Offline Installation Guide](redhat-centos-offline.md).

## Download

Download the `rpm` package to the target server:

```bash
curl -O https://www.axibase.com/public/atsd_amd64.rpm
```

Alternatively, distribution files are published at [`https://axibase.com/public/atsd_rpm_latest.htm`](https://axibase.com/public/atsd_rpm_latest.htm).

## Installation Steps

Install ATSD with dependencies:

```sh
sudo yum install -y atsd_amd64.rpm
```

It can take up to five minutes to initialize the database.

### Custom Installation Directory

Follow these steps to install ATSD in a custom directory, other than the default `/opt/atsd`.

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

Watch for **ATSD start completed** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (HTTPS).

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
