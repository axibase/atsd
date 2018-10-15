# Axibase Time Series Database Installation

## Hardware Requirements

Review hardware and OS [requirements](./requirements.md) to ensure compatibility and optimal performance.

## License

By installing Axibase Time Series Database you agree to the following **[License](../axibase_tsd_se_license.pdf)** terms.

After the trial period, ATSD requires an [active subscription](../pricing.md) or a perpetual license for proper functioning.

You can request a new license on the **Settings > License** page.

---

## Container Images

[![](../images/docker2.png)](https://hub.docker.com/r/axibase/atsd/) [![](../images/redhat1.png)](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/atsd) [![](../images/kub.png)](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html)

* **Image Registry**: Docker Hub, RedHat Container Catalog, Kubernetes
* **Mode**: Non-Distributed
* **Edition**: Standard

[![](../images/install.png)](./images.md)

---

## Linux Packages

![](../images/redhat1.png) ![](../images/centos.png) ![](../images/ubuntu2.png) ![](../images/debian1.png) ![](../images/suse-logo-4.png)

* **Supported Distributions**: RedHat, CentOS, Ubuntu, Debian, SLES
  * RPM/DEB Packages
  * `apt` / `yum` Repositories
* **Mode**: Non-Distributed
* **File System**: `ext4` (Local)
* **Edition**: Standard

[![](../images/install.png)](./packages.md)

---

## AWS Elastic MapReduce (EMR)

![](../images/aws-logo-4.png) ![](../images/emrfs-2.png)

* **Mode**: Distributed
* **File System**: AWS EMRFS / S3
* **Edition**: Enterprise

[![](../images/install.png)](./aws-emr-s3.md)

---

## Cloudera Distribution Hadoop

![](../images/cloudera-5.png) ![](../images/hadoop2.png)

* **Mode**: Distributed
* **File System**: HDFS
* **Edition**: Enterprise

[![](../images/install.png)](./cloudera.md)

---

## Getting Started

After installation, review the [Getting Started Guide](../tutorials/getting-started.md) to explore ATSD features.

---

## Technical Support

Contact us at `support-atsd@axibase.com` with installation questions.

Attach [relevant details](../administration/support.md) to your ticket.
