# Ubuntu/Debian: APT

## Supported Versions

- Ubuntu 16.04
- Debian 8.x/9.x

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Installation Steps

#### Add backports repository

This step is required only for Debian 8.x (jessie)

```sh
sudo sh -c 'echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/backports.list'
```

#### Update Repositories

```sh
sudo apt-get update
```

#### Add `axibase.com/public/repository/deb/` Repository

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
--recv-keys 26AEE425A57967CFB323846008796A6514F3CB79
```

```sh
sudo sh -c 'echo "deb [arch=amd64] https://axibase.com/public/repository/deb/ ./" \
>> /etc/apt/sources.list.d/axibase.list'
```

#### Update Repositories and Install ATSD

Install HTTPS transport support for APT

```sh
sudo apt-get install apt-transport-https
```

Follow the prompts to install ATSD:

On Ubuntu 16.04 and Debian 9.x (stretch)

```sh
sudo apt-get update && sudo apt-get install atsd
```

On Debian 8.x (jessie)

```sh
sudo apt-get update && sudo apt-get -t jessie-backports install atsd
```

It may take up to 5 minutes to initialize the database.

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
