# Introduction

**Axibase Time Series Database** is a scalable platform for storing and analyzing financial market data such as trades and quotes, as well as end-of-day, session, and auction statistics.

## Key Features

* Parallel query engine optimized for common data access patterns
* Extended [SQL](sql.md) syntax with fast OHLCV and VWAP aggregators
* Flexible filtering based on reference data, trading schedules, and index composition

## Supported Data Types

* Trades / Last sale
* Level 1 Quotes
* Auction and Imbalance Statistics
* EOD (End-of-Day) and Session Summary
* Reference Data

## Insertion Modes

* Real-time streaming using FAST, SBE, plain text
* Scheduled upload from archives

## Asset Classes

* Equities
* Futures
* Options
* Bonds
* Currencies
* ETFs/ETNs
* Indices

## Use Cases

* Quantitative research
* Strategy backtesting
* Auction arbitrage
* Index arbitrage
* ETF arbitrage
* Non-transparent ETF decomposition
* Trade execution reporting
* Market surveillance

## API Clients

* Open source API clients for [Python](https://github.com/axibase/atsd-api-python) and [Java](https://github.com/axibase/atsd-api-java)
* Open source [JDBC](https://github.com/axibase/atsd-jdbc) and [ODBC](https://github.com/axibase/atsd-odbc) drivers

## Installation

ATSD is supported on major Linux distributions in 64-bit mode. In scale-out mode ATSD is deployed on [Apache HBase](https://hbase.apache.org/) on file systems such as [Hadoop](../installation/cloudera.md) (HDFS), [Amazon EMRFS](../installation/aws-emr-s3.md), and [Azure Storage](../installation/azure-hdinsight.md).

Installation on [Docker](../installation/docker.md):

```bash
docker run -d --name=atsd --env=JAVA_OPTS="-Dprofile=FINANCE" axibase/atsd:latest && docker logs -f atsd
```

ATSD standalone version is free of charge, including for production purposes.