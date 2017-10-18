# Ubuntu/Debian: Offline

## Overview

The installation process involves downloading dependencies (deb packages) to an intermediate machine with Internet access
and copying them to the target machine for offline installation.

## Supported Versions

- Ubuntu 16.04
- Debian 8.x/9.x

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Installation Steps

Add jessie-backports repository. This command is required only for Debian 8.x (jessie).

```sh
sudo sh -c 'echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/backports.list'
```

Enable the `axibase.com/public/repository/deb/` repository on the machine with Internet access:

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

Update the repository.

```sh
sudo apt-get update
```

Download the ATSD package, including its dependencies, to the `dependencies` directory.

```bash
mkdir ~/dependencies
cd ~/dependencies
apt-get download atsd $(apt-cache depends --recurse --no-recommends --no-suggests \
  --no-conflicts --no-breaks --no-replaces --no-enhances \
  atsd | grep "Depends" | cut -d ":" -f2 | grep "^\ \w" | grep -v file-rc)
```

Download newer `ca-certificates-java`. This step is required only for Debian 8.x (jessie).

```bash
rm ca-certificates-java*
apt-get -t jessie-backports download ca-certificates-java
```
Make sure that the download directory isn't empty:

```bash
...
libtinfo5_5.9+20140913-1+b1_amd64.deb
lsb-base_4.1+Debian13+nmu1_all.deb
mount_2.25.2-6_amd64.deb
net-tools_1.60-26+b1_amd64.deb
procps_2%3a3.3.9-9_amd64.deb
sensible-utils_0.0.9_all.deb
startpar_0.59-3_amd64.deb
sysvinit-utils_2.88dsf-59_amd64.deb
sysv-rc_2.88dsf-59_all.deb
zlib1g_1%3a1.2.8.dfsg-2+b1_amd64.deb
```

Copy the `dependencies` directory to the target machine where ATSD will be installed.

Install dependencies.

```bash
ls dependencies/* | grep -v "atsd*" | xargs sudo dpkg -i
```

Sample output:

```bash
...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for install-info (6.1.0.dfsg.1-5) ...
Processing triggers for ureadahead (0.100.0-19) ...
Processing triggers for systemd (229-4ubuntu19) ...
Processing triggers for libc-bin (2.23-0ubuntu9) ...
Processing triggers for mime-support (3.59ubuntu1) ...
```

Install ATSD.

```bash
sudo dpkg -i dependencies/atsd*
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
