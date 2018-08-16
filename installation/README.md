# Axibase Time Series Database Installation

## Docker Images

[![](../images/docker2.png)](https://hub.docker.com/r/axibase/atsd/) [![](../images/redhat1.png)](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/atsd) [![](../images/kub.png)](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html)

* **Image Registry**: Docker Hub, RedHat Container Catalog, Kubernetes
* **Mode**: Non-Distributed
* **Edition**: Standard

[![](../images/install.png)](./images.md)

---

## Linux Packages

![](../images/redhat1.png) ![](../images/centos.png) ![](../images/ubuntu2.png) ![](../images/debian1.png) ![](../images/sles.png)

* **Supported Distributions**: RedHat, CentOS, Ubuntu, Debian, SLES
  * RPM/DEB Packages
  * `apt` / `yum` Repositories
* **Mode**: Non-Distributed
* **File System**: `ext4` (Local)
* **Edition**: Standard

[![](../images/install.png)](./packages.md)

---

## AWS EMRFS

![](../images/aws3.png) ![](../images/emrfs.png)

* **Mode**: Distributed
* **File System**: AWS S3
* **Edition**: Enterprise

[![](../images/install.png)](./aws-emr-s3.md)

---

## Cloudera Distribution Hadoop

![](../images/cloudera2.png) ![](../images/hadoop2.png)

* **Mode**: Distributed
* **File System**: HDFS
* **Edition**: Enterprise

[![](../images/install.png)](./cloudera.md)

---

## License

By installing Axibase Time Series Database you agree to the following **[License](../axibase_tsd_se_license.pdf)** terms.

## Hardware Requirements

Review [Requirements Specifications](./requirements.md) to ensure optimal functionality.

## Getting Started

After installation, review the [Getting Started Guide](../tutorials/getting-started.md) to begin exploring ATSD.

## Technical Support

Email Axibase at **support-atsd@axibase.com** with installation questions.
