# Installation: Microsoft Windows

## Supported Versions

* Windows Server 2019

## Requirements

* Minimum RAM: `8` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Overview

The procedure enables Windows Subsystem for Linux (WSL) and installs ATSD as an Ubuntu package.

## Install Windows Subsystem for Linux

Open PowerShell as administrator and turn on [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-on-server).

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Restart the server when prompted.

## Install Linux Distribution

Download [Ubuntu 16.04](https://docs.microsoft.com/en-us/windows/wsl/install-manual) distribution.

```powershell
curl.exe -L -o ubuntu1604.zip https://aka.ms/wsl-ubuntu-1604
```

Extract the archive containing the distribution.

```powershell
Expand-Archive ubuntu1604.zip ubuntu1604
```

Open the Linux subsystem by running the `ubuntu.exe` executable.

```powershell
./ubuntu1604/ubuntu.exe
```

When accessing WSL for the first time, the system prompts you to create a UNIX account with administrative privileges (member of `sudo` group). Enter `axibase`/`axibase` or other credentials to proceed with the installation.

:::tip Linux Versions
If the installed Linux version is not Ubuntu 16.04, refer to the corresponding installation [instructions](./packages.md).
:::

### Update Repositories

```sh
sudo apt-get update
```

### Install Dependencies

Install Java 8 and the necessary network utilities.

```sh
sudo apt-get install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

## Download ATSD Package

Download the ATSD `deb` package.

```bash
wget https://www.axibase.com/public/atsd_amd64.deb
```

> The latest ATSD `deb` packages with version numbers are listed on [`https://axibase.com/public/atsd_deb_latest.htm`](https://axibase.com/public/atsd_deb_latest.htm).

### Install ATSD

Install the database by following the prompts. Select `<Yes>` to enable auto-start.

```sh
sudo dpkg -i atsd_amd64.deb
```

The installation script completes with the following messages:

```txt
[ATSD] ATSD user interface:
[ATSD] http://10.0.0.5:8088
[ATSD] https://10.0.0.5:8443
[ATSD] ATSD start completed. Time: 2019-02-22 11:00:00.
[ATSD] -- complete --
[ATSD] All steps completed.
[ATSD] Current user: root.
```

Watch the database start-up progress using `atsd.log` log file.

```sh
tail -F /opt/atsd/atsd/logs/atsd.log
```

Check for **ATSD server started** message at the end of the `atsd.log`.

```txt
2019-02-22 11:00:00,000;INFO;main;com.axibase.tsd.Server;ATSD server started
```

Web interface is now accessible on port `8443` (HTTPS) at `https://localhost:8443/`.

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

The Linux file system is available in the `./ubuntu1604/rootfs/` directory.

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).