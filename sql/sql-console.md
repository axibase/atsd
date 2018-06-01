# SQL Console: Data Analysis in ATSD

## Overview

**SQL console** provides a way to submit [SQL queries](../sql/README.md) to the database and display the results. Export these results to `CSV`, `JSON`, or `XLSX` files or [reinsert](#store) them as newly created series. Open **SQL Console** from the **SQL** menu by clicking **Console**.

## SQL Console

![](images/sql-console.png)

**SQL Console** has three components:

1. [**Data Controls**](#data-controls)
2. [**Action Controls**](#action-controls)
3. **SQL** Menu

Enter queries in the blank **Query Window**.

```sql
SELECT datetime, value
    FROM "mpstat.cpu_busy"
WHERE entity = 'nurswghbs001'
    ORDER BY datetime DESC
LIMIT 10
```

| datetime             | value |
|----------------------|-------|
| 2018-06-01T07:04:41Z | 0.83  |
| 2018-06-01T07:04:25Z | 0.50  |
| 2018-06-01T07:04:09Z | 0.17  |
| 2018-06-01T07:03:53Z | 2.59  |
| 2018-06-01T07:03:37Z | 7.83  |
| 2018-06-01T07:03:21Z | 10.54 |
| 2018-06-01T07:03:05Z | 2.01  |
| 2018-06-01T07:02:49Z | 1.92  |
| 2018-06-01T07:02:33Z | 8.00  |
| 2018-06-01T07:02:17Z | 12.16 |

## Data Controls

**Data Controls** modify return set data formatting or alter the appearance of text in the **Query Window**.

### Date Format / Time Zone

Use **Date Format** menu to display one of the supported date formats without the use of inline [`date_format`](examples/datetime-format.md) function. Use **Time Zone** menu to select UTC or server local time.

This table displays 16:30, May 15, 2018 UTC using each of the options for date formatting:

**Date Format** | **UTC** | **Server Local Time**
---|---|---
`yyyy-MM-ddT HH:mm:ss.SSSZ` | `2018-05-15T16:30:00.000Z` | `2018-05-15T12:30:00.000Z`
`yyyy-MM-ddT HH:mm:ssZ` | `2018-05-15T16:30:00Z` | `2018-05-15T12:30:00Z`
`yyyy-MM-ddT HH:mm:ss.SSS` | `2018-05-15 16:30:00.000` | `2018-05-15 12:30:00.000`
`yyyy-MM-ddT HH:mm:ss` | `2018-05-15 16:30:00` | `2018-05-15 12:30:00`
`yyyy-MM-dd` | `2018-05-15` | `2018-05-15`
`MMM-dd` | `May-15` | `May-15`
`MMM-dd, E` | `May-15, Tue` | `May-15, Tue`
`MMM-dd, EEEE` | `May-15, Tuesday` | `May-15, Tuesday`
`Default` | `2018-05-15T16:30:00.000Z` | `2018-05-15T12:30:00.000Z`

> Server local time in this example is Eastern Standard Time (EST) but may be [configured](../administration/timezone.md).

### Decimal Precision

Modify decimal precision in results. Values represent decimal places beyond `0`. Value `-1` includes all stored decimal values for a sample.

![](images/decimal-precision.png)

```sql
SELECT max(value), count(value)
  FROM mpstat.cpu_busy WHERE datetime > current_day
LIMIT 1
```

Decimal Precision | Returned Value
---|---
`-1` | 65.2
`0` | 65
`1` | 65.2
`2` | 65.20

Increase decimal precision up to `20` places beyond `0`.

### Theme

Select color scheme for query text; [reserved words](README.md#reserved-words), [literals](README.md#literals), and [syntactical expressions](README.md#syntax) are affected.

![](images/theme.png)

#### Default

![](images/default.png)

#### Brick

![](images/brick.png)

#### Violet

![](images/violet.png)

### `NULL` Format

Change the way SQL Console displays [`NULL`](README.md#null) values.

```sql
SELECT NULL
  FROM mpstat.cpu_busy
LIMIT 1
```

#### `null`

| NULL |
|------|
| null |

#### `NULL`

| NULL |
|------|
| NULL |

#### `N/A`

| NULL |
|------|
| N/A  |

#### `-`

| NULL |
|------|
|   -  |

#### Empty space

| NULL |
|------|
|      |

## Action Controls

**Action Controls** initiate events in SQL Console.

### Execute

Perform query shown in the **Query Window**, the database returns results in a table below controls.

### Cancel

Interrupt a long-running query, the database may take several seconds to gracefully stop a query.

### Export

Download the results of a query in `CSV`, `JSON (objects)`, `JSON (row)`, or `XLSX` format. Click **Export** to open the **Export Window** tool. Modify query results (for example, apply an [alias](README.md#aliases)), select download format, and optionally include [metadata](scheduled-sql-metadata.md#sql-report-metadata) descriptions.

![](images/export1.png)

### Store

Reinsert query results into the database and store them as new derived series. Execute the query and click **Store** to open the **Store Query Results as Series** tool.

![](images/store3.png)

[**Check Last Time**](scheduled-sql-store.md#duplicates) switch verifies that timestamps exceed existing samples as a means of controlling how duplicate results are handled. [**Test**](scheduled-sql-store.md#validation) button validates results before inserting them into the database.

Run a query [on a schedule](scheduled-sql.md), click **Schedule** to open a new [**Scheduled Queries**](#scheduled-queries) page for the current query.

### Query Plan

Opens the **SQL Query Statistics** page for the current query. **SQL Query Statistics** displays general query information such as **Elapsed Time** (to perform query), **Returned Records**, and the **User** who performed the query, as well as more detailed information like **Results Bytes**, **RPC Calls** (between remote servers), and **Millis Between Next** (time between two samples in milliseconds).

![](images/query-plan.png)

The bottom row of buttons may be used to return to the **SQL Console** or navigate to the general **Query Statistics** page.