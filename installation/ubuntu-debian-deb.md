# Ubuntu/Debian: Debian Package

## Supported Versions

- Ubuntu 16.04
- Debian 8.x/9.x

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Check Connection

If the target machine is not connected to public repositories to install dependencies with APT,
use the [offline installation option](ubuntu-debian-offline.md).

## Download

Download deb package to the target server:

* `wget https://www.axibase.com/public/atsd_amd64.deb`
* [https://axibase.com/public/atsd_deb_latest.htm](https://axibase.com/public/atsd_deb_latest.htm)

## Installation Steps

#### Add backports repository

This step is required only for Debian 8.x (jessie)

```sh
sudo sh -c 'echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/backports.list'
```

#### Update Repositories and Install Dependencies

```sh
sudo apt-get update && sudo apt-get install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

On Debian 8.x (jessie)

```sh
sudo apt-get update && sudo apt-get -t jessie-backports install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

#### Install ATSD

Follow the prompts to install ATSD:

```sh
sudo dpkg -i atsd_amd64.deb
```

It may take up to 5 minutes to initialize the database.

#### Docker Container Installation

If the installation is performed in a Docker container, the `dpkg` command will exit with the following message:

```
Docker container installation. Initialization deferred.
```

Execute the following additional step to complete the installation:

```sh
/opt/atsd/install_user.sh
```

Start the database:

```sh
/opt/atsd/bin/atsd-all.sh start
```

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
