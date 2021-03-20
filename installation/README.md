# Axibase Time Series Database Installation

## Quick Start

On Linux 64-bit distributions:

```bash
curl -O https://www.axibase.com/public/atsd.standalone.latest.tar.gz
tar -xzf atsd.standalone.latest.tar.gz
./atsd/bin/atsd-tsd.sh start
```

On [Docker](docker.md):

```bash
docker run -d --name=atsd axibase/atsd:latest && docker logs -f atsd
```

After installation, review the [Getting Started Guide](../tutorials/getting-started.md) to explore ATSD features.

## Hardware Requirements

Review hardware and OS [requirements](./requirements.md) to ensure compatibility and high performance.

## Clusters

### AWS Elastic MapReduce (EMR)

* **Mode**: Distributed
* **File System**: AWS EMRFS / S3
* **Edition**: Enterprise

[Install](./aws-emr-s3.md)

---

### Azure HDInsight

* **Mode**: Distributed
* **File System**: Azure Storage
* **Edition**: Enterprise

[Install](./azure-hdinsight.md)

---

### Cloudera Distribution Hadoop

* **Mode**: Distributed
* **File System**: HDFS
* **Edition**: Enterprise

[Install](./cloudera.md)

---

## Technical Support

Contact us at `support-atsd@axibase.com` with any technical questions.

Attach [relevant details](../administration/support.md) to your ticket.
