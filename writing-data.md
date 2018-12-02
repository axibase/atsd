# Writing Data into ATSD

## REST and Network API

ATSD server provides [REST API](./api/data/README.md) and [Network API](./api/network/README.md) to insert time series, properties, and messages, as well as to manage series [metadata](./api/meta/README.md).

## CSV Parsers

Upload [CSV](https://axibase.com/docs/atsd/parsers/csv/) files including `.zip` and `tar.gz` archives directly into the database for bulk import. Stream data in CSV format into ATSD with [Network API](./api/network/README.md).

## Axibase Collector

![](./images/axibase-collector.png)

[Axibase Collector](https://axibase.com/docs/axibase-collector/) is an ETL tool for scheduled data collection from external sources.

Use Collector to retrieve structured and unstructured data from a wide variety of sources such as relational databases, web services, and Java applications.

### Axibase Collector Integrations

* [AWS](https://axibase.com/docs/axibase-collector/jobs/aws.html)
* [Docker](https://axibase.com/docs/axibase-collector/jobs/docker.html)
* [FILE](https://axibase.com/docs/axibase-collector/jobs/file.html)
* [HTTP](https://axibase.com/docs/axibase-collector/jobs/http.html)
* [ICMP](https://axibase.com/docs/axibase-collector/jobs/icmp.html)
* [JDBC](https://axibase.com/docs/axibase-collector/jobs/jdbc.html)
* [JMX](https://axibase.com/docs/axibase-collector/jobs/jmx.html)
* [JSON](https://axibase.com/docs/axibase-collector/jobs/json.html)
* [Kafka](https://axibase.com/docs/axibase-collector/jobs/kafka.html)
* [OVPM](https://axibase.com/docs/axibase-collector/jobs/ovpm.html)
* [OsiSoft PI](https://axibase.com/docs/axibase-collector/jobs/pi.html)
* [SNMP](https://axibase.com/docs/axibase-collector/jobs/snmp.html)
* [Socrata](https://axibase.com/docs/axibase-collector/jobs/socrata.html)
* [TCP](https://axibase.com/docs/axibase-collector/jobs/tcp.html)
