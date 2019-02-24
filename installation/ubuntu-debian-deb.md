# Installation: deb Package

## Supported Versions

* Ubuntu `16.04`, `18.04`
* Debian `8.x`, `9.x`

## Requirements

* Minimum RAM: `4` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Check Connection

If the target server is not connected to public repositories to install dependencies with APT,
use the [Offline Installation Guide](ubuntu-debian-offline.md) to complete installation.

## Installation Steps

### Add Repositories

* Required for Ubuntu 18.04

::: tip Ubuntu 18.04
Add `bionic-security` repository to `/etc/apt/sources.list` to enable [Java 8](https://packages.ubuntu.com/bionic/amd64/openjdk-8-jdk/download) packages.

```ls
sudo sh -c 'echo deb http://security.ubuntu.com/ubuntu bionic-security main universe >> /etc/apt/sources.list'
```

:::

* Required for Debian 8.x

::: tip Debian 8.x
Add `backports` repository to `/etc/apt/sources.list.d/backports.list` file.

```sh
sudo sh -c 'echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/backports.list'
```

:::

### Update Repositories and Install Dependencies

```sh
sudo apt-get update
```

### Install Dependencies

Install Java 8 and the necessary network utilities.

```sh
sudo apt-get install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

## Download ATSD Package

Download the latest ATSD `deb` package.

```bash
wget https://www.axibase.com/public/atsd_amd64.deb
```

> The latest ATSD `deb` packages with version numbers are listed on [`https://axibase.com/public/atsd_deb_latest.htm`](https://axibase.com/public/atsd_deb_latest.htm).

### Install ATSD

```sh
sudo dpkg -i atsd_amd64.deb
```

It can take up to five minutes to initialize the database.

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