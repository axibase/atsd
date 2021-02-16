# Introduction

**Axibase Time Series Database** is a scalable platform for storing and analyzing financial market data such as trades, quotes, EOD, session, and auction statistics.

ATSD standalone version is fully functional and is free of charge, including for production purposes.

## Supported Data Types

* Trades / last sale
* Level 1 Quotes
* Auction and Imbalance Statistics
* EOD (End-of-Day) and Session Summary
* Reference Data

## Insertion Modes

* Bulk upload from files
* Streaming real-time

## Instrument Types

* Equities
* Futures
* Options
* Bonds
* Currencies / FX
* ETFs/ETNs
* Indices
* Commodities

## Use Cases

* Quantitative research
* Strategy backtesting
* Auction arbitrage
* ETF NAV arbitrage
* Index arbitrage
* Non-transparent ETF/ETN decomposition
* Trade execution reporting
* Market surveillance

## API Clients

* Open source API clients for [Python](https://github.com/axibase/atsd-api-python) and [Java](https://github.com/axibase/atsd-api-java) 

## Installation

ATSD is supported on major Linux distributions in 64-bit mode. In scale-out mode ATSD is deployed on [Apache HBase](https://hbase.apache.org/) on file systems such as [Hadoop](../installation/cloudera.md) (HDFS), [Amazon EMRFS](../installation/aws-emr-s3.md), and [Azure Storage](../installation/azure-hdinsight.md).

Installation on [Docker](../installation/docker.md):

```bash
docker run -d --name=atsd --env=JAVA_OPTS="-Dprofile=FINANCE" axibase/atsd:latest && docker logs -f atsd
```