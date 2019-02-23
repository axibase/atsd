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
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing
```

Extract the archive containing the distribution.

```powershell
Rename-Item ~/Ubuntu.appx ~/Ubuntu.zip
```

```powershell
Expand-Archive ~/Ubuntu.zip ~/Ubuntu
```

Open the Linux subsystem by running the `ubuntu.exe` executable.

```powershell
~/Ubuntu/ubuntu.exe
```

Follow the below steps to install ATSD on Linux.

## Download ATSD

While in the Linux terminal, download the ATSD `deb` package.

```bash
wget https://www.axibase.com/public/atsd_amd64.deb
```

### Update Repositories and Install Dependencies

```sh
sudo apt-get update && sudo apt-get install -y openjdk-8-jdk curl hostname net-tools iproute2 procps
```

### Install ATSD

Install the database by following the prompts.

```sh
sudo dpkg -i atsd_amd64.deb
```

Open another PowerShell terminal, login into WSL by executing `ubuntu.exe` and watch the database start process.

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

Check for **ATSD server started** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (HTTPS) at `https://localhost:8443/`.

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).