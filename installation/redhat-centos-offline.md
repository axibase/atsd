# RedHat/CentOS: Offline

## Overview

The installation process involves downloading dependencies to an intermediate machine with Internet access
and copying them to the target machine with similar characteristics for offline installation.

## Supported Versions

- RedHat Enterprise Linux 7.x
- CentOS 7.x

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Configuration

The database will be installed in `/opt/atsd` directory under `axibase` user.

To customize the installation directory, specify `--prefix` option as described below.

## Installation Steps

Download the ATSD rpm package to an intermediate machine with Internet access:

* `curl -O https://www.axibase.com/public/atsd_amd64.rpm`
* [https://axibase.com/public/atsd_rpm_latest.htm](https://axibase.com/public/atsd_rpm_latest.htm)

Download the ATSD dependencies to an intermediate machine with connected repositories:

```sh
sudo yum install -y yum-utils
```

```sh
sudo yumdownloader --resolve java-1.8.0-openjdk-devel which hostname net-tools iproute
```

> See the RedHat [note](https://access.redhat.com/solutions/10154) on using yum to download packages without installation.

> If some of the above dependencies are not found, for example in case of installation on new systems, run `sudo yum update` to upgrade all packages on your operating system to the latest versions.

Copy the downloaded *.rpm packages to the target machine and install them as follows:

```sh
sudo yum install -y ./folder_with_dependencies/*
```

Follow the prompts to install ATSD:

```sh
sudo yum install -y atsd_amd64.rpm
```

It may take up to 5 minutes to initialize the database.

## Custom Installation Directory

To install ATSD in a custom directory, specify `--prefix` parameter:

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

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
