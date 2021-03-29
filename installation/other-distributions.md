# Installation: Other Distributions

## Requirements

* Minimum RAM: `4` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Download

Download [`atsd-distrib.tar.gz`](https://axibase.com/public/atsd_distrib_latest.htm) tarball archive to the target server.

```bash
curl -O https://www.axibase.com/public/atsd-distrib.tar.gz
```

## Installation Commands

```sh
sudo tar -xozvf atsd-distrib.tar.gz -C /opt/
```

```sh
sudo /opt/atsd/install_sudo.sh
```

```sh
sudo /opt/atsd/install_user.sh
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
