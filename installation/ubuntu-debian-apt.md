# Installation: APT

## Supported Versions

* Ubuntu `16.04`
* Debian `8.x`/`9.x`

## Requirements

* Minimum RAM: `2` GB
* See [Requirements](./requirements.md) for additional information.

## Installation Steps

### Add `backports` repository

**Required only for Debian 8.x (jessie).**

```sh
sudo sh -c 'echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/backports.list'
```

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

On Debian 8.x (jessie)

```sh
sudo apt-get update && sudo apt-get -t jessie-backports install atsd
```

It can take up to 5 minutes to initialize the database.

## Check Installation

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

Watch for **ATSD start completed** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (HTTPS).

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
