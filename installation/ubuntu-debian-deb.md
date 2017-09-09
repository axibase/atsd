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

#### Update Repositories and Install Dependencies

```sh
sudo apt-get update && sudo apt-get install -y openjdk-8-jdk curl hostname 
```

**Docker container installation:**

```sh
sudo apt-get update && sudo apt-get install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

#### Install ATSD

Follow the prompts to install ATSD:

```sh
sudo dpkg -i atsd_amd64.deb
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
