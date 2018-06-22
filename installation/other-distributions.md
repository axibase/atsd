# Installation: Other Distributions

## Requirements

* Minimum RAM: 4 GB
* See [Requirements](../administration/requirements.md) for additional information.

## Download

Download [`atsd-distrib.tar.gz`](https://axibase.com/public/atsd_distrib_latest.htm) archive to the target server.

```bash
curl -O https://www.axibase.com/public/atsd-distrib.tar.gz
```

## Installation

```sh
sudo tar -xzvf atsd-distrib.tar.gz -C /opt/
```

```sh
sudo /opt/atsd/install_sudo.sh
```

```sh
sudo /opt/atsd/install_user.sh
```

It can take up to 5 minutes to initialize the database.

## Check Installation

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

Watch for **ATSD start completed** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (https).

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
