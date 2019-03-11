# History

![](./images/axibase-logo-full.png)

ATSD is developed by [Axibase Corporation](https://axibase.com/about-us/), a privately owned company established in 2004 and headquartered in Cupertino, CA, USA.

We have over a decade of experience in infrastructure management systems, big data, and analytics. With ATSD, we sought to build a specialized database with a focus on data quality and performance where time series data is treated like a first-class citizen.

## Prototype

* Prototype released June 2013.
* MVP released October 2013.
* First licensed ATSD instance delivered 2014.

### 2013

* **Q2**: [Base storage](./schema.md#series)  functionality for time series data.
* **Q4**: Support for [`property`](./schema.md#properties) and [`message`](./schema.md#messages) data types.

### 2014

* **Q1**: Addition of [REST API](./api/data/README.md) and [Network API](./api/network/README.md).
* **Q2**: Introduction of [Charts](https://axibase.com/docs/charts/) and [Portals](./portals/README.md).
* **Q3**: Release and integration of [Axibase Collector](https://axibase.com/docs/axibase-collector/)

### 2015

* **Q1**: [ChartLab](https://axibase.com/use-cases/tutorials/shared/chartlab.html) visualization sandbox.
* **Q2**: [Versioning](./versioning/README.md) for time series data.

### 2016

* **Q1**: Official [Docker Images](./installation/docker.md)
* **Q2**: [SQL](./sql/sql-console.md) for data retrieval operations.

### 2017

* **Q1**: Native [compaction](./administration/compaction.md).
* **Q2**: [Amazon Elastic MapReduce (EMR)](./installation/aws-emr-s3.md) integration.
* **Q3**: Support for [Outgoing Webhooks](./rule-engine/notifications/README.md) using [Rule Engine](./rule-engine/README.md).
* **Q4**: Support for [Incoming Webhooks](./rule-engine/incoming-webhooks.md).

### 2018

* **Q1**: [ATSD Sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#atsd-sandbox-docker-image).
* **Q3**: Customizable transformation [pipeline](./api/data/series/query.md#transformations) in REST API Series Query.
* **Q4**: Forecasting algorithms based on Principal Component Analysis (PCA).

### 2019

* **Q1**: [ATSD ODBC driver](https://github.com/axibase/atsd-odbc).
* **Q1**: Interval data type for process analysis.
* **Q2**: [Azure HDInsight](./installation/azure-hdinsight.md) integration.

## Change Log

View the monthly [Change Log](./changelogs/README.md) for an overview of new features available in the latest ATSD release.

## Roadmap

[Contact us](https://axibase.com/feedback/) if you are interested in learning more about the ATSD roadmap.
