# Introduction

**Axibase Time Series Database** is a scalable platform for storing and analyzing financial market data such as trades and quotes, as well as end-of-day, session, and auction statistics.

## Key Features

* Parallel query engine for fast data access
* Extended [SQL](sql.md) syntax with OHLCV and VWAP aggregators
* Flexible filtering based on reference data, trading calendars, and index composition

## Supported Data Types

* Trades / Last sale
* Level 1 Quotes
* Auction and Imbalance Statistics
* EOD (End-of-Day) and Session Summary
* Reference Data
* Generic time-series

## Insertion Modes

* Real-time streaming using FAST, SBE, plain text
* Scheduled upload from daily archives

## Data Sources

* Consolidated feeds
* Direct exchange feeds
* Files

## Asset Classes

* Equities
* Futures
* Options
* Bonds
* Currencies
* ETFs/ETNs
* Indices

## Forecasting Algorithms

* ARIMA
* SVD / SSA
* Holt-Winters

## Use Cases

* Quantitative research
* Strategy backtesting
* Auction/Index/ETF arbitrage
* Non-transparent ETF decomposition
* Trade execution reporting
* Market surveillance

## API Clients

* Open source API clients for [Python](https://github.com/axibase/atsd-api-python) and [Java](https://github.com/axibase/atsd-api-java)
* Open source [JDBC](https://github.com/axibase/atsd-jdbc) and [ODBC](https://github.com/axibase/atsd-odbc) drivers

## Installation

ATSD is supported on major Linux distributions in 64-bit mode. Refer to installation [instructions](./install.md) for hardware requirements and details.

ATSD standalone version is free of charge, including for production purposes.

## Getting Started

Contact `support-atsd@axibase.com` for assistance with installation and data source integration. Provide links to or attach sample data files as well as identify the preferred programming environment: Java or Python.