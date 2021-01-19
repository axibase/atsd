# Introduction

**Axibase Time Series Database** FINANCE edition is optimized for storing and real-time processing of financial market data such as trades, quotes, and session summaries.

ATSD provides customers easy-to-use querying tools and APIs to perform quantitative research, analyze transaction costs as well as backtest trading algorithms. Unlike traditional tick databases, ATSD is capable of ingesting streaming data from real-time feeds.

## Data

ATSD provides a platform for processing and persisting data from consolodated and direct exchange feeds available to the customer.

* Trades
* Level 1 Quotes
* Auctions and Imbalance
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

* Equities
* Futures
* Options
* Bonds
* Currencies / FX
* ETFs/ETNs
* Indices

## Installation

ATSD is supported on major Linux distributions in 64-bit mode. In scale-out mode ATSD is deployed on [Apache HBase](https://hbase.apache.org/) on file systems such as [Hadoop](../installation/cloudera.md) (HDFS), [Amazon EMRFS](../installation/aws-emr-s3.md), and [Azure Storage](../installation/azure-hdinsight.md).

Installation on [Docker](docker.md):

```bash
docker run -d --name=atsd --env=JAVA_OPTS="-Dprofile=FINANCE" axibase/atsd:latest && docker logs -f atsd
```

## Quik Start

* Send [trades](command-trade-insert.md)
* Send [quotes and statistics](command-statistics-insert.md)
* Send [reference](command-instrument-entity.md) data

## Licensing

ATSD subscription license allows for no-charge usage of the standalone version, including for production purposes. The scale-out version requires a paid license.