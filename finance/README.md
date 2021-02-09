# Introduction

**Axibase Time Series Database** is a scalable platform for storing and analyzing financial market data such as trades, quotes, and session summaries.

ATSD provides customers easy-to-use querying tools and APIs to perform quantitative research, analyze transaction costs as well as backtest trading algorithms. Unlike traditional tick stores which are updated on `T+1` basis, ATSD is optimized for streaming data from self-aggregated, consolidated, and direct exchange feeds available to the client.

Supported data types include:

* Last sale / trades
* Level 1 Quotes
* Auction and Imbalance Statistics
* Order Book Summary
* Day and Session Summary
* Reference Data
* Security Status

## SQL

* Web-based SQL console with auto-completion, query history
* Scheduled SQL query reporting with email, file, and web delivery
* JDBC/ODBC drivers
* Advanced filtering: trading schedule, auction stage, reference data

## REST API

* Raw trade export
* Aggregated trade export
* Quote and statistics export
* Java and Python API clients

## Use Cases

* Auction arbitrage
* ETF NAV arbitrage
* Index arbitrage
* Non-transparent ETF/ETN decomposition
* Trade execution reporting
* Market surveillance

## Security Types

The extensible instrument schema allows clients to store tick and reference data for any asset class, including:

* Equities
* Futures
* Options
* Bonds
* Currencies / FX
* ETFs/ETNs
* Indices
* Commodities

## Installation

ATSD is supported on major Linux distributions in 64-bit mode. In scale-out mode ATSD is deployed on [Apache HBase](https://hbase.apache.org/) on file systems such as [Hadoop](../installation/cloudera.md) (HDFS), [Amazon EMRFS](../installation/aws-emr-s3.md), and [Azure Storage](../installation/azure-hdinsight.md).

Installation on [Docker](../installation/docker.md):

```bash
docker run -d --name=atsd --env=JAVA_OPTS="-Dprofile=FINANCE" axibase/atsd:latest && docker logs -f atsd
```

## Quick Start

* Send [trades](command-trade-insert.md)
* Send [quotes and statistics](command-statistics-insert.md)
* Send [reference](command-instrument-entity.md) data

## Pricing

Standalone version is free of charge, including for production purposes. The scale-out version requires an active support agreement.
