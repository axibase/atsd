# ATSD Installation

## Download Options

### [Docker Images](./images.md)

![](../images/docker2.png) ![](../images/redhat1.png) ![](../images/kub.png)

* [Docker Hub](https://hub.docker.com/r/axibase/atsd/), [RedHat Container Catalog](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/atsd), [Kubernetes](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html)
* Mode: Non-Distributed
* Edition: Standard
* Separate [Images](https://github.com/axibase/dockers/blob/master/README.md#axibase-time-series-database) and [Sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#atsd-sandbox-docker-image)

### [Linux Packages](./packages.md)

![](../images/redhat1.png) ![](../images/centos.png) ![](../images/ubuntu2.png) ![](../images/debian1.png) ![](../images/sles.png)

* RPM/DEB Packages
* Supported Distributions: RedHat, CentOS, Ubuntu, Debian, SLES
* `apt` / `yum` Repository Option
* Mode: Non-Distributed
* File System: `ext4` (local)
* Edition: Standard

### [AWS EMRFS](./aws-emr-s3.md)

![](../images/aws3.png) ![](../images/emrfs.png)

* Mode: Distributed
* File System: AWS S3
* Edition: Enterprise

### [Cloudera Distribution Hadoop](./cloudera.md) (CDH)

![](../images/cloudera.png) ![](../images/hadoop2.png)

* Mode: Distributed
* File System: HDFS
* Edition: Enterprise

> By installing ATSD you agree to the following **[License](../axibase_tsd_se_license.pdf)** terms.

### Hardware Requirements

Review [Requirements Specifications](./requirements.md) to ensure optimal functionality.

### Getting Started

After installation, review the [Getting Started Guide](../tutorials/getting-started.md) to begin exploring ATSD.

### Technical Support

Email Axibase at **support-atsd@axibase.com** with installation questions.
