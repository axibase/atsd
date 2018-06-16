# Installation: SLES

## Supported Versions

* SUSE Linux Enterprise Server 12.x

## Requirements

* Minimum RAM: 4 GB
* See [Requirements](../administration/requirements.md) for additional information.

## Connection

If the target server does not have Internet connection to download dependencies, use the [offline installation option](sles-offline.md).

## Download

Download the [`atsd_amd64_sles.rpm`](https://axibase.com/public/atsd_rpm_sles_latest.htm) package to the target server:

```sh
curl -O https://www.axibase.com/public/atsd_amd64_sles.rpm
```

## Installation Steps

Install ATSD with dependencies.

```sh
sudo zypper -n install atsd_amd64_sles.rpm
```

It may take up to 5 minutes to initialize the database.

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
