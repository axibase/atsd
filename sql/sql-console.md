# SQL Console

## Overview

**SQL Console** is a web-based interface to submit [SQL queries](../sql/README.md) to the database and display the results. Export the results to `CSV`, `JSON`, and Excel files or [reinsert](#store) the results as a newly created series. Open **SQL Console** from the **SQL** menu by clicking **Console**.

![](images/sql_console.png)

**SQL Console** has three components:

1. **Query** Window
2. [Data Controls](#data-controls)
3. [Action Controls](#action-controls)

Enter queries in the **Query** window. **SQL Console** returns the results below the controls.

![](images/query-result1.png)

## Data Controls

All Data Controls modify returned data without re-submitting a query. Change date formatting, timezone, decimal precision, theme, or null formatting on the fly for long-running queries without delay.

### Date Format / Time Zone

Use **Date Format** drop-down list to modify the `datetime` column without the [`date_format`](examples/datetime-format.md) function. Use **Time Zone** drop-down list to select UTC or server local time.

This table displays 16:30 on Tuesday, May 15, 2018, using each of the date formatting options:

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

Server local time in this example is Eastern Standard Time (EST) but may be [configured](../administration/timezone.md) by an `ADMIN` user.

### Decimal Precision

Modify precision in results that consider decimal values, `-1` includes all decimal values for a sample. This feature does not affect data which does not consider decimal precision such as integer values or text columns.

![](images/decimal-precision.png)

```sql
SELECT max(value), count(value)
  FROM mpstat.cpu_busy WHERE datetime > current_day
LIMIT 1
```

Decimal Precision | `MAX(value)` | `COUNT(value)`
---|---|---
`-1` | 65.2 | 2279
`0` | 65 | 2279
`1` | 65.2 | 2279
`2` | 65.20 | 2279

[`MAX`](README.md#aggregation-functions) function returns the decimal number of the largest data sample and [`COUNT`](README.md#aggregation-functions) function returns the integer number of samples for the defined period, thus the **Decimal Precision** setting does not affect the `COUNT(value)` column here. Increase decimal precision up to `20` places beyond `0`.

### Theme

Select color scheme for query text; [reserved words](README.md#reserved-words), [literals](README.md#literals), and [syntax](README.md#syntax) are affected.

![](images/theme.png)

#### Default

![](images/default.png)

#### Brick

![](images/brick.png)

#### Violet

![](images/violet.png)

### Null Format

Change the way SQL Console displays [null](README.md#null) values.

```sql
SELECT NULL
  FROM "mpstat.cpu_busy"
LIMIT 1
```

The following table shows each option applied to a null value:

Setting | NULL | null | N/A | Dash | Empty |
:------:|:----:|:----:|:---:|:----:|:-----:|
Value   |`NULL`|`null`|`N/A`|  `-` |       |

## Action Controls

### Execute

Perform the query in the **Query** window, the database returns results in a table below the controls.

### Cancel

Interrupt a long-running query. The database may take several seconds to gracefully stop a query.

### Export

Download the results of a query in `CSV`, `JSON (objects)`, `JSON (row)`, or `XLSX` format. Click **Export** to open the **Export Query Results** window. Modify the query (for example, apply an [alias](README.md#aliases)), select a download format, and optionally include [metadata](scheduled-sql-metadata.md#sql-report-metadata).

![](images/export1.png)

### Store

Reinsert and store results in the database as a new derived series. Execute the query and click **Store** to open the **Store Query Results as Series** window.

![](images/store3.png)

[**Check Last Time**](scheduled-sql-store.md#duplicates) switch verifies that timestamps exceed existing samples as a means to discard duplicate samples. [**Test**](scheduled-sql-store.md#validation) button validates results before insertion into the database.

To run the current query [on a schedule](scheduled-sql.md), click **Schedule** to open a new [**Scheduled Queries**](#scheduled-queries) page.

### Query Plan

Opens the **SQL Query Statistics** page for the current query. **SQL Query Statistics** include general query information such as **Elapsed Time** (to perform query), **Returned Records**, and the **User** who performed the query, as well as more detailed information like **Results Bytes**, **RPC Calls** (between remote servers), and **Millis Between Next** (time between two samples in milliseconds).

![](images/query-plan.png)

The bottom row of buttons may be used to return to the **SQL Console** or navigate to the general **Query Statistics** page.