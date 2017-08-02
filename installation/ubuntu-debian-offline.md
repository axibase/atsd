# Ubuntu/Debian: Offline

## Overview

The installation process involves downloading dependencies to an intermediate machine with Internet access
and copying them to the target machine with similar characteristics for offline installation.

## Supported Versions

- Ubuntu 14.x
- Ubuntu 15.x
- Debian 6.x
- Debian 7.x

## Requirements

- Minimum RAM: 1 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Installation Steps

Enable the **axibase.com/public/repository/deb/** repository on the machine with Internet access:

```sh
sudo apt-get update
```

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
--recv-keys 26AEE425A57967CFB323846008796A6514F3CB79
```

```sh
sudo sh -c 'echo "deb [arch=amd64] http://axibase.com/public/repository/deb/ ./" \
>> /etc/apt/sources.list.d/axibase.list'
```

Download the ATSD package, including its dependencies, to the `atsd_with_dependencies` directory.

```
sudo apt-get update
mkdir atsd_with_dependencies
cd atsd_with_dependencies
apt-get --print-uris --yes install atsd | grep ^\' | cut -d\' -f2 | xargs wget
```

Copy the `atsd_with_dependencies` directory to the target machine where ATSD will be installed.

Install dependencies:

```sh
sudo dpkg -i atsd_with_dependencies/*
```

Follow the prompts to install ATSD:

```sh
sudo dpkg -i atsd_with_dependencies/atsd*
```

It may take up to 5 minutes to initialize the database.

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
