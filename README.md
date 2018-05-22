# Introduction

Axibase Time Series Database (ATSD) is a non-relational database optimized for collecting, storing, and analyzing temporal data from IT infrastructure, industrial equipment, smart meters, and IoT devices.

## The Origins

ATSD is developed by [Axibase Corporation](https://axibase.com/about-us/), established in 2004, based on our decade-long experience with IT infrastructure management systems. We wanted to build a specialized database with focus on data quality and where historical data was a first-class citizen. More specifically, ATSD was designed to overcome intrinsic issues with data warehouse systems backed by relational DBs such as [Tivoli DW](https://www.ibm.com/support/knowledgecenter/en/SS4EKN_7.2.0/com.ibm.itm.doc_6.3/install/tdw_overview.htm) which suffer from stale/invalid records and slow analytical queries due to lack of indexes.

A prototype was ready by June 2013 and an MVP was released in October 2013. The first licensed ATSD instance was delivered to a customer in mid-2014.

## Technology Stack

```elm
  ATSD
   |
  HBase
   |
  FileSystem: Ext4 / HDFS / Amazon S3
```

* ATSD is written in Java. It is supported on most Linux 64-bit distributions and requires a Java 8 runtime environment.
* Underneath ATSD is the [Apache HBase](https://hbase.apache.org/) which serves as the persistence layer for writing and reading key-values in the underlying file system.
* HBase is supported on local (`ext4`) and distributed file systems such as [HDFS](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html) and [Amazon S3](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-hbase.html).

ATSD can be installed from `deb` and `rpm` [packages](./installation#packages) or launched as a [container](./installation/docker.md#start-container).

```bash
docker run -d -p 8088:8088 -p 8443:8443 -p 8081:8081 \
  axibase/atsd:latest
```

## Compute Scalability

Single-node ATSD instance can process up to 200,000 metrics per second with millisecond accuracy and without numeric precision loss.

Compute scalability increases the system's write and read throughout (number of metrics inserted per second) and is achieved by adding **region servers** to the HBase cluster.

## Storage Footprint

Storage efficiency determines how many metrics and individual series can be stored overall in the system.

Compared to traditional databases, ATSD requires up to **50 times** less disk space. Refer to [compression tests](./administration/compaction#compression-tests) for more details.

Storage capacity can be scaled by adding data nodes to the underlying HDFS cluster. When ATSD is deployed on [AWS EMR](./installation/aws-emr-s3.md#installation-on-aws-hbase-s3), the storage capacity is right-sized automatically and independently of the processing capacity.

## Use Cases

* High-performance metrics backend.
* Consolidated statistics repository.
* Centralized monitoring system.
* EDM database.
* Data Lake component for time series data.
* Econometrics data store.

## Components

ATSD is a modular systems which includes the following components in addition to the core storage engine:

* [REST API](./api/data/README.md) Server
* [Network API](./api/network/README.md) Server
* [CSV Processor](./parsers/csv/README.md)
* [Rule Engine](./rule-engine/README.md)
* [SQL Engine](./sql/README.md)
* [Search Engine](./search/README.md)
* [Portal Server](./portals/README.md)

## Inserting Data

* Upload CSV
* Stream CSV
* Stream network commands via TCP/UDP
* Stream network commands with Kafka
* Insert data using REST API
* Use API clients or storage drivers
* Install pre-integrated collectors/agents
* Deploy Axibase Collector instance

## Line Protocols

The database provides its own compact line protocol for inserting high volumes of metrics with arbitrary dimensions which we call [network commands](api/network/README.md).

```bash
echo "series e:sns-001 m:temperature=15.4 m:rpm=302 t:panel=front" \
  > /dev/tcp/atsd_hostname/8081
```

The commands can be streamed into ATSD on ports `8081/tcp` and port `8082/udp`. Alternatively, the commands can be uploaded by posting them to the `/api/v1/command` REST API endpoint.

New objects and attributes are registered automatically and allow collecting data from different domain models in a single extensible schema.

The following protocols are supported for compatibility with external sources:

* `tcollector`
* `graphite`
* `statsd`
* `osisoft pi`

## Schema

The table schema in ATSD, displayed on the **Settings > Storage > Database Tables** page, is self-managed by the database and as such doesn't require changes when inserting data from different object types.

### Glossary

* `Entity` - Name of the object being monitored.
* `Metric` - Name of the numeric attribute describing the object.
* `Sample` - Timestamped metric value, `time:number`.
* `Series` - Sequence of Samples.
* `Tag` - Custom attribute describing the `Entity`, `Metric`, or `Series`, consists of a name and a value, `name:value`.

### Example

To store some temperature observations for bioreactor `BR1740` enclosure located at site `SVL2` in Sunnyvale, as well as room temperature at the same site, we might send the following commands into ATSD.

Metadata commands contain descriptive attributes and can be sent only once (or whenever these attributes change).

```elm
entity e:BR1740 t:type=Bioreactor t:city=Sunnyvale t:site=SVL2
entity e:SVL2   t:type=site       t:city=Sunnyvale
metric m:Temperature t:units=Celsius
```

The series commands carry the actual measurements and contain only those attributes that are necessary to identify the series.

```elm
series d:2018-05-20T00:15:00Z e:BR1740 m:Temperature=70.5 t:part=enclosure
series d:2018-05-20T00:15:00Z e:SVL2   m:Temperature=25.2
series d:2018-05-20T00:16:00Z e:BR1740 m:Temperature=72.5 t:part=enclosure
series d:2018-05-20T00:16:00Z e:SVL2   m:Temperature=25.1
...
```

By separating inserted data into metadata and time series data, each type of information can stored and processed separately and efficiently. At the same time, both types of data are readily available and efficiently joined when querying the records from the database.

```sql
SELECT datetime, value, entity, entity.tags.type
  FROM atsd_series
WHERE metric = 'Temperature'
  AND entity = 'BR1740'
  ORDER BY datetime
```

## Licensing

* ATSD provides a choice of licensing options.
* API clients and drivers are open-sourced under the Apache 2 license.

## Pricing

* Stand-alone ATSD installation is free.
* Axibase Collector instances are available at no cost.
* Licensing fee for distributed edition is based on the cluster size.
