# Introduction

**Axibase Time Series Database** is a non-relational database optimized for collecting, storing, and analyzing temporal data from IT infrastructure, industrial equipment, smart meters, and IoT devices.

![](./images/atsd-title.png)

## Technology Stack

ATSD requires a Java 8 runtime environment and is supported on major Linux distributions in 64-bit mode.

ATSD relies on [Apache HBase](https://hbase.apache.org/) as a distributed key-value store and can be deployed on top of file systems such as [Hadoop Distributed File System](./installation/cloudera.md) (HDFS), [Amazon EMRFS](./installation/aws-emr-s3.md), and `ext4`(local).

![](./images/technology-stack-image.png)

## Compute Scalability

A single-node ATSD instance can process up to 200,000 metrics per second with millisecond accuracy and handle out-of-order sample writes without any loss of numeric precision.

The number of metrics inserted per second can be increased by adding region servers to the underlying HBase cluster.

## Storage Scalability

Storage efficiency ultimately determines how many metrics and individual series can be stored in the system.

Compared to traditional databases, ATSD requires up to **50 times** less disk space. Refer to [compression tests](./administration/compaction/README.md) for more details.

The storage capacity can be scaled by adding data nodes to the underlying HDFS cluster. With ATSD on [AWS EMR](./installation/aws-emr-s3.md), storage capacity is right-sized automatically, independent of  processing capacity.

## Use Cases

* High-performance metrics backend.
* Consolidated statistics repository.
* Centralized monitoring system.
* EDM database.
* Data Lake component for time series data.
* Econometrics data store.

## Components

ATSD is a modular systems which includes the following components in addition to the core storage engine:

* [Rule Engine](./rule-engine/README.md)
* [SQL Engine](./sql/README.md)
* [Portal Server](./portals/README.md)
* [Charts Library](https://github.com/axibase/charts)
* [Search Service](./search/README.md)
* [REST API](./api/data/README.md) Server
* [Network API](./api/network/README.md) Server
* [CSV Processor](./parsers/csv/README.md)

## Inserting Data

* Upload CSV.
* Stream CSV.
* Stream network commands via TCP/UDP.
* Stream network commands with Kafka.
* Insert data using REST API.
* Insert rows using [JDBC driver](https://github.com/axibase/atsd-jdbc/blob/master/insert.md).
* Use API clients or storage drivers.
* Install pre-integrated collectors/agents.
* Deploy [Axibase Collectors](https://axibase.com/docs/axibase-collector/) to copy data from relational databases, plant historians, and IT infrastructure using open and proprietary protocols.

## Line Protocols

ATSD provides an optimized line protocol to insert high volumes of metrics with user-defined dimensions called [network commands](api/network/README.md).

```bash
echo "series e:sns-001 m:temperature=15.4 m:rpm=302 t:panel=front" \
  > /dev/tcp/atsd_hostname/8081
```

The commands can be streamed into ATSD on ports `8081/tcp`, `8082/udp` or uploaded to the [`/api/v1/command`](api/data/ext/command.md) REST API endpoint.

The following protocols are supported for extended compatibility:

* [`tcollector`](api/network/tcollector.md)
* [`graphite`](api/network/graphite.md)
* [`statsd`](api/network/statsd.md)
* [`osisoft pi`](api/network/picomp2.md)

## Schema

New entities and metrics are registered by the database automatically and support the collection of data from numerous different domain models in a single extensible schema.

The underlying tables are listed on the **Settings > Storage > Database Tables** page. Table schemas are **self-managed** by the database.

### Glossary

| Name | Description |
|---|---|
| `Entity` | Name of the object being monitored. |
| `Metric` | Name of the numeric attribute describing the object. |
| `Sample` | Timestamped numeric metric value, `time:value`. |
| `Series` | Sequence of `Samples`, identified by a composite key consisting of `Metric`, `Entity`, and optional `Tags`. |
| `Tag` | Custom attribute describing the `Metric`, `Entity`, or `Series`, and consisting of a name and a value, `name:value`. |

### Example

The commands listed below store temperature observations for the bioreactor enclosure `BR1740` located at site `SVL2` in Sunnyvale, as well as room temperature at the same site.

Metadata commands contain descriptive attributes sent initially and on change.

```elm
entity e:BR1740 t:type=Bioreactor t:city=Sunnyvale t:site=SVL2
entity e:SVL2   t:type=site       t:city=Sunnyvale
metric m:Temperature t:units=Celsius
```

Series commands carry the actual measurements and contain only the series key.

```elm
series d:2018-05-20T00:15:00Z e:BR1740 m:Temperature=70.5 t:part=enclosure
series d:2018-05-20T00:15:00Z e:SVL2   m:Temperature=25.2
series d:2018-05-20T00:16:00Z e:BR1740 m:Temperature=72.5 t:part=enclosure
series d:2018-05-20T00:16:00Z e:SVL2   m:Temperature=25.1
...
```

By separating inserted data into **metadata** and **time series** data, each type of information is stored and processed separately and thus, more efficiently. Both types of data are readily available and can be accessed in SQL queries and REST API requests.

```sql
SELECT datetime, value, entity
  FROM atsd_series
WHERE metric = 'Temperature'
  AND entity.tags.type = 'Bioreactor'
  ORDER BY datetime
```
