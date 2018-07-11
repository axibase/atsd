# SUSE Linux Enterprise Server: Offline

## Overview

The installation process involves downloading dependencies to an intermediate server with Internet access
and copying them to the target server with similar characteristics for offline installation.

## Supported Versions

* SUSE Linux Enterprise Server 12.x

## Requirements

* Minimum RAM: 2 GB
* See [Requirements](../administration/requirements.md) for additional information.

## Check Dependencies

Check that required dependencies are present on the target server.

```sh
sudo zypper search -i java-1_8_0-openjdk-devel which net-tools iproute2
```

Verify that the dependencies are present.

```txt
S  | Name                     | Summary                                                     | Type
---+--------------------------+-------------------------------------------------------------+--------
i+ | iproute2                 | Linux network configuration utilities                       | package
i+ | java-1_8_0-openjdk-devel | OpenJDK 8 Development Environment                           | package
i  | net-tools                | Important Programs for Networking                           | package
i  | which                    | Displays where a particular program in your path is located | package
```

Install these dependencies if needed.

## Install ATSD

Download the [ATSD rpm package for SLES](https://axibase.com/public/atsd_rpm_sles_latest.htm) to the server with internet access.

```sh
curl -O https://axibase.com/public/atsd_amd64_sles.rpm
```

Copy the `atsd_amd64_sles.rpm` file to the target server and install ATSD.

```sh
sudo zypper -n install atsd_amd64_sles.rpm
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
