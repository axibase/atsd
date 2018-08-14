# Packages

## Supported Linux Distributions

### **Ubuntu**

 Version | `apt` | `deb` | Installation Guide
|--|--|--|--|--|--|--|
| `16.04` | ![](../images/ok.svg) | [![](../images/ok.svg)]((https://axibase.com/public/atsd_deb_latest.htm)) |  [`apt`](./ubuntu-debian-apt.md) / [`deb`](./ubuntu-debian-deb.md)

### **Debian**

 Version | `apt` | `deb` | Installation Guide
|--|--|--|--|--|--|--|
`8.x` / `9.x` | ![](../images/ok.svg) | [![](../images/ok.svg)]((https://axibase.com/public/atsd_deb_latest.htm)) |  [`apt`](./ubuntu-debian-apt.md) / [`deb`](./ubuntu-debian-deb.md)

### **RHEL** / **CentOS**

Version | `rpm` | `yum` | Installation Guide
--|--|--|--|--|--|
 `7.x`| ![](../images/ok.svg) | [![](../images/ok.svg)](https://axibase.com/public/atsd_rpm_sles_latest.htm) | [`yum`](./redhat-centos-yum.md) / [`rpm`](./redhat-centos-rpm.md)

### **SLES**

Version | `rpm` | `yum` | Installation Guide
--|--|--|--|--|--|
`12.x` | [![](../images/ok.svg)](https://axibase.com/public/atsd_rpm_sles_latest.htm) | | [`rpm`](./sles-rpm.md)

### Other Distributions

For other Linux distributions, follow the [Installation Guide](./other-distributions.md).

### Quick Start

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