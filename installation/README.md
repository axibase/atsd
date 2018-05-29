# Installation

## Requirements

* Linux 64-bit: Ubuntu 16.04, Debian 8.x/9.x, RHEL/CentOS 7.x, SLES 12.x.
* Operating system and hardware [requirements](../administration/requirements.md)

## Installation Guides

### Container Images

Quick start:

```bash
docker run -d --name=atsd \
  -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  axibase/atsd:latest
```

| **Distribution** | **Format** | **Installation Guide** |
| :--- | --- | :---: |
| Docker | official image | [View](docker.md)|
| RedHat Docker | certified image | [View](docker-redhat.md)|
| Kubernetes | official image | [View](https://github.com/axibase/axibase-collector/blob/master/installation-on-kubernetes.md)|

### Packages

Quick start:

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

Available packages:

| **Distribution** | **Format** | **Installation Guide** |
| :--- | --- | :---: |
| Ubuntu/Debian | apt | [View](ubuntu-debian-apt.md)|
| Ubuntu/Debian | [deb](https://axibase.com/public/atsd_deb_latest.htm) | [View](ubuntu-debian-deb.md) |
| RedHat/CentOS| yum | [View](redhat-centos-yum.md)|
| RedHat/CentOS| [rpm](https://axibase.com/public/atsd_rpm_latest.htm) | [View](redhat-centos-rpm.md)|
| SLES| [rpm](https://axibase.com/public/atsd_rpm_sles_latest.htm)   | [View](sles-rpm.md)|
| Other | [tar.gz](https://axibase.com/public/atsd_distrib_latest.htm) | [View](other-distributions.md)|

### Cloud

| **Hadoop Distribution** | **Installation Guide** |
| :--- | :--- |
| HBase on AWS S3  | [View](aws-emr-s3.md)|

### Hadoop Cluster

| **Hadoop Distribution** | **Installation Guide** |
| :--- | :--- |
| Cloudera Distribution Hadoop (CDH)  | [View](cloudera.md) |

## Installing Updates

* Review [Change Log](../changelogs/README.md)
* Refer to [Update Guide](../administration/update.md)

## Technical Support

Email us at **support-atsd@axibase.com** in case of installation questions.

## License

By installing Axibase Time Series Database Standard Edition you agree to the following **[License](../axibase_tsd_se_license.pdf)** terms.

## Tutorials

* [Getting Started Guide](../tutorials/getting-started.md)

## Documentation

* [Documentation](https://axibase.com/docs/atsd)

## Uninstalling ATSD

* Refer to [Documentation](uninstalling.md)