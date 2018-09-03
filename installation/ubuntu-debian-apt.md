# Installation: APT

## Supported Versions

* Ubuntu `16.04`, `18.04`
* Debian `8.x`, `9.x`

## Requirements

* Minimum RAM: `4` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Installation Process

### Add Repositories

<!-- markdownlint-enable MD032 -->
::: tip Debian `8.x`
Add `backports` repository to `/etc/apt/sources.list.d/backports.list` file.

```sh
deb http://ftp.debian.org/debian jessie-backports main
```

:::

::: tip Ubuntu `18.04`
Add the following line to `/etc/apt/sources.list` to enable [Java 8](https://packages.ubuntu.com/bionic/amd64/openjdk-8-jdk/download) packages.

```ls
deb http://security.ubuntu.com/ubuntu bionic-security main universe
```

:::
<!-- markdownlint-disable MD031 MD032 -->

### Update Repositories

```sh
sudo apt-get update
```

### Add ATSD Repository

Add `axibase.com/public/repository/deb/` repository

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
--recv-keys 26AEE425A57967CFB323846008796A6514F3CB79
```

```sh
sudo sh -c 'echo "deb [arch=amd64] http://axibase.com/public/repository/deb/ ./" \
>> /etc/apt/sources.list.d/axibase.list'
```

### Update Repositories and Install ATSD

Install ATSD.

```sh
sudo apt-get update && sudo apt-get install atsd
```

<!-- markdownlint-enable MD032 -->
::: tip On Debian `8.x`
```sh
sudo apt-get update && sudo apt-get -t jessie-backports install atsd
```
:::
<!-- markdownlint-disable MD032 -->

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