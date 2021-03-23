# Axibase Time Series Database Installation

## Hardware Requirements

Review hardware and OS [requirements](./requirements.md) to ensure compatibility and high performance.

## Install On [Docker](docker.md)

```bash
docker run -d --name=atsd axibase/atsd:latest && docker logs -f atsd
```

After installation, review the [Getting Started Guide](../tutorials/getting-started.md) to explore ATSD features.

## Install On Linux

Install [Java 8](../administration/migration/install-java-8.md).

Download and unpack installation files.

```bash
curl -O https://www.axibase.com/public/atsd.standalone.latest.tar.gz
tar -xzf atsd.standalone.latest.tar.gz
```

Start the database.

```bash
./atsd/bin/atsd-tsd.sh start
```

## Install on Cluster

* [AWS Elastic MapReduce](./aws-emr-s3.md) (EMR) on AWS EMRFS and S3
* [Azure HDInsight](./azure-hdinsight.md) on  Azure Storage
* [Cloudera Distribution Hadoop](./cloudera.md) (CDH) on  HDFS

## Finance Edition

* [ATSD Finance Edition](../finance/install.md) installation guide.

## Technical Support

Contact us at `support-atsd@axibase.com` with any technical questions.

Attach [relevant details](../administration/support.md) to your ticket.
