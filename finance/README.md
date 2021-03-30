---
# /* yaspeller ignore:start */
landing: true
title: Fast and reliable datastore for financial market data
description: Fast and reliable datastore for financial market data
heroText: Fast and reliable datastore for financial market data
tagline: Treat your data as an asset
actionText: Install on Linux →
actionLink: ./install.md
features:
- title: Faster than files
  details: Parallel query engine with time- and symbol-indexed data access
- title: Full-featured SQL
  details: Extended <a href="sql.html" style="color:orange">SQL</a> syntax with advanced filtering and aggregations
- title: Streaming and Batch Updates
  details: Consolidate quotes, trades, snapshots, and reference data in one place
footer: Copyright © 2021 Axibase
#footerActionText: Getting Stared Guide
#footerActionLink: ./getting-started.md

resetStripes: false # If last feature stripe in content is white (even number of highlighted features), set it to true
contactUs:
  title: Request Trial
  content: Trial request for financial version

# /* yaspeller ignore:end */
---
<!-- markdownlint-disable MD002 MD041 MD012 -->
<article class="feature-highlight">

<div class="feature-images">

![](./images/ohlc_1.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## What you can do with ATSD

- Strategy backtesting on high-frequency data
- Quantitative and market microstructure research
- Granular transaction cost analysis and rollup reporting
- Market surveillance and anomaly detection
- Non-transparent ETF/ETN decomposition

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/stock_5.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## Streaming & Scheduled Market Data

- FAST, SBE, and proprietary protocols
- Plain text protocol
- Consolidated and direct feeds
- Built-in latency monitoring tools
- End-of-day archives
- ETL from institutional and retail financial data platforms

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/sql_2_iexg.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## SQL Engine

- Parallel [SQL](./sql.md) engine with syntax extensions
- Advanced filtering by trading session, auction stage, index composition
- Optimized aggregates for OHLCV and VWAP calculations
- Interactive SQL console with auto-completion
- API [endpoint](../sql/api.md) for programmatic integration
- Scheduled SQL [reporting](../sql/scheduled-sql.md) with email, file, and web delivery
- [JDBC](https://github.com/axibase/atsd-jdbc) and [ODBC](https://github.com/axibase/atsd-odbc) drivers

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/frac_diff_4.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## REST API

- Trades: [write](./command-trade-insert.md), [read](./trades-export.md)
- OHLCV bars: [calculate](./ohlcv-export.md), [write](./session-summary-import-ohlcv.md), [read](./session-summary-export-ohlcv.md) <!-- yaspeller ignore -->
- Quotes: [write](./command-statistics-insert-quotes.md), [read](./session-summary-import-ohlcv.md)
- Snapshots: [write](./session-summary-import.md), [read](./session-summary-export.md)
- Reference data: [write](./command-instrument-entity.md), [read](./reference-export.md)
- API clients for [Python](https://github.com/axibase/atsd-api-python) and [Java](https://github.com/axibase/atsd-api-java)

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/read_write_parallel.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## ATSD vs Files

- Searching records by index is faster than reading files sequentially
- Extra performance with caching and parallelized scans
- Non-blocking writes enable multiple concurrent reads
- Read visibility before transaction committed to disk with memory scans
- Records can be inserted out-of-order and modified in-place
- Filter, aggregate, sort without copying data to clients

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/atsd_db_2.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## ATSD vs Relational Databases

- Reduced overhead on critical read and write paths
- Automated sharding of segmented tables
- Parallelized scans
- Optimal compression codecs to reduce I/O and disk space usage
- Aggregate and analytical functions optimized for financial data

</div>
</article>
<article class="feature-highlight">

<div class="feature-images">

![](./images/chat_alerts_7.png) <!-- yaspeller ignore -->

</div>
<div class="feature-content">

## Data Ops Included

- Built-in latency monitoring with break-down by data feed and market
- ETL collector for FTP/SCP/HTTP integrations with task control
- Rule engine and scheduled SQL for nightly and pre-trade checks
- Alerting via messengers, webhooks, email

</div>
</article>