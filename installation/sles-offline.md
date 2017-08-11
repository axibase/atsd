# SUSE Linux Enterprise Server: Offline

## Overview

The installation process involves downloading dependencies to an intermediate machine with Internet access
and copying them to the target machine with similar characteristics for offline installation.

## Supported Versions

- SUSE Linux Enterprise Server 11 SP3
- SUSE Linux Enterprise Server 12.x

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Install Dependencies

### Option 1: Install Dependencies from Local Repositories.

```sh
sudo zypper -n install java-1_7_0-openjdk-devel sysstat which net-tools iproute
```

### Option 2: Copy Dependencies from a Connected Machine.

On a separate machine with internet access create a directory containing the dependencies:

```sh
mkdir ./sles_dependencies
cd sles_dependencies
```

Copy the following script to the `dep-download.sh`file and execute it to download the dependencies:

```sh
nano dep-download.sh
```

```sh
#!/bin/sh
SCRIPT=$(readlink -f $0)
DIR=$(dirname $SCRIPT)
list="java-1_7_0-openjdk-devel sysstat which net-tools iproute"
zypper -n install -df $list
for package in $list; do
    find /var/cache/zypp/packages -name $package*.rpm -exec cp {} $DIR \;
done
```

```sh
chmod a+x dep-download.sh
sudo ./dep-download.sh
```

Copy the folder containing the dependencies to the target machine and install them:

```sh
sudo zypper -n install sles_dependencies/*.rpm
```

## Install ATSD

Download the ATSD rpm package to the target machine:

* `curl -O https://axibase.com/public/atsd_ce_amd64.rpm`
* [https://axibase.com/public/atsd_ce_rpm_latest.htm](https://axibase.com/public/atsd_ce_rpm_latest.htm)

Follow the prompts to install ATSD:

```sh
 sudo zypper -n install atsd_ce_amd64.rpm
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
