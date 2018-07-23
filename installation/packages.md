# Packages

## Quick Start

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
--recv-keys 26AEE425A57967CFB323846008796A6514F3CB79
```

```bash
sudo sh -c 'echo "deb [arch=amd64] http://axibase.com/public/repository/deb/ ./" \
  >> /etc/apt/sources.list.d/axibase.list'
```

```bash
sudo apt-get update && sudo apt-get install atsd
```

## Available Packages

| **Distribution** | **Format** | **Installation Guide** |
| :--- | --- | :---: |
| Ubuntu/Debian | apt | [View](./ubuntu-debian-apt.md)|
| Ubuntu/Debian | [deb](https://axibase.com/public/atsd_deb_latest.htm) | [View](./ubuntu-debian-deb.md) |
| RedHat/CentOS| yum | [View](./redhat-centos-yum.md)|
| RedHat/CentOS| [rpm](https://axibase.com/public/atsd_rpm_latest.htm) | [View](./redhat-centos-rpm.md)|
| SLES| [rpm](https://axibase.com/public/atsd_rpm_sles_latest.htm)   | [View](./sles-rpm.md)|
| Other | [tar.gz](https://axibase.com/public/atsd_distrib_latest.htm) | [View](./other-distributions.md)|