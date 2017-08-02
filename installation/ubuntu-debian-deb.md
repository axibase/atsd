# Ubuntu/Debian: Debian Package

## Supported Versions

- Ubuntu 14.04
- Ubuntu 16.04
- Debian 6.x
- Debian 7.x

## Requirements

- Minimum RAM: 1 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Check Connection

If the target machine is not connected to public repositories to install dependencies with APT,
use the [offline installation option](ubuntu-debian-offline.md).

## Download

Download deb package to the target server:

* `wget https://www.axibase.com/public/atsd_ce_amd64.deb`
* [https://axibase.com/public/atsd_ce_deb_latest.htm](https://axibase.com/public/atsd_ce_deb_latest.htm)

## Installation Steps

#### Add `openjdk` Repository

This step is required **only on Ubuntu 16.04** (Xenial Xerus).

```sh
sudo add-apt-repository ppa:openjdk-r/ppa
```

#### Update Repositories and Install Dependencies

```sh
sudo apt-get update && sudo apt-get install -y openjdk-7-jdk sysstat curl hostname
```

> If there are any issues with installing the dependencies, [check the repositories](modifying-ubuntu-debian-repositories.md) and retry the command.

#### Follow the Prompts to Install ATSD

```sh
sudo dpkg -i atsd_ce_amd64.deb
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
