# Sender User

This document describes how to create an `atsdreadonly` user on the ATSD server.

## Create user

On RHEL:

```bash
sudo adduser atsdreadonly
```

On Ubuntu:

```bash
sudo adduser --disabled-password --quiet atsdreadonly
```

On SLES:

```bash
sudo useradd atsdreadonly
```

```bash
sudo mkdir /home/atsdreadonly
```

```bash
sudo chown atsdreadonly /home/atsdreadonly
```

## Generate  SSH Key

Change to `atsdreadonly` user.

```bash
sudo su atsdreadonly
```

Generate SSH key. Accept the default key path and do not enter any pass-phrase.

```bash
ssh-keygen -t rsa
```

Copy the file to authorized keys for SSH connectivity.

```bash
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
```

## Deploy Key

Copy the `~/.ssh/id_rsa` key generated in the previous step to `/opt/nmon` on the remote system.
