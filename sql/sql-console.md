# SQL Console: Data Analysis in ATSD

## Overview

**SQL console** provides a way to submit [SQL queries](../sql/README.md) to the database and display the results. Export these results to `CSV`, `JSON`, or `XLSX` files for external use, or [reinsert](#store) them as a newly created series for immediate use within the ATSD environment. Access **SQL Console** from anywhere in the system by opening the **SQL** menu and clicking **Console**.

## SQL Console

![](images/sql-console.png)

The SQL Console has three components:

1. [**Data Controls**](#data-controls)
2. [**Action Controls**](#action-controls)
3. **SQL** Menu

Enter queries in the blank **Query Window**.

Consider the query:

```sql
SELECT datetime, value
    FROM "mpstat.cpu_busy"
WHERE entity = 'nurswghbs001'
    LIMIT 10
```

The result set for this query is shown here:

| datetime   | value |
|------------|-------|
| 2015-09-22 | 4.340 |
| 2015-09-22 | 0.080 |
| 2015-09-22 | 0.250 |
| 2015-09-22 | 0.080 |
| 2015-09-22 | 0.500 |
| 2015-09-22 | 1.170 |
| 2015-09-22 | 0.250 |
| 2015-09-22 | 2.000 |
| 2015-09-22 | 0.420 |
| 2015-09-29 | 6.590 |

## Data Controls

**Data Controls** are five drop-down menus which modify return set data formatting or alter the appearance of the text in the **Query Window**.

### Date Format / Time Zone

Use **Date Format** drop-down menu to modify result set data as one of the supported date formats without the use of inline [`date_format`](examples/datetime-format.md) function. Use **Time Zone** drop-down menu to select UTC or server local time for `datetime` output.

This table displays 12:45 (+45 seconds) PM, September 22, 2015 UTC (the timestamp of the first entry in the table above) using each of the options for time formatting:

**Date Format** | **UTC** | **Server Local Time**
---|---|---
`yyyy-MM-ddT HH:mm:ss.SSSZ` | `2015-09-22T12:45:41.000Z` | `2015-09-22T08:45:41.000Z`
`yyyy-MM-ddT HH:mm:ssZ` | `2015-09-22T12:45:41Z` | `2015-09-22T08:45:41Z`
`yyyy-MM-ddT HH:mm:ss.SSS` | `2015-09-22 12:45:41.000` | `2015-09-22 08:45:41.000`
`yyyy-MM-ddT HH:mm:ss` | `2015-09-22 12:45:41` | `2015-09-22 08:45:41`
`yyyy-MM-dd` | `2015-09-22` | `2015-09-22`
`MMM-dd` | `Sep-22` | `Sep-22`
`MMM-dd, E` | `Sep-22, Tue` | `Sep-22, Tue`
`MMM-dd, EEEE` | `Sep-22, Tuesday` | `Sep-22, Tuesday`
`Default` | `2015-09-22T12:45:41.000Z` | `2015-09-22T08:45:41.000Z`

> Note that server local time in this example is Eastern Standard Time (EST) but may be [configured](../administration/timezone.md).

### Decimal Precision

Modify decimal precision in the result set. Values represent decimal places beyond `0`. Value `-1` includes the complete set of logged decimal values.

![](images/decimal-precision.png)

Consider the query:

```sql
SELECT max(value), count(value)
  FROM mpstat.cpu_busy WHERE datetime > current_day
LIMIT 1
```

This table shows how various **Decimal Precision** settings will affect the returned value:

Decimal Precision | Returned Value
---|---
`-1` | 65.2
`0` | 65
`1` | 65.2
`2` | 65.20

Increase decimal precision up to `20` places beyond `0`.

### Theme

SQL Console supports color customization for query text based on user preferences. [Reserved words](README.md#reserved-words), [literals](README.md#literals), and [syntactical expressions](README.md#syntax) will be affected.

![](images/theme.png)

Available themes are:

#### Default

![](images/default.png)

#### Brick

![](images/brick.png)

#### Violet

![](images/violet.png)

### Null Format

Customize the way SQL Console returns [`NULL`](README.md#null) values. Setting will affect both displayed and exported result sets.

Consider the query:

```sql
SELECT value, LAG(value), LEAD(value)
  FROM mpstat.cpu_busy
LIMIT 2
```

Using the [`LAG`](README.md#lag) and [`LEAD`](README.md#lead) functions to return `NULL` values for the first and second samples respectively. Selectable options include:

#### `null`

| value | lag(value) | lead(value) |
|-------|------------|-------------|
| 4.34  | null       | 0.08        |
| 0.08  | 4.34       | null        |

#### `NULL`

| value | lag(value) | lead(value) |
|-------|------------|-------------|
| 4.34  | NULL       | 0.08        |
| 0.08  | 4.34       | NULL        |

#### `N/A`

| value | lag(value) | lead(value) |
|-------|------------|-------------|
| 4.34  | N/A        | 0.08        |
| 0.08  | 4.34       | N/A         |

#### `-`

| value | lag(value) | lead(value) |
|-------|------------|-------------|
| 4.34  | -          | 0.08        |
| 0.08  | 4.34       | -           |

#### Empty space

| value | lag(value) | lead(value) |
|-------|------------|-------------|
| 4.34  |            | 0.08        |
| 0.08  | 4.34       |             |

## Action Controls

**Action Controls** are a row of buttons that initiate various events in SQL Console.

### Execute

Perform the query shown in the **Query Window**, the database will return results in a table below the controls.

### Cancel

Interrupt a long-running query.

### Export

Download the results of the current query in `CSV`, `JSON (objects)`, `JSON (row)`, or `XLSX` formats. Clicking **Export** will open the **Export Window** tool. Modify query results (for example applying [aliases](README.md#aliases) for more human-readable results), select download format, and optionally include [metadata](scheduled-sql-metadata.md#sql-report-metadata) descriptions.

![](images/export1.png)

### Store

Reinsert query results into the database and store them as new derived series. Execute the query and click **Store** to open the **Store Query Results as Series** tool.

![](images/store3.png)

[**Check Last Time**](scheduled-sql-store.md#duplicates) switch verifies that newly-inserted results' timestamps exceed existing samples, as a means of controlling how duplicate results are handled.

[**Test**](scheduled-sql-store.md#validation) button validates results before inserting them into ATSD.

Run a query [on a schedule](scheduled-sql.md), click **Schedule** to open a new [**Scheduled Queries**](#scheduled-queries) page for the current query.

### Query Plan

Opens the **SQL Query Statistics** page for the specific SQL query shown in the **Query Window**. **SQL Query Statistics** displays general query information such as **Elapsed Time** (to perform query), **Returned Records**, and the **User** who performed the query, as well as more detailed information like **Results Bytes**, **RPC Calls** (between remote servers), and **Millis Between Next** (time between two samples in milliseconds).

![](images/query-plan.png)

The bottom row of buttons may be used to return to the SQL Console or navigate to the general **Query Statistics** page.