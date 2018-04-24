# Overview

The Axibase Time Series Database supports Structured Query Language (SQL) for retrieving time series records from the database.

SQL statements can be executed interactively via the web-based console, on [schedule](#scheduler), and using the [JDBC](https://github.com/axibase/atsd-jdbc) driver.

* [Syntax](#syntax)
  * [SELECT Expression](#select-expression)
  * [WHERE Clause](#where-clause)
  * [Other Clauses](#other-clauses)
  * [Columns](#columns)
  * [Aliases](#aliases)
  * [Interval Condition](#interval-condition)
  * [Aggregation Functions](#aggregation-functions)
  * [Date Functions](#date-functions)
  * [Mathematical Functions](#mathematical-functions)
  * [String Functions](#string-functions)
  * [Other Functions](#other-functions)
  * [CASE Expression](#case-expression)
  * [Arithmetic Operators](#arithmetic-operators)
  * [Match Expressions](#match-expressions)
  * [NULL](#null)
  * [Not a Number](#not-a-number-nan)
  * [Processing Sequence](#processing-sequence)
  * [Keywords](#keywords)
* [Processing Sequence](#processing-sequence)
* [Period](#period)
* [Interpolation](#interpolation)
* [Regularization](#regularization)
* [Grouping](#grouping)
* [Partitioning](#partitioning)
* [Ordering](#ordering)
* [Limiting](#limiting)
* [Inline Views](#inline-views)
* [Joins](#joins)
* [Options](#options)
* [Authorization](#authorization)
* [API Endpoint](#api-endpoint)
* [Scheduler](#scheduler)
  * [Send Reports](scheduled-sql.md)
  * [Store Results](scheduled-sql-store.md)
* [Monitoring](#monitoring)
* [Performance](#query-performance)
* [Optimizing](#optimizing)
* [SQL Compatibility](#sql-compatibility)
* [Examples](#examples)

## Syntax

The `SELECT` statement consists of a `SELECT` expression, a `FROM` query, a `WHERE` clause, and other clauses for filtering, grouping, and ordering the results.

```sql
SELECT { * | { expr [ .* | [ AS ] alias ] } }
  FROM table [[ AS ] alias ]
    [ { INNER | [ FULL ] OUTER } JOIN [ USING ENTITY ] table [[ AS ] alias ] [ ON joinExpr ] ]
[ WHERE expr(boolean) ]
  [ WITH ROW_NUMBER expr ]
[ GROUP BY expr [, ...] ]
  [ HAVING expr(boolean) ]
  [ WITH ROW_NUMBER expr ]
[ WITH LAST_TIME expr ]
[ WITH INTERPOLATE expr ]  
[ ORDER BY expr [{ ASC | DESC }] [, ...] ]
[ LIMIT count [ OFFSET skip ]]
  [ OPTION(expr) [...]]
```

Example:

```sql
SELECT datetime, entity, value     -- SELECT expression
  FROM "mpstat.cpu_busy"           -- query
WHERE datetime >= '2017-06-15T00:00:00Z'    -- WHERE clause
  LIMIT 1                          -- other clauses
```

The statement may be terminated with a semicolon character.

### SELECT Expression

The SELECT expression consists of one or multiple columns and expressions applied to the query results.

### Query

#### Virtual Table

The `FROM` query can reference virtual tables that correspond to metric names.

A virtual table represents a subset of records for the given metric stored by the database in the shared physical table.

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2017-06-15T00:00:00Z'
```

In the example above, the `"mpstat.cpu_busy"` table contains records for the `mpstat.cpu_busy` metric.

> Virtual tables are currently supported only for series. Access to properties, messages, and alerts is currently not available.

#### `atsd_series` Table

As an alternative to specifying metric names as tables, the `FROM` query can refer to the pre-defined [`atsd_series` table](examples/select-atsd_series.md) and include `metric` names in the `WHERE` clause instead.

```sql
SELECT entity, metric, datetime, value
  FROM atsd_series
WHERE metric = 'mpstat.cpu_busy'
  -- WHERE metric IN ('mpstat.cpu_busy', 'mpstat.cpu_user')
  -- WHERE metric LIKE 'mpstat.cpu%'
  AND entity = 'nurswgvml007'
  AND datetime >= '2017-06-15T00:00:00Z'
```

> The number of metrics retrieved with the `metric LIKE (expr)` condition is subject to a limit set by the `sql.metric.like.limit` setting. The default limit is `50`.

> Note that `LIKE` operator is case-**sensitive**.

### WHERE Clause

The `WHERE` clause is a condition which must be satisfied by the row in order to be included in results.

Columns referenced in the `WHERE` clause are replaced by their value for the given row. The condition is then evaluated for each row, and if the result is `TRUE`, the row is included in the result set.

Typically, the `WHERE` clause includes an [interval condition](#interval-condition) to retrieve data for the specified time range.

The clause can be built from multiple conditions, each comparing values using operators:

* Numeric operators: `<, >, <=, >=, =, <>, !=`.
* String operators: `<, >, <=, >=, =, <>, !=, LIKE, REGEX, IS`.

> The operators `!=` and `<>` cannot be applied to columns `time` and `datetime`.

> The operators `<, >, <=, >=` applied to string values, such as series/entity/metric tag values, perform [lexicographical comparisons](examples/filter-operators-string.md).

The result of evaluating a condition is a boolean value. Multiple conditions can be combined using the logical operators `AND`, `OR`, and `NOT`.

```sql
SELECT entity, datetime, value, tags.*
  FROM "df.disk_used"
WHERE datetime >= '2017-06-15T00:00:00Z'
  AND (entity IN ('nurswgvml007', 'nurswgvml010')
       OR tags.file_system LIKE '/dev/%'
       OR value/1024 > 100000)
```

#### Operator Precedence

* `-` (unary minus)
* `*`, `/`, `%` (modulo)
* `+`, `-` (binary minus)
* `=`, `<>`, `>=`, `>`, `<=`, `<`, `!=`, `IS`, `LIKE`, `REGEX`, `IN`
* `BETWEEN`, `CASE`, `WHEN`, `THEN`, `ELSE`
* `NOT`
* `AND`
* `OR`

Operators with the same precedence level within an expression are processed from left to right.

#### Truth Tables for Logical Operators

| **X** | **NOT X** |
|:---|:---|
| `true` | `false` |
| `false` | `true` |
| `NULL` | `NULL` |

| **X** | **Y** | **X AND Y** | **X OR Y** |
|:---|:---|:---|:---|
| `true` | `true` | `true` | `true` |
| `true` | `false` | `false` | `true` |
| `false` | `false` | `false` | `false` |
| `true` | `NULL` | `NULL` | `true` |
| `false` | `NULL` | `false` | `NULL` |
| `NULL` | `NULL` | `NULL` | `NULL` |

### Other Clauses

* **JOIN**
* **GROUP BY**
* **HAVING**
* **ORDER BY**
* **LIMIT**, **OFFSET**

### Functions

* **ROW_NUMBER** returns the row index within each [partition](#partitioning).
* **INTERPOLATE** fills the gaps in an [irregular](#regularization) series.
* **INTERVAL_NUMBER** returns the interval index when multiple intervals are selected with [Interval Condition](#interval-condition).
* **LAST_TIME** returns [last insert](#last_time-syntax) time in milliseconds for each series.

### Data Types

| **Type Name** | **Type Alias** |
|---------|--------|
| BOOLEAN | - |
| DECIMAL | - |
| DOUBLE | - |
| FLOAT | - |
| INTEGER | - |
| BIGINT | LONG |
| SMALLINT | SHORT |
| VARCHAR | STRING |
| TIMESTAMP | - |
| JAVA_OBJECT | - |

The data type returned by the database for a given `value` column depends on the data type of the [metric](../api/meta/metric/list.md#data-types).

The `NUMBER` (parent type for all numeric data types) and `STRING` type can be used to convert data types with the [`CAST`](#cast) function.

The `BOOLEAN` type is produced by including boolean comparisons in the `SELECT` expression.

```sql
SELECT datetime, value, value > 0 AS Is_Positive
 FROM "mpstat.cpu_busy"
LIMIT 1
```

```ls
| datetime             | value | Is_Positive |
|----------------------|-------|-------------|
| 2017-04-17T07:29:04Z | 0     | false       |
```

### Comments

Comments can be inserted into SQL statements with `--` (two hyphens) and `/* */` (multi-line) to provide descriptive information about the query and its expected results.

```sql
-- comment single-line text

/*
  comment text on
  multiple lines
*/
```

Comments are not allowed after the statement termination character `;`.

## Processing Sequence

* **FROM** retrieves records from virtual tables.
* **JOIN** merges records from different tables.
* **WHERE** filters out records.
* **GROUP BY** assigns records to buckets (groups, sets).
* **HAVING** filters out the buckets.
* **SELECT** creates rows containing columns.
* **ORDER BY** sorts rows.
* **LIMIT** selects a subset of rows.

## Columns

### Predefined Columns

Virtual tables have the same pre-defined columns since all the underlying data is physically stored in a single partitioned table.

#### Series Columns

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`metric`         |string   | Metric name, same as virtual table name.|
|`entity`         |string   | Entity name.|
|`value`          |number   | Series numeric value.|
|`text`           |string   | Series text value.|
|`tags.{name}`    |string   | Series tag value. Returns `NULL` if the specified tag does not exist for this series.|
|`tags`           |string   | All series tags, concatenated to `name1=value;name2=value` format.|
|`tags.*`         |string   | Expands to multiple columns, each column containing a separate series tag.|
|`datetime`       |timestamp | Sample time in ISO 8601 format, for example `2017-06-10T14:00:15.020Z`.<br>In `GROUP BY PERIOD` queries, the `datetime` column returns the period's **start** time in ISO format, same as `date_format(PERIOD(...))`.|
|`time`           |long     | Sample time in Unix milliseconds since 1970-01-01T00:00:00Z, for example `1408007200000`.<br>In `GROUP BY PERIOD` queries, the `time` column returns the period's **start** time.|

#### Metric Columns

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`metric.name`    |string   | Metric name.|
|`metric.label`   |string   | Metric label.|
|`metric.description` |string| Metric description.|
|`metric.timeZone`|string   | Metric time zone.|
|`metric.interpolate` |string| Metric interpolation setting.|
|`metric.tags.{name}` |string| Metric tag value. Returns `NULL` if the specified tag doesn't exist for this metric.|
|`metric.tags`    |string   | All metric tags, concatenated to `name1=value;name2=value` format.|
|`metric.tags.*`  |string   | Expands to multiple columns, each column containing a separate metric tag.|
|`metric.dataType`|string   | [Data Type](../api/meta/metric/list.md#data-types).|
|`metric.timePrecision`|string| Time precision: SECONDS or MILLISECONDS.|
|`metric.enabled` |boolean  | Enabled status. Incoming data is discarded for disabled metrics.|
|`metric.persistent`  |boolean | Persistence status. Non-persistent metrics are not stored in the database and are only processed by the rule engine.|
|`metric.filter`  |string   | Persistence filter [expression](../api/meta/expression.md). Discards series that do not match this filter.|
|`metric.lastInsertTime`|string | Last time a value was received for this metric by any series. ISO date.|
|`metric.retentionIntervalDays`|integer | Number of days to retain values for this metric in the database.|
|`metric.versioning`|boolean | If set to true, enables versioning for the specified metric. <br>When metrics are versioned, the database retains the history of series value changes for the same timestamp along with `version_source` and `version_status`.|
|`metric.minValue`| double | Minimum value for [Invalid Action](../api/meta/metric/list.md#invalid-actions) trigger.|
|`metric.maxValue`| double | Maximum value for [Invalid Action](../api/meta/metric/list.md#invalid-actions) trigger.|
|`metric.invalidValueAction` | string | [Invalid Action](../api/meta/metric/list.md#invalid-actions) type.|
|`metric.units`| string | Measurement units. |

#### Entity Columns

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`entity.label`   |string   | Entity label.|
|`entity.timeZone`|string   | Entity time zone.|
|`entity.interpolate` |string| Entity interpolation setting.|
|`entity.tags.{name}` |string| Entity tag value. Returns `NULL` if the specified tag doesn't exist for this entity.|
|`entity.tags`    |string   | All entity tags, concatenated to `name1=value;name2=value` format.|
|`entity.groups`  |string   | List of entity groups, to which the entity belongs, separated by semi-colon `;`.|
|`entity.enabled` |boolean  | Enabled status. Incoming data is discarded for disabled entity.|

New columns can be created by applying functions and arithmetic expressions to existing columns. The computed columns can be included both in the `SELECT` expression, as well as in the `WHERE`, `HAVING`, and `ORDER BY` clauses.

```sql
SELECT t1.datetime, t1.entity, t1.value + t2.value AS cpu_sysusr
  FROM "mpstat.cpu_system" t1
  JOIN "mpstat.cpu_user" t2
WHERE t1.datetime >= '2017-06-15T00:00:00Z' 
  AND cpu_sysusr > 10
```

The list of all predefined columns can be requested with the `SELECT *` syntax, except for aggregation queries with the `GROUP BY` clause.

```sql
SELECT * FROM "mpstat.cpu_busy" WHERE datetime > current_minute LIMIT 1
```

```ls
| time          | datetime             | value | text | metric   | entity       | tags |
|---------------|----------------------|-------|------|----------|--------------|------|
| 1499177532000 | 2017-07-04T14:12:12Z | 5     | null | cpu_busy | nurswgvml007 | null |
```

`JOIN` queries with an asterisk return columns for all tables referenced in the query.

```sql
SELECT *
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime BETWEEN '2017-06-16T13:00:00Z' AND '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

```ls
| t1.time       | t1.datetime          | t1.value          | t1.text | t1.metric | t1.entity    | t1.tags | t2.time       | t2.datetime          | t2.value | t2.text | t2.metric | t2.entity    | t2.tags |
|---------------|----------------------|-------------------|---------|-----------|--------------|---------|---------------|----------------------|----------|---------|-----------|--------------|---------|
| 1497618006000 | 2017-06-16T13:00:06Z | 5.050000190734863 | null    | cpu_busy  | nurswgvml006 | null    | 1497618006000 | 2017-06-16T13:00:06Z | 78328    | null    | memfree   | nurswgvml006 | null    |
| null          | null                 | null              | null    | null      | null         | null    | 1497618021000 | 2017-06-16T13:00:21Z | 76980    | null    | memfree   | nurswgvml006 | null    |
```

In the case of a `JOIN` query, the `SELECT *` syntax can be applied to each table separately.

```sql
SELECT t1.datetime, t1.value, t2.*
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime BETWEEN '2017-06-16T13:00:00Z' AND '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

```ls
| t1.datetime          | t1.value          | t2.time       | t2.datetime          | t2.value | t2.text | t2.metric | t2.entity    | t2.tags |
|----------------------|-------------------|---------------|----------------------|----------|---------|-----------|--------------|---------|
| 2017-06-16T13:00:06Z | 5.050000190734863 | 1497618006000 | 2017-06-16T13:00:06Z | 78328    | null    | memfree   | nurswgvml006 | null    |
| null                 | null              | 1497618021000 | 2017-06-16T13:00:21Z | 76980    | null    | memfree   | nurswgvml006 | null    |
```

The `time` and `datetime` columns contain the same value (record time) in different data types and can be used interchangeably, for instance in the `GROUP BY` clause and the `SELECT` expression.

```sql
SELECT datetime, entity, count(*)   -- 'time' column in SELECT
  FROM "df.disk_used"
WHERE datetime BETWEEN '2017-06-15' AND '2017-06-15' -- 'datetime' column in WHERE
  GROUP BY time, entity             -- 'time' column in GROUP BY
```

The `SELECT` expression in `JOIN` queries can include both fully qualified column names such as `{table}.datetime` and short names `datetime` and `time` containing row timestamp calculated as `COALESCE(t1.datetime, t2.datetime, ...)`.

```sql
SELECT datetime, t1.datetime, t2.datetime
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime BETWEEN '2017-06-15T13:00:00Z' AND '2017-06-15T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

```ls
| datetime             | t1.datetime          | t2.datetime          |
|----------------------|----------------------|----------------------|
| 2017-06-15T13:00:01Z | 2017-06-15T13:00:01Z | null                 |
| 2017-06-15T13:00:12Z | null                 | 2017-06-15T13:00:12Z |
| 2017-06-15T13:00:17Z | 2017-06-15T13:00:17Z | null                 |
```

### Series Value Columns

Each series sample can contain a:

* Numeric value, accessible with the `value` column.
* String value, accessible with the `text` column.

The text value can be inserted with [`series`](../api/network/series.md#fields) command and the series [insert](../api/data/series/insert.md) method in Data API.

```ls
series d:2017-10-13T08:00:00Z e:sensor-1 m:temperature=20.3
series d:2017-10-13T08:15:00Z e:sensor-1 m:temperature=24.4 x:temperature="Provisional"
series d:2017-10-13T10:30:00Z e:sensor-1 x:status="Shutdown by adm-user, RFC-5434"
```

```sql
SELECT entity, metric, datetime, value, text
  FROM atsd_series
WHERE metric IN ('temperature', 'status') AND datetime >= '2017-06-15T08:00:00Z'
```

```ls
| entity   | metric      | datetime             | value | text                           |
|----------|-------------|----------------------|-------|--------------------------------|
| sensor-1 | temperature | 2017-06-15T08:00:00Z | 20.3  | null                           |
| sensor-1 | temperature | 2017-06-15T08:15:00Z | 24.4  | Provisional                    |
| sensor-1 | status      | 2017-06-15T10:30:00Z | NaN   | Shutdown by adm-user, RFC-5434 |
```

#### Numeric Precedence

If the `value` column in an `atsd_series` query returns numbers for metrics with different [data types](../api/meta/metric/list.md#data-types), the prevailing data type is determined based on the following rules:

1. If all data types are integers (`short`, `integer`, `long`), the prevailing integer type is returned.
2. If all data types are decimals (`float`, `double`, `decimal`), the prevailing decimal type is returned.
3. If the data types contain both integers and decimals, the `decimal` type is returned.

### Series Tag Columns

Tag values are referenced in the `SELECT` expression by specifying `tags.*`, `tags`, or `tags.{tag-name}` as the column name.

`tags` is a collection whose elements can be accessed by name. When specified in the `SELECT` expression, `tags.*` creates a column for each element in the collection.

If the property is not present, the `tags.{tag-name}` expression returns `NULL`.

```sql
SELECT datetime, entity, value, tags.*, tags, tags.mount_point, tags.file_system
  FROM "df.disk_used"
WHERE entity = 'nurswgvml010'
  AND datetime >= '2017-06-15T00:00:00Z'
  ORDER BY datetime
```

```ls
| datetime             | entity       | value         | tags.file_system | tags.mount_point | tags                                   | tags.mount_point | tags.file_system |
|----------------------|--------------|---------------|------------------|------------------|----------------------------------------|------------------|------------------|
| 2017-06-15T00:00:09Z | nurswgvml010 | 8348272.0000  | /dev/sda1        | /                | file_system=/dev/sda1;mount_point=/    | /                | /dev/sda1        |
| 2017-06-15T00:00:09Z | nurswgvml010 | 31899136.0000 | /dev/sdb1        | /app             | file_system=/dev/sdb1;mount_point=/app | /app             | /dev/sdb1        |
```

To filter records with or without specified series tags, use the `IS NOT NULL` or `IS NULL` operators.

The `tags` and `tags.{tag-name}` syntaxes can also be used in `WHERE`, `ORDER`, `GROUP BY` and other clauses.

```sql
SELECT entity, count(value), tags.*
 FROM "df.disk_used"
WHERE datetime >= NOW - 5*MINUTE
 AND entity = 'nurswgvml010'
 AND tags.mount_point = '/'
GROUP BY entity, tags
```

```ls
| entity       | count(value) | tags.mount_point | tags.file_system |
|--------------|--------------|------------------|------------------|
| nurswgvml010 | 20           | /                | /dev/sda1        |
```

### Entity Tag Columns

Entity tag values can be included in a `SELECT` expression by specifying `entity.tags.{tag-name}` or `{entity.tags}` as the column name.

`entity.tags` is a map object whose properties can be accessed with the `{tag-name}` key.

If there is no record for the specified key, the `entity.tags.{tag-name}` expression returns `NULL`.

```sql
SELECT entity, entity.tags.os, entity.tags.app, AVG(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR
  GROUP BY entity
```

```ls
| entity       | entity.tags.os | entity.tags.app       | AVG(value) |
|--------------|----------------|-----------------------|------------|
| nurswgvml006 | Linux          | Hadoop/HBASE          | 29.9       |
| nurswgvml007 | Linux          | ATSD                  | 32.4       |
| nurswgvml009 | null           | Oracle EM             | 35.9       |
| nurswgvml010 | Linux          | SVN, Jenkins, Redmine | 6.4        |
| nurswgvml011 | Linux          | HMC Simulator, mysql  | 5.6        |
| nurswgvml102 | Linux          | Router                | 1.5        |
| nurswgvml502 | null           | null                  | 16.3       |
```

To filter records with or without a specified entity tag, use the `IS NOT NULL` or `IS NULL` operators:

```sql
SELECT entity, entity.tags.os, entity.tags.app, AVG(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR
  AND entity.tags.os IS NULL
GROUP BY entity
```

```ls
| entity       | entity.tags.os | entity.tags.app | AVG(value) |
|--------------|----------------|-----------------|------------|
| nurswgvml009 | null           | Oracle EM       | 37.2       |
| nurswgvml502 | null           | null            | 15.4       |
```

### Metric Tag Columns

Metric tag values can be included in `SELECT` expressions by specifying `metric.tags.*`, `metric.tags`, or `metric.tags.{tag-name}` as the column name.

`metric.tags` is a map object whose properties can be accessed with the `{tag-name}` key.

If there is no record for the specified key, the `metric.tags.{tag-name}` expression returns `NULL`.

Metric tag columns are supported only in a `SELECT` expression.

```sql
SELECT entity, AVG(value), metric.tags.*, metric.tags, metric.tags.table
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR
  GROUP BY entity
```

```ls
| entity       | AVG(value) | metric.tags.source | metric.tags.table | metric.tags                | metric.tags.table |
|--------------|------------|--------------------|-------------------|----------------------------|-------------------|
| nurswgvml006 | 13.1       | iostat             | System            | source=iostat;table=System | System            |
| nurswgvml007 | 10.8       | iostat             | System            | source=iostat;table=System | System            |
| nurswgvml009 | 21.2       | iostat             | System            | source=iostat;table=System | System            |
```

### Entity Group Column

An `entity.groups` column contains a list of entity groups to which the entity belongs.

The column can be specified in the `SELECT` expression to print out the ordered list of entity group names, separated by semi-colons.

```sql
SELECT datetime, entity, value, entity.groups
  FROM "mpstat.cpu_busy"
WHERE entity LIKE 'nurswgvml00%'
  AND datetime >= CURRENT_HOUR
ORDER BY datetime
```

> Note that `LIKE` operator is case-**sensitive**.

```ls
| datetime             | entity       | value | entity.groups                            |
|----------------------|--------------|-------|------------------------------------------|
| 2017-06-15T15:00:06Z | nurswgvml009 | 3.0   | nur-collectors;nmon-linux                |
| 2017-06-15T15:00:07Z | nurswgvml007 | 44.7  | java-loggers;nur-collectors;nmon-linux   |
| 2017-06-15T15:00:16Z | nurswgvml006 | 4.0   | nur-collectors;nmon-linux;nmon-sub-group |
```

The `entity.groups` column can be referenced in the `WHERE` clause to filter results based on group membership.

Supported syntax:

```sql
entity.groups IN ('group-1', 'group-2') -- entity belongs to one of the groups listed in the IN clause
entity.groups NOT IN ('group-1', 'group-1') -- entity does NOT belong to any of the groups listed in the IN clause
'group-1' IN entity.groups -- entity belongs to the specified group
'group-1' NOT IN entity.groups -- entity does NOT belong to the specified group
```

Entity group names are case-sensitive.

```sql
SELECT datetime, entity, value, entity.groups
  FROM "mpstat.cpu_busy"
WHERE 'java-loggers' IN entity.groups
  AND datetime >= CURRENT_HOUR
ORDER BY datetime
```

```ls
| datetime             | entity       | value | entity.groups                            |
|----------------------|--------------|-------|------------------------------------------|
| 2017-06-15T15:00:07Z | nurswgvml007 | 44.7  | java-loggers;nur-collectors;nmon-linux   |
| 2017-06-15T15:00:21Z | nurswgvml102 | 4.0   | java-loggers;network-rtr                 |
```

### Group By Columns

In a `GROUP BY` query, `datetime` and `PERIOD()` columns return the same value (the period's start time) in ISO format. In this case, `date_format(PERIOD(5 MINUTE))` can be replaced with `datetime` in the `SELECT` expression.

```sql
SELECT entity, datetime, date_format(PERIOD(5 MINUTE)), AVG(value)
  FROM "mpstat.cpu_busy"
WHERE time >= CURRENT_HOUR AND time < NEXT_HOUR
  GROUP BY entity, PERIOD(5 MINUTE)
```

Columns referenced in the `SELECT` expression must be included in the `GROUP BY` clause.

## Literals

The literal is a constant value specified in the query, such as `'nurswvml007'`, `75`, or `'2017-08-15T00:00:00Z'`. The database supports literals for `string`, `timestamp`, and `number` data types.

```sql
-- string literal
WHERE entity = 'nurswgvml007'

-- timestamp literal
WHERE datetime >= '2017-08-15T00:00:00Z'

-- number literal
WHERE value < 75
```

The string and timestamp literals must be enclosed in **single** quotation marks.

A literal value containing single quotes can be escaped by doubling the single quote symbol.

```sql
-- literal = a'b
WHERE entity LIKE '%a''b%'
-- literal = yyyy-mm-dd'T'HH:mm:ss'Z'
SELECT date_format(time, 'yyyy-mm-dd''T''HH:mm:ss''Z''')
```

## Identifiers

Use **double quotation marks** to enquote a table name, column name, and alias if it contains a reserved column name, a [keyword](#keywords), a function name, or a special character including whitespace, `.`,`+`,`-`,`*`,`/`,`,`,`"`,`'`.

```sql
-- Special character
SELECT entity.tags."file-system" FROM "disk.io" 

-- Reserved column name
SELECT value*5 AS "value"

-- SQL identifier
SELECT tags.action AS "select"

-- Function name: avg
SELECT * FROM "avg"
```

Double quotes in identifiers can be escaped by doubling the quote symbol.

```sql
-- column alias: The "main" entity
SELECT entity AS "The ""main"" entity"

-- series tag: hello"world
SELECT tags."hello""world"
```

## Aliases

Table and column aliases can be unquoted or enclosed in double quotation marks.

Unquoted alias should start with letter `[a-zA-Z]`, followed by a letter, digit or underscore.

The `AS` keyword is optional.

```sql
SELECT tbl.value*100 AS "cpu_percent", tbl.datetime "sample-date"
  FROM "mpstat.cpu_busy" tbl
WHERE datetime >= NOW - 1*MINUTE
  ORDER BY "sample-date"
```

For aliased columns, the underlying column and table names, or expression text, are included in table schema section of the metadata.

```json
"tableSchema": {
  "columns": [{
  "columnIndex": 1,
  "name": "cpu_percent",
  "titles": "tbl.value*100",
  "datatype": "float",
  "table": "tbl"
  }, {
  "columnIndex": 2,
  "name": "sample-date",
  "titles": "datetime",
  "datatype": "xsd:dateTimeStamp",
  "table": "tbl",
  "propertyUrl": "atsd:datetime",
  "dc:description": "Sample time in ISO8601 format"
  }]
}
```

## Arithmetic Operators

Arithmetic operators, including `+`, `-`, `*`, `/`, and `%` (modulo) can be applied to one or multiple numeric columns.

```sql
SELECT datetime, SUM(value), SUM(value + 100) / 2
  FROM gc_invocations_per_minute
WHERE datetime >= NOW - 10*MINUTE
  GROUP BY period(2 MINUTE)
```

```sql
SELECT AVG(metric1.value*2), SUM(metric1.value + metric2.value)
  FROM metric1
  JOIN metric2
WHERE metric1.datetime >= NOW - 10*MINUTE
```

The modulo operator `%` returns the remainder of one number divided by another, for instance `14 % 3` (= 2).

## Match Expressions

### IN Expression

The `IN` expression returns `true` if the value on the left is equal to one of the comma-separated values enumerated in parentheses after the `IN` operator.

```sql
valueLeft [NOT] IN (valueRight [, valueRight])
```

The `IN` operator provides an alternative to multiple OR conditions.

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity IN ('nurswgvml006', 'nurswgvml007', 'nurswgvml008')
  -- entity = 'nurswgvml006' OR entity = 'nurswgvml007' OR entity = 'nurswgvml008'
```

### LIKE Expression

The `LIKE` expression returns true if the value matches the specified string pattern which supports `%` and `_` wildcards. 

* Percent sign `%` matches zero or more characters in the value.

* Underscore `_` matches exactly one character in the value.

The comparison is case-**sensitive**, including **entity and metric** names which are converted to lower case when stored in the database.

```sql
SELECT datetime, entity, value, tags.mount_point, tags.file_system
  FROM "df.disk_used_percent"
WHERE tags.file_system LIKE '/dev/%'
  AND datetime >= PREVIOUS_HOUR
```

Wildcard symbols present in the pattern can be escaped with a backslash `\` which serves as the default escape character.

```sql
-- Default escape character
WHERE tags.file_system LIKE '%a\_b%'
```

The escape character can be customized by adding an `ESCAPE` clause after the `LIKE` expression.

```sql
-- Custom escape character
WHERE tags.file_system LIKE '%a~_b%' ESCAPE '~'
```

In the example above, the underscore is evaluated as a regular character (not as a wildcard) because it is preceded by an `~` escape character.

### REGEX Expression

The `REGEX` expression matches column value against a [regular expression](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html) and returns `true` if the text is matched.

The comparison is case-sensitive, even for entity and metric names.

```sql
SELECT datetime, entity, value, tags.mount_point, tags.file_system
  FROM "df.disk_used_percent"
  WHERE tags.file_system REGEX '.*map.*|.*mnt.*'
  AND datetime >= NOW - 1*HOUR
```

`REGEX` can be used to match one of multiple conditions as an alternative to multiple `LIKE` expressions.

```sql
WHERE entity = 'nurswgvml007'
  AND (tags.file_system LIKE '%map%'
    OR tags.file_system LIKE '%mnt%'
    OR tags.file_system LIKE '%dev%')
```

```sql
WHERE entity = 'nurswgvml007'
   AND tags.file_system REGEX '.*map.*|.*mnt.*|.*dev.*'
```

Special constructs such as `(?i)` can be applied to enable a [case-insensitive match](http://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html#CASE_INSENSITIVE) as an example.

```sql
  WHERE entity REGEX '(?i)Nurswgvml00.*'
```

## Interval Condition

An interval condition determines the selection interval and is specified in the `WHERE` clause using the `datetime` or `time` columns.

* The `datetime` column accepts literal dates in one of the following formats:

| **Format** | **Time Zone** | **Examples** |
|---|---|---|
| `yyyy-MM-dd'T'HH:mm:ss[.NNN](Z\|±hh:mm)` | As specified | `2017-12-10T15:30:00.077Z`<br>`2017-12-10T15:30:00Z`<br>`2017-12-10T15:30:00-05:00` |
| `yyyy-MM-dd HH:mm:ss[.NNNNNNNNN]`| Database  | `2017-12-10 15:30:00.077`<br>`2017-12-10 15:30:00` |
| `yyyy[-MM[-dd]]`| Database  | `2017`<br>`2017-12`<br>`2017-12-15` |

The UTC time zone is specified as the `Z` suffix ("Zulu time") or as the zero UTC offset `+00:00`. If the time zone is not specified in the literal value, the database time zone is used to convert strings into date objects.

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE datetime BETWEEN '2017-12-10T14:00:15Z' AND '2017-12-10T14:30:00.077Z'
-- WHERE datetime BETWEEN '2017-12-10 14:00:15' AND '2017-12-11 14:30:00.077'
-- WHERE datetime = '2017'
```

* The `time` column accepts Unix milliseconds:

```sql
SELECT time, entity, value
  FROM "mpstat.cpu_busy"
WHERE time >= 1500300000000
-- 1500300000000 is equal to 2017-07-17 14:00:00 UTC
```

> Note that the `BETWEEN` operator is inclusive: `time BETWEEN 'a' AND 'b'` is equivalent to `time >= 'a' and time <= 'b'`.

### Optimizing Interval Queries

Using the [`date_format`](#date-formatting-functions) and [`EXTRACT`](#extract) functions in the `WHERE` condition and the `GROUP BY` clause may not be efficient as it causes the database to perform a full scan while comparing literal strings or numbers. Instead, filter dates using the indexed `time` or `datetime` column and apply the `PERIOD` function to aggregate records by interval.

```sql
WHERE date_format(time, 'yyyy') > '2018'   -- Slow: full scan with string comparison.
WHERE YEAR(time) > 2018                    -- Slow: full scan with number comparison.
WHERE datetime >= '2018'                   -- Fast: date range scan using an indexed column.
WHERE datetime >= '2018-01-01T00:00:00Z'   -- Fast: date range scan using an indexed column.

GROUP BY date_format(time, 'yyyy')         -- Slow.
GROUP BY YEAR(time)                        -- Slow.
GROUP BY PERIOD(1 YEAR)                    -- Fast.
```

### Calendar Expressions

The `time` and `datetime` columns support [calendar](../shared/calendar.md) keywords and expressions.

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE time >= NOW - 15 * MINUTE
  AND datetime < CURRENT_MINUTE
```

The calendar expressions are evaluated according to the database [time zone](../shared/timezone-list.md) which can be customized using the [`endtime`](#endtime) function.

```sql
SELECT value, datetime,
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'UTC') AS "UTC_datetime",
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'US/Pacific') AS "PST_datetime"
FROM "mpstat.cpu_busy"
  WHERE entity = 'nurswgvml007'
AND datetime BETWEEN endtime(YESTERDAY, 'US/Pacific') AND endtime(CURRENT_DAY, 'US/Pacific')
  ORDER BY datetime
```

```ls
| value | datetime             | UTC_datetime           | PST_datetime           |
|-------|----------------------|------------------------|------------------------|
| 6.86  | 2017-06-16T07:00:05Z | 2017-06-16T07:00:05UTC | 2017-06-16T00:00:05PDT |
| 6.06  | 2017-06-16T07:00:21Z | 2017-06-16T07:00:21UTC | 2017-06-16T00:00:21PDT |
  ....
| 3.03  | 2017-06-17T06:59:29Z | 2017-06-17T06:59:29UTC | 2017-06-16T23:59:29PDT |
| 2.97  | 2017-06-17T06:59:45Z | 2017-06-17T06:59:45UTC | 2017-06-16T23:59:45PDT |
```

### Local Time Boundaries

To specify the interval range in local time, use the `date_parse` function to convert the `timestamp` literal into Unix milliseconds.

```sql
SELECT datetime as utc_time, date_format(time, 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna') AS local_datetime, value
  FROM "mpstat.cpu_busy"
  WHERE entity = 'nurswgvml007'
    AND time >= date_parse('2017-06-15 12:00:00', 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna')
    AND  time < date_parse('2017-06-18 12:00:00', 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna')
```

```ls
| utc_time            | local_datetime      | value  |
|---------------------|---------------------|--------|
| 2017-06-15 10:00:15 | 2017-06-15 12:00:15 | 4.9500 |
| 2017-06-15 10:00:31 | 2017-06-15 12:00:31 | 3.0000 |
| 2017-06-15 10:00:47 | 2017-06-15 12:00:47 | 3.0900 |
```

Converting a date to milliseconds and comparing it to the time column is more efficient than comparing formatted strings:

```sql
  date_format(time, 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna') >= '2017-05-01 12:00:00'
```

### Entity Time Zone

To select rows for a date range based on each entity's local time zone, supply `entity.timeZone` column as an argument to the `endtime` function.

```sql
SELECT entity, entity.timeZone,
  AVG(value),
  date_format(time, 'yyyy-MM-dd HH:mm z', 'UTC') AS "Period Start: UTC datetime",
  date_format(time, 'yyyy-MM-dd HH:mm z', entity.timeZone) AS "Period Start: Local datetime"
FROM "mpstat.cpu_busy"
  WHERE datetime >= ENDTIME(PREVIOUS_DAY, entity.timeZone) 
    AND datetime < ENDTIME(CURRENT_DAY, entity.timeZone)
GROUP BY entity, PERIOD(1 DAY, entity.timeZone)
```

```ls
| entity       | entity.timeZone | avg(value) | Period Start: UTC datetime | Period Start: Local datetime | 
|--------------|-----------------|------------|----------------------------|------------------------------| 
| nurswgvml007 | PST             | 12.3       | 2017-08-17 07:00 UTC       | 2017-08-17 00:00 PDT         | 
| nurswgvml006 | US/Mountain     | 9.2        | 2017-08-17 06:00 UTC       | 2017-08-17 00:00 MDT         | 
| nurswgvml010 | null            | 5.8        | 2017-08-17 00:00 UTC       | 2017-08-17 00:00 GMT         | 
```

### Multiple Intervals

Multiple time intervals can be selected using the `OR` operator.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND (datetime BETWEEN '2017-04-02T14:00:00Z' AND '2017-04-02T14:01:00Z'
    OR datetime BETWEEN '2017-04-04T16:00:00Z' AND '2017-04-04T16:01:00Z')
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-02T14:00:04Z | 80.8  | start
| 2017-04-02T14:00:20Z | 64.7  |
| 2017-04-02T14:00:36Z | 5.0   |
| 2017-04-02T14:00:52Z | 100.0 | end
| 2017-04-04T16:00:06Z | 54.6  | start
| 2017-04-04T16:00:22Z | 6.0   |
| 2017-04-04T16:00:38Z | 81.0  |
| 2017-04-04T16:00:54Z | 38.8  | end
```

Multiple intervals are treated separately for the purpose of interpolating and regularizing values.
In particular, the values between such intervals are not interpolated.

### Interval Subqueries

As an alternative to specifying the lower and upper boundaries manually, the `BETWEEN` operator retrieves the time range with a [subquery](examples/filter-by-date.md#query-using-between-subquery).

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN (SELECT datetime FROM "maintenance-rfc"
  WHERE entity = 'nurswgvml007'
ORDER BY datetime)
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-03T01:00:09Z | 24.0  |
| 2017-04-03T01:00:25Z | 55.0  |
...
| 2017-04-03T01:14:17Z | 4.0   |
| 2017-04-03T01:14:33Z | 4.1   |
| 2017-04-03T01:14:49Z | 63.0  |
```

## Period

Period is a repeating time interval used to group values occurring within each interval into buckets in order to apply aggregation functions.

Period syntax:

```sql
PERIOD({count} {unit} [, option])
```

`option` = `interpolate` | `align` | `extend` | `timezone`

* `interpolate` = PREVIOUS | NEXT | LINEAR | VALUE {number}
* `extend` = EXTEND
* `align` = START_TIME, END_TIME, FIRST_VALUE_TIME, CALENDAR
* `timezone` = [Time Zone ID](../shared/timezone-list.md) as literal string, or `entity.timeZone`/`metric.timeZone` column.

The options are separated by a comma and can be specified in any order.

```sql
PERIOD(5 MINUTE)
PERIOD(5 MINUTE, END_TIME)
PERIOD(5 MINUTE, CALENDAR, VALUE 0)
PERIOD(1 HOUR, LINEAR, EXTEND)
PERIOD(1 DAY, "US/Eastern")
PERIOD(1 DAY, entity.timeZone)
```

| **Name** | **Description** |
|:---|:---|
| `count` | [**Required**] Number of time units contained in the period. |
| `unit` | [**Required**] [Time unit](../api/data/series/time-unit.md) such as `HOUR`, `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`. |
| `interpolate` | Apply an [interpolation function](#interpolation), such as `LINEAR` or `VALUE 0`, to add missing periods.|
| `extend` | Add missing periods at the beginning and end of the selection interval using `VALUE {n}` or the `PREVIOUS` and `NEXT` interpolation functions.|
| `align` | Align the period's start/end. Default: `CALENDAR`. <br>Possible values: `START_TIME`, `END_TIME`, `FIRST_VALUE_TIME`, `CALENDAR`.<br>Refer to [period alignment](#period-alignment).|
| `timezone` | Time zone for aligning periods in `CALENDAR` mode, such as `'US/Eastern'`, `'UTC'`, or `entity.timeZone`.<br>Default value: current database time zone.|

```sql
SELECT entity, date_format(PERIOD(5 MINUTE, END_TIME)), AVG(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR AND datetime < NEXT_HOUR
  GROUP BY entity, PERIOD(5 MINUTE, END_TIME)
```

The period specified in the `GROUP BY` clause can be entered without option fields in the `SELECT` expression.

```sql
SELECT entity, PERIOD(5 MINUTE), AVG(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR AND datetime < NEXT_HOUR
  GROUP BY entity, PERIOD(5 MINUTE, END_TIME)
```

In grouping queries, the `time` column returns the same value as `PERIOD()`, and `datetime` returns the same value as `date_format(PERIOD())`.

```sql
SELECT entity, datetime, AVG(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR AND datetime < NEXT_HOUR
  GROUP BY entity, PERIOD(5 MINUTE, END_TIME)
```

### Period Alignment

The default `CALENDAR` setting creates calendar-aligned periods using the **duration** specified in the `PERIOD` function.

For example, `period(1 HOUR)` initializes 1-hour long periods starting at `0` minutes of each hour within the selection interval.

| **Alignment** | **Description**|
|:---|:---|
| `CALENDAR` | Period starts are aligned to the calendar. |
| `START_TIME` | First period begins at start time specified in the query. |
| `FIRST_VALUE_TIME` | First period begins at the time of first retrieved value. |
| `END_TIME` | Last period ends on end time specified in the query. |

* For the `START_TIME` and `END_TIME` options, the `WHERE` clause must contain the start and end time of the selection interval, respectively.

```sql
SELECT entity, datetime, COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= now-1*HOUR AND datetime < now
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 MINUTE, END_TIME)
```

#### `CALENDAR` Alignment

The `CALENDAR` alignment calculates the initial period according to the rules below and creates subsequent periods by incrementing the duration specified by the `PERIOD` function. The initial period is defined as the earliest period that intersects with the selection interval.

* The start time of a selection interval is rounded to calculate the _base time_ using the rule table below.
* If the period starting with the _base time_ intersects with the selection interval, it becomes the initial period.
* Otherwise, the period starting with _base time_ is incremented (decremented if _base time_ exceeds start time) to find the earliest period intersecting with the selection interval. This period becomes the initial period.

**Rounding Rules**

| **Time Unit**   | **Base Time (Rounded)** |
|-------------|-----------|
| MILLISECOND | 0m:0s in a given hour. |
| SECOND | 0m:0s in a given hour. |
| MINUTE | 0m:0s in a given hour. |
| HOUR | 0h:0m:0s on a given day. |
| DAY | 0h:0m:0s on the 1st day in a given month. |
| WEEK | 0h:0m:0s on the 1st Monday in a given month. |
| MONTH | 0h:0m:0s on January 1st in a given year. |
| QUARTER | 0h:0m:0s on January 1st in a given year. |
| YEAR | 0h:0m:0s on January 1st, 1970. |

Examples:

```ls
| Period     | Start Time        | End Time          | _base time_       | Initial Period    | 2nd Period        | Last Period      |
|------------|-------------------|-------------------|-------------------|-------------------|-------------------|------------------|
| 45 MINUTE  | 2017-06-20 15:05  | 2017-06-24 00:00  | 2017-06-20 15:00  | 2017-06-20 15:00  | 2017-06-20 15:45  | 2017-06-23 23:15 |
| 45 MINUTE  | 2017-06-20 15:00  | 2017-06-24 00:00  | 2017-06-20 15:00  | 2017-06-20 15:00  | 2017-06-20 15:45  | 2017-06-23 23:15 |
| 45 MINUTE  | 2017-06-20 15:55  | 2017-06-24 00:00  | 2017-06-20 15:00  | 2017-06-20 15:45  | 2017-06-20 16:30  | 2017-06-23 23:15 |
| 60 MINUTE  | 2017-06-20 15:30  | 2017-06-24 00:00  | 2017-06-20 15:00  | 2017-06-20 15:00  | 2017-06-20 16:00  | 2017-06-23 23:00 |
| 1 HOUR     | 2017-06-20 15:30  | 2017-06-24 00:00  | 2017-06-20 00:00  | 2017-06-20 15:00  | 2017-06-20 16:00  | 2017-06-23 23:00 |
| 1 HOUR     | 2017-06-20 16:00  | 2017-06-24 00:00  | 2017-06-20 00:00  | 2017-06-20 16:00  | 2017-06-20 17:00  | 2017-06-23 23:00 |
| 1 HOUR     | 2017-06-20 16:05  | 2017-06-23 23:55  | 2017-06-20 00:00  | 2017-06-20 16:00  | 2017-06-20 17:00  | 2017-06-23 23:00 |
| 7 HOUR     | 2017-06-20 16:00  | 2017-06-24 00:00  | 2017-06-20 00:00  | 2017-06-20 14:00  | 2017-06-20 21:00  | 2017-06-23 19:00 |
| 10 HOUR    | 2017-06-20 16:00  | 2017-06-24 00:00  | 2017-06-20 00:00  | 2017-06-20 10:00  | 2017-06-20 20:00  | 2017-06-23 18:00 |
| 1 DAY      | 2017-06-01 16:00  | 2017-06-24 00:00  | 2017-06-01 00:00  | 2017-06-01 00:00  | 2017-06-02 00:00  | 2017-06-23 00:00 |
| 2 DAY      | 2017-06-01 16:00  | 2017-06-24 00:00  | 2017-06-01 00:00  | 2017-06-01 00:00  | 2017-06-03 00:00  | 2017-06-23 00:00 |
| 5 DAY      | 2017-06-01 16:00  | 2017-06-24 00:00  | 2017-06-01 00:00  | 2017-06-01 00:00  | 2017-06-11 00:00  | 2017-06-21 00:00 |
| 1 WEEK     | 2017-06-01 16:00  | 2017-06-24 00:00  | 2017-06-06 00:00  | 2017-05-30 00:00  | 2017-06-06 00:00  | 2017-06-20 00:00 |
| 1 WEEK     | 2017-06-07 16:00  | 2017-06-24 00:00  | 2017-06-06 00:00  | 2017-06-06 00:00  | 2017-06-13 00:00  | 2017-06-20 00:00 |
| 1 WEEK     | 2017-05-01 16:00  | 2017-05-24 00:00  | 2017-05-02 00:00  | 2017-04-25 00:00  | 2017-05-02 00:00  | 2017-05-23 00:00 |
| 1 WEEK     | 2017-06-01 00:00  | 2017-06-02 00:00  | 2017-06-06 00:00  | 2017-05-30 00:00  | -                 | -                |
```

For `DAY`, `WEEK`, `MONTH`, `QUARTER`, and `YEAR` units, the start of the day is determined according to the **database time zone**, unless a user-defined time zone is specified as an option, for example `GROUP BY entity, PERIOD(1 MONTH, 'UTC')`.

#### `END_TIME` Alignment

* If the end time in the query is inclusive, 1 millisecond is added to the period end time since the period end time must be exclusive.

```sql
SELECT entity, datetime, COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2017-06-18T10:02:00Z' AND datetime < '2017-06-18T10:32:00Z'
  AND entity = 'nurswgvml007'
GROUP BY entity, PERIOD(10 MINUTE, END_TIME)
```

```ls
| entity       | datetime                 | COUNT(value) |
|--------------|--------------------------|--------------|
| nurswgvml007 | 2017-06-18T10:02:00.000Z | 38.0         |
| nurswgvml007 | 2017-06-18T10:12:00.000Z | 37.0         |
| nurswgvml007 | 2017-06-18T10:22:00.000Z | 38.0         |
```

```sql
SELECT entity, datetime, COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2017-06-18T10:02:00Z' AND datetime <= '2017-06-18T10:32:00Z'
  AND entity = 'nurswgvml007'
GROUP BY entity, PERIOD(10 MINUTE, END_TIME)
```

```ls
| entity       | datetime                 | COUNT(value) |
|--------------|--------------------------|--------------|
| nurswgvml007 | 2017-06-18T10:02:00.001Z | 38.0         |
| nurswgvml007 | 2017-06-18T10:12:00.001Z | 37.0         |
| nurswgvml007 | 2017-06-18T10:22:00.001Z | 38.0         |
```

#### `START_TIME` Alignment

1 millisecond is added to the period start if the start time in the query is exclusive.

```sql
SELECT entity, datetime, COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime > '2017-06-18T10:02:00Z' AND datetime < '2017-06-18T10:32:00Z'
  AND entity = 'nurswgvml007'
GROUP BY entity, PERIOD(10 MINUTE, START_TIME)
```

```ls
| entity       | datetime                 | COUNT(value) |
|--------------|--------------------------|--------------|
| nurswgvml007 | 2017-06-18T10:02:00.001Z | 38.0         |
| nurswgvml007 | 2017-06-18T10:12:00.001Z | 37.0         |
| nurswgvml007 | 2017-06-18T10:22:00.001Z | 38.0         |
```

## Interpolation

By default, if a period specified in the `GROUP BY` clause does not contain any detailed values, it will be excluded from the results.

The behavior can be changed by referencing an interpolation function as part of the `PERIOD` function.

| **Name** | **Description** |
|:---|:---|
| `PREVIOUS` | Set value for the period based on the previous period's value. |
| `NEXT` | Set value for the period based on the next period's value. |
| `LINEAR` | Calculate period value using linear interpolation between previous and next period values. |
| `VALUE {d}`| Set value for the period to constant number `d`. |

```sql
SELECT entity, period(5 MINUTE), AVG(value)
  FROM "mpstat.cpu_busy"
  WHERE datetime >= CURRENT_HOUR
GROUP BY entity, period(5 MINUTE, LINEAR)
```

### `EXTEND` Option

Include an optional `EXTEND` parameter to the `PERIOD` function to append missing periods at the beginning and the end of the selection interval.

Leading and trailing period values are set with the `VALUE {n}` function if such a function is specified.

```sql
period(5 MINUTE, VALUE 0, EXTEND)
```

Otherwise, in absence of the `VALUE {n}` function, the `EXTEND` option sets period values at the beginning of the interval with the `NEXT` function, whereas values at the end are set with the `PREVIOUS` function.

```sql
SELECT entity, period(5 MINUTE), AVG(value)
  FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_HOUR
GROUP BY entity, period(5 MINUTE, LINEAR, EXTEND)
```

### Interpolation Examples

- [Interpolate](examples/interpolate.md)
- [Interpolate Edges](examples/interpolate-edges.md)
- [Interpolate with Extend](examples/interpolate-extend.md)
- [ChartLab](https://apps.axibase.com/chartlab/d8c03f11/3/)

## Regularization

The `WITH INTERPOLATE` clause provides a way to transform unevenly spaced time series into a regular series.

The underlying transformation applies a linear interpolation or step function to calculate values at regular intervals.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= '2017-09-17T08:00:00Z' AND datetime < '2017-09-17T08:02:00Z'
WITH INTERPOLATE(30 SECOND)
```

```ls
| raw time             | regular time         |
|----------------------|----------------------|
| 2017-09-17T08:00:00Z | 2017-09-17T08:00:00Z |
| ...........08:00:26Z | ...........08:00:30Z |
| ...........08:01:14Z | ...........08:01:00Z |
| ...........08:01:30Z | ...........08:01:30Z |
```

### Syntax

```sql
WITH INTERPOLATE (period [, inter_func[, boundary[, fill [, alignment[, timezone]]]]])
```

The `WITH INTERPOLATE` clause is included prior to the `ORDER BY` and `LIMIT` clauses.

If the query retrieves multiple series, the interpolation is applied to each series separately.

If the `WHERE` condition includes multiple date ranges, the interpolation is performed for each date range and series separately.

**Example**:

```sql
WITH INTERPOLATE (1 MINUTE, LINEAR, OUTER, VALUE NAN, START_TIME)
```

**Parameters**:

| **Name** | **Description**|
|:---|:---|
| `period` | Regular interval for aligning interpolated values. |
| `inter_func` | Interpolation function to calculate values at regular timestamps based on adjacent values. Default: `LINEAR`.|
| `boundary` | Retrieval of raw values outside of the selection interval to interpolate leading and trailing values. Default: `INNER`. |
| `fill` | Method for filling missing values at the beginning and the end of the selection interval. Default: `FALSE`. |
| `alignment` | Aligns regular timestamps based on calendar or start time. Default: `CALENDAR`. |
| `timezone` | Time zone applied in `CALENDAR` alignment to periods equal or greater than 1 day. |

[![](images/chartlab.png)](https://apps.axibase.com/chartlab/712f37cb)

![INTERPOLATE Parameters](images/regularize_sinusoid.png)

### Interpolation Period

The interpolation period is specified as a `count unit`, for example `5 MINUTE`, or `DETAIL`.

| **Name** | **Description** |
|:---|:---|
| count | [**Required**] Number of time units contained in the period. |
| unit | [**Required**] [Time unit](../api/data/series/time-unit.md) such as `HOUR`, `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`. |

The `DETAIL` mode can be used to fill missing values in `FULL OUTER JOIN` queries while retaining the original timestamps of the merged series.

### Interpolation Function

| **Name** | **Description**|
|:---|:---|
| `LINEAR` | Calculates the value at the desired timestamp by linearly interpolating prior and next values.|
| `PREVIOUS` | Sets the value at the desired timestamp based on the previously recorded raw value.<br>This step-like function is appropriate for metrics with discrete values (digital signals).|
| `AUTO` | [**Default**] Applies an interpolation function (`LINEAR` or `PREVIOUS`) based on the metric Interpolation setting.<br>If multiple metrics are specified in the query, `AUTO` applies its own interpolation mode for each metric.  |

* NaN (Not-A-Number) values are ignored from interpolation.
* The `value` condition in the `WHERE` clause applies to interpolated series values instead of raw values. Filtering out raw values prior to interpolation is not supported.

### Boundary

| **Name** | **Description**|
|:---|:---|
| `INNER` | [**Default**] Performs calculations based on raw values located within the specified selection interval. |
| `OUTER` | Retrieves prior and next raw values outside of the selection interval in order to interpolate leading and trailing values. |

### Fill

| **Name** | **Description**|
|:---|:---|
| `FALSE` | [**Default**] No missing values are filled. The rows for periods without interpolated values are not included in the result. |
| `TRUE` | Missing values at the beginning of the interval are set to first raw value within the interval.<br>Missing values at the end of the interval are set to last raw value within the interval.<br>This option requires that both start and end time are specified in the query. |
| `VALUE {n}` | Sets missing values to `{n}` which can be a decimal number or a `NAN` (Not a Number)<br>For example: `VALUE 0` or `VALUE NAN`. |

### Alignment

| **Name** | **Description**|
|:---|:---|
| `CALENDAR` | [**Default**] Aligns regular timestamps according to the specified time zone. If time zone is not specified, the interval is split into periods based on the database time zone. |
| `START_TIME` | Starts regular timestamps at the start time of the selection interval.<br>This option requires that both start and end time are specified in the query. |

### Interpolation Time Zone

| **Name** | **Description**|
|:---|:---|
| `null` | [**Default**] The database time zone is used to split the selection interval into periods greater than 1 day. |
| `timezone id` | The literal string with the time zone [identifier](../shared/timezone-list.md). |
| `entity.timeZone` or<br>`metric.timeZone` | The time zone of the entity or metric. |

### Regularization Examples

- [LINEAR Function](examples/regularize.md#interpolation-function-linear)
- [PREVIOUS (Step) Function](examples/regularize.md#interpolation-function-previous)

## Grouping

The `GROUP BY` clause groups records into rows that have matching values for the specified grouping columns.

```sql
SELECT entity, AVG(value) AS Cpu_Avg
  FROM "mpstat.cpu_busy"
WHERE entity IN ('nurswgvml007', 'nurswgvml006', 'nurswgvml011')
  AND datetime >= CURRENT_HOUR
GROUP BY entity
```

```ls
| entity       | Cpu_Avg |
|--------------|---------|
| nurswgvml006 | 99.8    |
| nurswgvml007 | 15.2    |
| nurswgvml011 | 5.7     |
```

A special grouping column `PERIOD` calculates the start and end of the period to which the record belongs.

```sql
SELECT datetime, AVG(value) AS Cpu_Avg
  FROM "mpstat.cpu_busy"
WHERE entity IN ('nurswgvml007', 'nurswgvml006', 'nurswgvml011')
  AND datetime >= CURRENT_HOUR
GROUP BY period(5 MINUTE)
```

```ls
| datetime             | Cpu_Avg |
|----------------------|---------|
| 2017-06-18T22:00:00Z | 43.2    |
| 2017-06-18T22:05:00Z | 35.3    |
| 2017-06-18T22:10:00Z | 5.0     |
```

### HAVING filter

The `HAVING` clause filters grouped rows. It eliminates grouped rows that do not match the specified condition which may contain one or multiple aggregation functions.

```sql
HAVING aggregation_function operator value
```

```sql
SELECT entity, AVG(value) AS Cpu_Avg
  FROM "mpstat.cpu_busy"
WHERE entity IN ('nurswgvml007', 'nurswgvml006', 'nurswgvml011')
  AND datetime >= CURRENT_HOUR
GROUP BY entity
  HAVING AVG(value) > 10
```

```ls
| entity       | Cpu_Avg |
|--------------|---------|
| nurswgvml006 | 99.8    |
| nurswgvml007 | 14.3    |
```

```sql
HAVING AVG(value) > 10 OR MAX(value) > 90
```

## Partitioning

Partitioning is implemented with the `ROW_NUMBER` function, which returns the sequential number of a row within a partition, starting with 1 for the first row in each partition.

A partition is a subset of all rows within the result set, grouped by an entity and/or series tags. Each row in the result set may belong to only one partition.

For example, a result set partitioned by entity and ordered by time would have the following row numbers:

```ls
|--------------|----------------------|-------| ROW_NUMBER
| nurswgvml006 | 2017-06-18T12:00:05Z | 66.0  |     1
| nurswgvml006 | 2017-06-18T12:00:21Z | 8.1   |     2
| nurswgvml007 | 2017-06-18T12:00:03Z | 18.2  |     1
| nurswgvml007 | 2017-06-18T12:00:19Z | 67.7  |     2
| nurswgvml010 | 2017-06-18T12:00:14Z | 0.5   |     1
| nurswgvml011 | 2017-06-18T12:00:10Z | 100.0 |     1
| nurswgvml011 | 2017-06-18T12:00:26Z | 4.0   |     2
| nurswgvml011 | 2017-06-18T12:00:29Z | 0.0   |     3
```

### ROW_NUMBER Syntax

```sql
ROW_NUMBER({partitioning columns} ORDER BY {ordering columns [direction]})
```

The `{partitioning columns}` clause is one or multiple columns for splitting the rows, for example `entity`, `tags`, or `entity, tags`.

The `{ordering columns [direction]}` can be any columns of the `FROM` clause with an optional `ASC/DESC` direction.

Examples:

* `ROW_NUMBER(entity ORDER BY time)`

* `ROW_NUMBER(entity, tags ORDER BY time DESC)`

* `ROW_NUMBER(value ORDER BY value DESC)`

* `ROW_NUMBER(entity, tags ORDER BY time DESC, AVG(value))`

The `ROW_NUMBER(entity, tags ...)` grouping effectively creates a partition for each series.

The assigned row numbers can be used to filter rows within each partition for the following use cases:

* Return Top (`ORDER BY value DESC`) or Most Recent (`ORDER BY time DESC`) records from each partition:

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2017-06-18T12:00:00Z' AND datetime < '2017-06-18T12:00:30Z'
  WITH ROW_NUMBER(entity ORDER BY time) <= 1
ORDER BY entity, datetime
```

```ls
| entity       | datetime             | value |
|--------------|----------------------|-------|
| nurswgvml006 | 2017-06-18T12:00:05Z | 66.0  |
| nurswgvml007 | 2017-06-18T12:00:03Z | 18.2  |
| nurswgvml010 | 2017-06-18T12:00:14Z | 0.5   |
| nurswgvml011 | 2017-06-18T12:00:10Z | 100.0 |
| nurswgvml102 | 2017-06-18T12:00:02Z | 0.0   |
| nurswgvml502 | 2017-06-18T12:00:01Z | 13.7  |
```

* Apply an aggregate function to Last-N records:

```sql
SELECT entity,
    AVG(value) --average is calculated for top-10 rows in each partition
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR
  WITH ROW_NUMBER(entity ORDER BY time DESC) <= 10
GROUP BY entity
```

```ls
| entity       | AVG(value) |
|--------------|------------|
| nurswgvml006 | 14.0       |
| nurswgvml007 | 5.5        |
| nurswgvml010 | 3.5        |
| nurswgvml301 | 0.4        |
| nurswgvml502 | 3.9        |
```

The `ROW_NUMBER` function can be included after the `WHERE` clause, as well as after the `GROUP BY` clause, in which case it is applied to grouped rows.

```sql
SELECT entity, tags, MAX(value) -  MIN(value) AS "Diff"
  FROM "df.disk_used"
WHERE datetime >= CURRENT_DAY
  -- fetch last 100 records for each series
  WITH ROW_NUMBER(entity, tags ORDER BY time DESC) <= 100
GROUP BY entity, tags
  HAVING MAX(value) - MIN(value) > 0
  -- fetch top 3 series for each entity
  WITH ROW_NUMBER(entity ORDER BY MAX(value) -  MIN(value) DESC) <= 3
ORDER BY Diff DESC
```

If the `GROUP BY` clause contains a `PERIOD` column, the `ROW_NUMBER` function applied to grouped rows can refer to the same period as the grouping clause.

```sql
SELECT  entity, tags.*, datetime, avg(value), count(value), first(value), last(value)
  FROM "df.disk_used"
WHERE datetime >= '2017-01-09T00:00:00Z' AND datetime < '2017-01-09T02:00:00Z'
  -- group by series (entity+tags) and 15-minute period
  GROUP BY entity, tags, period(15 minute)
  -- retain only 2 periods for each series (entity+tags)
WITH ROW_NUMBER(entity, tags ORDER BY period(15 minute)) <= 2
```

```ls
| entity       | tags.file_system                    | datetime             | avg(value) | count(value) | first(value) | last      |
|--------------|-------------------------------------|----------------------|------------|--------------|--------------|-----------|
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | 2017-01-09T00:00:00Z | 6285986    | 60           | 6285696      | 6286312   |
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | 2017-01-09T00:15:00Z | 6286339    | 60           | 6286312      | 6286372   |
| nurswgvml006 | /dev/sdc1                           | 2017-01-09T00:00:00Z | 57558921   | 60           | 57521944     | 57579272  |
| nurswgvml006 | /dev/sdc1                           | 2017-01-09T00:15:00Z | 57600482   | 60           | 57580072     | 57510460  |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | 2017-01-09T00:00:00Z | 9046720    | 60           | 9024392      | 9071064   |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | 2017-01-09T00:15:00Z | 9005158    | 60           | 9071668      | 9010264   |
```

The `row_number()` column, without arguments, can be included in the `SELECT` expression and in the `ORDER BY` clause.

```sql
SELECT datetime, entity, value, row_number()
  FROM "mpstat.cpu_busy"
WHERE datetime BETWEEN '2017-05-30T09:00:00Z' AND '2017-05-30T09:05:00Z'
  WITH ROW_NUMBER(entity ORDER BY datetime DESC) <= 2
ORDER BY row_number() DESC
```

```ls
| datetime             | entity       | value | row_number() |
|----------------------|--------------|-------|--------------|
| 2017-05-30T09:04:42Z | nurswgvml007 | 1.0   | 2            |
| 2017-05-30T09:04:40Z | nurswgvml006 | 1.0   | 2            |
| 2017-05-30T09:04:38Z | nurswgvml010 | 0.2   | 2            |
| 2017-05-30T09:04:58Z | nurswgvml007 | 14.1  | 1            |
| 2017-05-30T09:04:56Z | nurswgvml006 | 1.0   | 1            |
| 2017-05-30T09:04:54Z | nurswgvml010 | 0.0   | 1            |
```

### LAST_TIME Syntax

The `last_time` function returns the last time, in milliseconds, when data was received for a given series. It enables filtering of records based on the last insertion date for the given series.

```sql
WITH time comparison_operator last_time_expression
WITH last_time_expression comparison_operator time
```

* `time` is the pre-defined time column which represents the timestamp of the sample.
* A `comparison_operator` is one of the following operators: `>`, `>=`, `<`, `<=`, `=`.
* A `last_time_expression` consists of the `last_time` keyword and an optional calendar expression.

```sql
WITH time >= last_time - 1*MINUTE
```

Calculate the `average` for the most recent hour for each series that received data in the current month:

```sql
SELECT entity, AVG(value), date_format(MAX(time)) AS Last_Date
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_MONTH
  GROUP BY entity
WITH time >= last_time - 1*HOUR
```

## Ordering

The default sort order is undefined. Row ordering can be performed by adding the `ORDER BY` clause consisting of column name, column number (starting with 1), or an expression followed by direction (ASC or DESC).

```sql
SELECT entity, AVG(value) FROM "mpstat.cpu_busy"
  WHERE datetime >= CURRENT_DAY
GROUP BY entity
  ORDER BY AVG(value) DESC, entity
```

```ls
| entity       | AVG(value) |
|--------------|-----------:|
| nurswgvml006 | 19.2       |
| nurswgvml007 | 13.2       |
| nurswgvml011 | 5.1        |
| nurswgvml010 | 4.3        |
| nurswgvml502 | 4.3        |
| nurswgvml102 | 1.2        |
```

Column numbers can be used instead of column names. The number should be a positive integer representing the position of the column in the `SELECT` expression.

```sql
SELECT entity, AVG(value) FROM "mpstat.cpu_busy"
  WHERE datetime >= CURRENT_DAY
GROUP BY entity
  ORDER BY 2 DESC, 1
```

In combination with `LIMIT`, ordering can be used to execute the **Top-N** queries.

```sql
SELECT entity, AVG(value) FROM "mpstat.cpu_busy"
  WHERE datetime >= CURRENT_DAY
  GROUP BY entity
ORDER BY AVG(value) DESC
  LIMIT 2
```

```ls
| entity       | AVG(value) |
|--------------|-----------:|
| nurswgvml006 | 19.3       |
| nurswgvml007 | 13.2       |
```

### Collation

Strings are ordered [lexicographically](examples/order-by-string-collation.md), based on Unicode values. `NULL` has the lowest possible value and is listed first when sorted in ascending order.

| **ATSD** | **MySQL** | **PostgreSQL** | **Oracle** |
| ---- | ---- | ---- | ---- |
| 0 U+0030 | 0 | 0 | 0 |
| 1 U+0031 | 1 | 1 | 1 |
| A U+0041 | A | a | A |
| B U+0042 | a | A | B |
| C U+0043 | B | b | C |
| T U+0054 | b | B | T |
| U U+0055 | C | C | U |
| a U+0061 | t | t | a |
| b U+0062 | T | T | b |
| t U+0074 | U | U | t |
| z U+007A | z | z | z |

### Limiting

To reduce the number of rows returned by the database for a given query, add the `LIMIT` clause at the end of the query.

The `LIMIT` clause provides two syntax alternatives:

| **Syntax** | **Example** | **Description** |
|:---|:---|:---|
| `LIMIT` `[offset,] count` | `LIMIT 3, 5` | Select 5 rows starting with 4th row |
| `LIMIT` `[offset,] count` | `LIMIT 0, 5` | Select 5 rows starting with 1st row |
| `LIMIT` count `OFFSET` offset| `LIMIT 5 OFFSET 3` | Select 5 rows starting with 4th row |
| `LIMIT` count `OFFSET` offset| `LIMIT 5 OFFSET 0` | Select 5 rows starting with 1st row |

Note that row numbering starts at 0, hence `LIMIT 0, 5` is equivalent to `LIMIT 5`.

The limit applies to the number of rows returned by the database, not the number of raw samples found.

```sql
SELECT entity, AVG(value)
  FROM "m-1"
GROUP BY entity
  ORDER BY AVG(value) DESC
LIMIT 1
```

The above query retrieves all records for the 'm-1' metric, even though it returns only 1 record as instructed by the `LIMIT` clause.

## Inline Views

Inline view is a subquery specified in the `FROM` clause. It defines a virtual table to be processed by the parent query. 

```sql
-- parent query
SELECT env, MAX(avg_val)
FROM (
  -- subquery acting as table
  SELECT entity, entity.tags.environment AS env, avg(value) AS avg_val
    FROM "cpu_busy" 
    WHERE datetime >= CURRENT_DAY
  GROUP BY entity
)
GROUP BY env
```

```ls
| env  | max(avg_val) | 
|------|--------------| 
| prod |         24.1 | 
| test |          8.2 | 
```

The example below calculates hourly maximum from which the parent query computes a daily average (average hourly maximum).

```sql
SELECT datetime, AVG(value) AS "daily_average" 
  FROM (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
GROUP BY PERIOD(1 DAY)
```

```ls
| datetime            | daily_average | 
|---------------------|---------------| 
| 2017-08-14 00:00:00 | 96.1          | 
| 2017-08-15 00:00:00 | 96.6          | 
| 2017-08-16 00:00:00 | 98.8          | 
```

If the subquery column is based on an expression or function, rename it with an alias that can be referenced in the parent query.

```sql
MAX(value) AS "mval"
```

A subquery can include a nested subquery. Unlimited nested subqueries are supported. 

```sql
SELECT MAX(value) FROM (
  SELECT datetime, AVG(value) AS "value" FROM (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
  GROUP BY PERIOD(1 DAY)
)
```

```ls
| max(value) |
|------------|
| 98.8       |
```

An inline view may contain subqueries that join multiple tables.

```sql
SELECT datetime, MAX(value) AS "5-min Peak" FROM (
  SELECT datetime, AVG(t1.value * t2.value) AS "value"
    FROM "cpu_allocated_units" t1
    JOIN "cpu_used_percent" t2 
    WHERE datetime >= PREVIOUS_HOUR
    GROUP BY PERIOD(5 MINUTE)
)
GROUP BY PERIOD (1 HOUR)
```

## Joins

The `JOIN` clause merges records from multiple tables. The database implements inner and outer joins.

* Rows returned by an inner join contain equal values for joined columns.

* Rows returned by an outer join contain equal or `null` values for joined columns.

### JOIN Example

Metric `m_1` records:

```ls
| m_1.datetime     | m_1.value  | m_1.entity | 
|------------------|------------|------------| 
| 2018-03-15 18:00 | 1.0        | e_1        | 
| 2018-03-15 18:05 | 3.0        | e_1        | 
```

Metric `m_2` records:

```ls
| m_2.datetime     | m_2.value  | m_2.entity | 
|------------------|------------|------------| 
| 2018-03-15 18:01 | 2.0        | e_1        | 
| 2018-03-15 18:05 | 4.0        | e_1        | 
| 2018-03-15 18:10 | 6.0        | e_1        | 
```

* Inner Join Query

```sql
SELECT m_1.datetime, m_2.datetime, m_1.value, m_2.value
  FROM m_1
  JOIN m_2 
  /*  ON m_1.time = m_2.time
       AND m_1.entity = m_2.entity
       AND m_1.tags = m_2.tags */
  WHERE datetime BETWEEN '2018-03-15 18:00:00' AND '2018-03-15 18:15:00'
```

```ls
| m_1.datetime      | m_2.datetime      | m_1.value  | m_2.value | 
|-------------------|-------------------|------------|-----------| 
| 2018-03-15 18:05  | 2018-03-15 18:05  | 3.0        | 4.0       | 
```

* Outer Join Query

```sql
SELECT m_1.datetime, m_2.datetime, m_1.value, m_2.value
  FROM m_1
  OUTER JOIN m_2 
  /*  ON m_1.time = m_2.time
       AND m_1.entity = m_2.entity
       AND m_1.tags = m_2.tags */
  WHERE datetime BETWEEN '2018-03-15 18:00:00' AND '2018-03-15 18:15:00'
```

```ls
| m_1.datetime      | m_2.datetime      | m_1.value  | m_2.value | 
|-------------------|-------------------|------------|-----------| 
| 2018-03-15 18:00  | null              | 1.0        | null      | 
| null              | 2018-03-15 18:01  | null       | 2.0       | 
| 2018-03-15 18:05  | 2018-03-15 18:05  | 3.0        | 4.0       | 
| null              | 2018-03-15 18:10  | null       | 6.0       | 
```

### JOIN Syntax

The syntax follows the `SQL-92` notation for enumerating the compared columns.

```sql
  FROM tbl t1 
     JOIN tbl t2 
      ON  t1.time AND t2.time 
      AND t1.entity = t2.entity 
      AND t1.tags = t2.tags
```

The `ON` condition can compare only the predefined columns: `entity`, `time`, ``datetime`, and `tags`. Since the virtual tables contain the same predefined columns, the `ON` condition is optional and can be omitted.

| **Compact Syntax** | **SQL-92 Syntax** |
|:---|---|
| `FROM tbl_1 t1`<br>` JOIN tbl_2 t2` | `FROM tbl_1 t1 JOIN tbl t2`<br>` ON t1.time AND t2.time`<br>` AND t1.entity = t2.entity AND t1.tags = t2.tags` |
| `FROM tbl_1 t1`<br>` FULL OUTER JOIN tbl_2 t2` | `FROM tbl_1 t1 FULL OUTER JOIN tbl_2 t2`<br>` ON t1.time AND t2.time`<br>` AND t1.entity = t2.entity AND t1.tags = t2.tags` |

The `ON` condition can be modified with the `USING entity` instruction in which case series `tags` are ignored, and records are joined on `entity` and `time` columns instead.

| **Compact Syntax** | **SQL-92 Syntax** |
|:---|---|
| `FROM tbl_1 t1`<br>` JOIN USING entity tbl_2 t2` | `FROM tbl_1 t1 JOIN tbl_2 t2`<br>` ON t1.time AND t2.time`<br>` AND t1.entity = t2.entity` |
| `FROM tbl_1 t1`<br>` FULL OUTER JOIN USING entity tbl_2 t2` | `FROM tbl_1 t1 FULL OUTER JOIN tbl_2 t2`<br>` ON t1.time AND t2.time`<br>` AND t1.entity = t2.entity` |

> Note that self-joins (table is merged with itself) is not supported.

### JOIN Results

To disambiguate column references in the join query, use qualified column names.

```sql
  SELECT table_1.entity ... FROM table_1 t1
  SELECT      t1.entity ... FROM table_1 t1
```

The `SELECT *` and `SELECT {table_name}.*` expressions in join queries include qualified column names such as `t1.datetime`.

In addition to default columns, the `JOIN` query results include `datetime` and `time` columns containing a row timestamp calculated as `COALESCE(t1.datetime, t2.datetime, ...)`.

```sql
SELECT datetime, m_1.datetime, m_2.datetime, m_1.value, m_2.value
  FROM m_1
  OUTER JOIN m_2 
  WHERE datetime BETWEEN '2018-03-15 18:00:00' AND '2018-03-15 18:15:00'
```

```ls
| datetime          | m_1.datetime      | m_2.datetime      | m_1.value  | m_2.value | 
|-------------------|-------------------|-------------------|------------|-----------| 
| 2018-03-15 18:00  | 2018-03-15 18:00  | null              | 1.0        | null      | 
| 2018-03-15 18:01  | null              | 2018-03-15 18:01  | null       | 2.0       | 
| 2018-03-15 18:05  | 2018-03-15 18:05  | 2018-03-15 18:05  | 3.0        | 4.0       | 
| 2018-03-15 18:10  | null              | 2018-03-15 18:10  | null       | 6.0       | 
```

### `JOIN` Filtering

The `WHERE` filter is applied **before** the `JOIN` operation.

```sql
SELECT t1.datetime, t1.entity, t1.value, t2.datetime, t2.entity, t2.value, t2.tags
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "df.disk_used" t2
WHERE datetime BETWEEN '2018-03-09T07:07:00Z' AND '2018-03-09T07:08:00Z'
  AND t1.entity = 'nurswghbs001'
```

Note that the `t1.entity` column below contains rows with `null` values even though this column was checked in the `WHERE` condition. In this example, `null` values were created at the `OUTER JOIN` stage.

```ls
| t1.datetime           | t1.entity     | t1.value  | t2.datetime           | t2.entity     | t2.value  | t2.tags                                | 
|-----------------------|---------------|-----------|-----------------------|---------------|-----------|----------------------------------------| 
| 2018-03-09T07:07:05Z  | nurswghbs001  | 4.4       | null                  | null          | null      | null                                   | 
| null                  | null          | null      | 2018-03-09T07:07:42Z  | nurswghbs001  | 248909.0  | file_system=/dev/md2;mount_point=/     | 

```

### Inner `JOIN`

The `JOIN` clause allows merging records in multiple tables for the **same** entity into one result set.

If the timestamps for joined metrics are identical, the `JOIN` operation merges rows for all the detailed records.

```ls
| datetime             | entity       | t1.value | t2.value | t3.value |
|----------------------|--------------|---------:|---------:|---------:|
| 2017-06-16T13:00:01Z | nurswgvml006 | 13.3     | 21.0     | 2.9      |
| 2017-06-16T13:00:17Z | nurswgvml006 | 1.0      | 2.0      | 13.0     |
| 2017-06-16T13:00:33Z | nurswgvml006 | 0.0      | 1.0      | 0.0      |
```

As in the example above, the `cpu_system`, `cpu_user`, `cpu_iowait` metrics were recorded and inserted with the same time.

```ls
datetime d:2017-06-16T13:00:01Z e:nurswgvml006 m:mpstat.cpu_system=13.3 m.mpstat.cpu_user=21.0 m:mpstat.cpu_iowait=2.9
datetime d:2017-06-16T13:00:17Z e:nurswgvml006 m:mpstat.cpu_system=1.0 m.mpstat.cpu_user=2.0 m:mpstat.cpu_iowait=13.0
datetime d:2017-06-16T13:00:33Z e:nurswgvml006 m:mpstat.cpu_system=0.0 m.mpstat.cpu_user=1.0 m:mpstat.cpu_iowait=0.0
```

However, when merging independent metrics, `JOIN` results may contain only rows with identical times.

```sql
SELECT t1.datetime, t1.entity, t1.value AS cpu, t2.value AS mem
  FROM "mpstat.cpu_busy" t1
  JOIN "meminfo.memfree" t2
WHERE t1.datetime >= '2017-06-16T13:00:00Z' AND t1.datetime < '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

The result contains only 2 records out of 75 total. This is because for `JOIN` to merge detailed records from multiple metrics into one row, the records must have the same time.

```ls
| datetime             | entity       | cpu  | mem     |
|----------------------|--------------|-----:|--------:|
| 2017-06-16T13:02:57Z | nurswgvml006 | 16.0 | 74588.0 |
| 2017-06-16T13:07:17Z | nurswgvml006 | 16.0 | 73232.0 |
```

To join irregular series, use `GROUP BY PERIOD` or `WITH INTERPOLATE` clauses to equalize the timestamps.

```sql
SELECT t1.entity, t1.datetime, t1.value,
       t2.entity, t2.datetime, t2.value
FROM "mpstat.cpu_busy" t1
  JOIN "meminfo.memfree" t2
WHERE t1.datetime BETWEEN '2017-04-08T07:01:00Z' AND '2017-04-08T07:02:00Z'
  AND t1.entity = 'nurswgvml006'
  WITH INTERPOLATE(15 SECOND, PREVIOUS, OUTER)
```

```ls
| t1.entity    | t1.datetime          | t1.value | t2.entity    | t2.datetime          | t2.value |
|--------------|----------------------|----------|--------------|----------------------|----------|
| nurswgvml006 | 2017-04-08T07:01:00Z | 5.0      | nurswgvml006 | 2017-04-08T07:01:00Z | 74804.0  |
| nurswgvml006 | 2017-04-08T07:01:15Z | 6.1      | nurswgvml006 | 2017-04-08T07:01:15Z | 71276.0  |
| nurswgvml006 | 2017-04-08T07:01:30Z | 3.0      | nurswgvml006 | 2017-04-08T07:01:30Z | 70820.0  |
| nurswgvml006 | 2017-04-08T07:01:45Z | 2.0      | nurswgvml006 | 2017-04-08T07:01:45Z | 69944.0  |
| nurswgvml006 | 2017-04-08T07:02:00Z | 10.9     | nurswgvml006 | 2017-04-08T07:02:00Z | 75928.0  |
```

Series with tags can be joined without enumerating all possible tag names in the `JOIN` condition.

```sql
SELECT t1.datetime, t1.entity, t1.value, t2.value, t1.tags.*
  FROM "df.disk_used" t1
  JOIN "df.disk_used_percent" t2
WHERE t1.datetime >= '2017-06-16T13:00:00Z' AND t1.datetime < '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

```ls
| datetime             | entity       | t1.value     | t2.value | t1.tags.file_system             | t1.tags.mount_point |
|----------------------|--------------|--------------|----------|---------------------------------|---------------------|
| 2017-06-16T13:00:14Z | nurswgvml006 | 1743057408.0 | 83.1     | //u113452.nurstr003/backup      | /mnt/u113452        |
| 2017-06-16T13:00:29Z | nurswgvml006 | 1743057408.0 | 83.1     | //u113452.nurstr003/backup      | /mnt/u113452        |
| 2017-06-16T13:00:44Z | nurswgvml006 | 1743057408.0 | 83.1     | //u113452.nurstr003/backup      | /mnt/u113452        |
| 2017-06-16T13:00:59Z | nurswgvml006 | 1743057408.0 | 83.1     | //u113452.nurstr003/backup      | /mnt/u113452        |
```

### OUTER JOIN

To combine all records from joined tables, use `FULL OUTER JOIN` (synonyms `OUTER JOIN` or `FULL JOIN`), which returns rows with equal time, entity, and tags as well as rows from one table for which no rows from the other table satisfy the join condition.

```sql
SELECT t1.datetime, t1.entity, t1.value AS cpu,
       t2.datetime, t2.entity, t2.value AS mem
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
    -- FULL JOIN "meminfo.memfree" t2
    -- OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime >= '2017-06-16T13:00:00Z' AND t1.datetime < '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
```

`FULL OUTER JOIN` on detailed records, without period aggregation, produces rows with `NULL` columns for series that did not record any value at the specified time.

```ls
| t1.datetime          | t1.entity    | cpu  | t2.datetime          | t2.entity    | mem   |
|----------------------|--------------|------|----------------------|--------------|-------|
| 2017-06-16T13:00:01Z | nurswgvml006 | 37   | null                 | null         | null  |
| null                 | null         | null | 2017-06-16T13:00:12Z | nurswgvml006 | 67932 |
| 2017-06-16T13:00:17Z | nurswgvml006 | 16   | null                 | null         | null  |
| null                 | null         | null | 2017-06-16T13:00:27Z | nurswgvml006 | 73620 |
```


To regularize the merged series in join queries, apply interpolation or period aggregation using a statistical function.

* Interpolation

```sql
SELECT t1.datetime, t1.entity, t1.value AS cpu,
       t2.datetime, t2.entity, t2.value AS mem
  FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime >= '2017-06-16T13:00:00Z' AND t1.datetime < '2017-06-16T13:10:00Z'
  AND t1.entity = 'nurswgvml006'
  WITH INTERPOLATE(15 SECOND, LINEAR, OUTER)
```

```ls
| t1.datetime          | t1.entity    | cpu  | t2.datetime          | t2.entity    | mem     |
|----------------------|--------------|------|----------------------|--------------|---------|
| 2017-06-16T13:00:00Z | nurswgvml006 | 34.9 | 2017-06-16T13:00:00Z | nurswgvml006 | 69903.2 |
| 2017-06-16T13:00:15Z | nurswgvml006 | 18.6 | 2017-06-16T13:00:15Z | nurswgvml006 | 69069.6 |
| 2017-06-16T13:00:30Z | nurswgvml006 | 3.8  | 2017-06-16T13:00:30Z | nurswgvml006 | 74041.6 |
```

* Aggregation

The `PERIOD()` column (without the preceding table name) calculates the start of the period based on the `datetime` column.

```sql
SELECT datetime, ISNULL(t1.entity, t2.entity) AS server,
  AVG(t1.value) AS avg_cpu, AVG(t2.value) AS avg_mem
FROM "mpstat.cpu_busy" t1
  FULL OUTER JOIN "meminfo.memfree" t2
WHERE t1.datetime >= '2017-06-16T13:00:00Z' AND t1.datetime < '2017-06-16T13:10:00Z'
GROUP BY PERIOD(1 MINUTE), server
  ORDER BY datetime
```

```ls
| datetime             | server       | avg_cpu | avg_mem  |
|----------------------|--------------|---------|----------|
| 2017-06-16T13:00:00Z | nurswgvml006 | 15.8    | 73147.0  |
| 2017-06-16T13:00:00Z | nurswgvml007 | 9.8     | 259757.0 |
| 2017-06-16T13:01:00Z | nurswgvml006 | 2.8     | 69925.0  |
| 2017-06-16T13:01:00Z | nurswgvml007 | 3.5     | 252451.0 |
```

>  Note that records returned by a `JOIN USING entity` condition include series with a last insert date greater than the start date specified in the query.

### JOIN with `atsd_series` table

When metrics selected from the `atsd_series` table are joined with metrics referenced in the query, each `atsd_series` metric is joined with a referenced metric separately.

```sql
SELECT base.entity, base.metric, base.datetime, base.value, t1.value AS "cpu_sys"
  FROM atsd_series base
  JOIN "mpstat.cpu_system" t1
WHERE base.metric IN ('mpstat.cpu_busy', 'mpstat.cpu_user')
  AND base.entity = 'nurswgvml007'
  AND base.datetime > PREVIOUS_MINUTE
ORDER BY base.datetime
```

```ls
| base.entity  | base.metric | base.datetime        | base.value | cpu_sys |
|--------------|-------------|----------------------|------------|---------|
| nurswgvml007 | cpu_busy    | 2017-04-07T15:04:08Z | 5.0        | 2.0     | cpu_busy JOIN cpu_system
| nurswgvml007 | cpu_busy    | 2017-04-07T15:04:24Z | 5.1        | 2.0     | cpu_busy JOIN cpu_system
...
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:08Z | 2.0        | 2.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:24Z | 3.1        | 2.0     | cpu_user JOIN cpu_system
...
```

## Keywords

```ls
|-------------|-------------|-------------|-------------|
| AND         | AS          | ASC         | BETWEEN     |
| BY          | CASE        | CAST        | DESC        |
| ELSE        | ESCAPE      | FROM        | GROUP       |
| HAVING      | IN          | INNER       | INTERPOLATE |
| ISNULL      | JOIN        | LAG         | LAST_TIME   |
| LEAD        | LIKE        | LIMIT       | LOOKUP      |
| NOT         | OFFSET      | OPTION      | OR          |
| ORDER       | OUTER       | PERIOD      | REGEX       |
| ROW_NUMBER  | SELECT      | THEN        | USING       |
| VALUE       | WHEN        | WHERE       | WITH        |
|-------------|-------------|-------------|-------------|
```

 The reserved keywords also include [calendar](../shared/calendar.md#keywords) keywords such as `NOW`, `PREVIOUS_HOUR` and [interval units](../shared/calendar.md#interval-units) such as `MINUTE`, `HOUR`.

## Aggregation Functions

The following functions aggregate values in a column by producing a single value from a list of values appearing in a column.

```ls
|----------------|----------------|----------------|----------------|
| AVG            | CORREL         | COUNT          | COUNTER        |
| DELTA          | FIRST          | LAST           | MAX            |
| MAX_VALUE_TIME | MEDIAN         | MIN            | MIN_VALUE_TIME |
| PERCENTILE     | SUM            | STDDEV         | WAVG           |
| WTAVG          |                |                |                |
|----------------|----------------|----------------|----------------|
```

The functions accept the `value` column or a numeric expression as an argument, for example  `AVG(value)` or `AVG(t1.value + t2.value)`.

* All functions, except `MIN_VALUE_TIME` and `MAX_VALUE_TIME`, return DOUBLE datatype.
* Functions `MIN_VALUE_TIME` and `MAX_VALUE_TIME` return LONG datatype.
* `NULL` and `NaN` values are ignored by aggregation functions.
* If the aggregation function of DOUBLE datatype cannot find a single value other than `NULL` or `NaN`, it returns `NaN`.
* If the aggregation function of LONG datatype cannot find a single value other than `NULL` or `NaN`, it returns `NULL`.
* Nested aggregation functions such as `AVG(MAX(value))` are not supported.

```sql
SELECT entity, AVG(value), MAX(value), COUNT(*), PERCENTILE(80, value)
  FROM "mpstat.cpu_busy"
WHERE datetime > current_hour
  GROUP BY entity
```

```ls
| entity       | AVG(value) | MAX(value) | COUNT(*) | PERCENTILE(80,value) |
|--------------|------------|------------|----------|----------------------|
| nurswghbs001 | 20.3       | 48.0       | 49.0     | 22.8                 |
```

### COUNT

The `COUNT(*)` function returns the number of rows in the result set, whereas the `COUNT(expr)` returns the number of rows where the expression `expr` was not `NULL` or `NaN`.

### PERCENTILE

The `PERCENTILE` function accepts `percentile` parameter (0 to 100) as the first argument and a numeric expression as the second argument, for example `PERCENTILE(75, value)`.

`PERCENTILE(0, value)` is equal to `MIN(value)` whereas `PERCENTILE(100, value)` is equal to `MAX(value)`.

### FIRST

The `FIRST` function returns the value of the first sample (or the value of expression `expr` for the first row) in the set which is ordered by time in ascending order.

### LAST

The `LAST` function returns the value of the last sample (or the value of expression `expr` for the last row) in the set which is ordered by time in ascending order.

### MIN_VALUE_TIME

The `MIN_VALUE_TIME` function returns the Unix time in milliseconds (LONG datatype) of the first occurrence of the **minimum** value.

### MAX_VALUE_TIME

The `MAX_VALUE_TIME` function returns the Unix time in milliseconds (LONG datatype) of the first occurrence of the **maximum** value.

### CORREL

The `CORREL` correlation function accepts two numeric expressions as arguments (or two value columns in a `JOIN` query) and calculates the [Pearson correlation](http://commons.apache.org/proper/commons-math/javadocs/api-3.3/org/apache/commons/math3/stat/correlation/PearsonsCorrelation.html) coefficient between them.

> If one of the variables is constant (its standard deviation is 0), the `CORREL` function returns `NaN`.

```sql
SELECT tu.entity,
  CORREL(tu.value, ts.value) AS "CORR-user-sys",
  CORREL(tu.value, tw.value) AS "CORR-user-iowait",
  CORREL(ts.value, tw.value) AS "CORR-sys-iowait",
  stddev(tu.value),
  stddev(ts.value),
  stddev(tw.value)
FROM "mpstat.cpu_user" tu JOIN "mpstat.cpu_system" ts JOIN "mpstat.cpu_iowait" tw
  WHERE tu.datetime >= NOW - 5 * MINUTE
GROUP BY tu.entity
```

```ls
| tu.entity    | CORR-user-sys | CORR-user-iowait | CORR-sys-iowait | stddev(tu.value) | stddev(ts.value) | stddev(tw.value) |
|--------------|---------------|------------------|-----------------|------------------|------------------|------------------|
| nurswgvml007 | 0.92          | NaN              | NaN             | 7.64             | 2.50             | 0.00             |
| nurswgvml006 | -0.13         | 0.10             | 0.27            | 7.26             | 0.60             | 2.57             |
| nurswgvml010 | 0.76          | -0.09            | 0.03            | 7.42             | 0.44             | 1.10             |
| nurswgvml502 | 0.59          | -0.14            | -0.08           | 0.53             | 0.53             | 0.59             |
| nurswgvml301 | -0.17         | -0.11            | -0.17           | 0.32             | 0.42             | 0.64             |
```

## Date Functions

### DATE_FORMAT

The `date_format` function formats Unix millisecond time to a string in user-defined date format and optional time zone. See supported time pattern letters [here](time-pattern.md).

```java
date_format(long milliseconds[, string time_format[, string time_zone]])
```

If the `time_format` argument is not provided, ISO 8601 format is applied.

The `time_zone` parameter accepts GTM offset in the format of `GMT-hh:mm` or a [time zone name](../shared/timezone-abnf.md) and can format dates in a time zone other than the database time zone.

In addition, the `time_zone` parameter can be specified as `AUTO` in which case the date is formatted with an entity-specific time zone. If an entity-specific time zone is not defined, a metric-specific time zone is used instead. If neither an entity-specific nor metric-specific time zone is specified, the database time zone is applied.

Examples:

* `date_format(time)`
* `date_format(max_value_time(value))`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss')`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss', 'PST')`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss', 'GMT-08:00')`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss ZZ', 'PDT')`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss', entity.timeZone)`
* `date_format(time, 'yyyy-MM-dd HH:mm:ss', AUTO)`
* `CEIL(CAST(date_format(time, 'M') AS NUMBER)/3) AS "Quarter"`

```sql
SELECT entity, datetime, metric.timeZone AS "Metric TZ", entity.timeZone AS "Entity TZ",
  date_format(time) AS "default",
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssZZ') AS "ISO 8601",
  date_format(time, 'yyyy-MM-dd HH:mm:ss') AS "Local Database",
  date_format(time, 'yyyy-MM-dd HH:mm:ss', 'GMT-08:00') AS "GMT Offset",  
  date_format(time, 'yyyy-MM-dd HH:mm:ss', 'PDT') AS "PDT",
  date_format(time, 'yyyy-MM-dd HH:mm:ssZZ', 'PDT') AS " PDT t/z",
  date_format(time, 'yyyy-MM-dd HH:mm:ssZZ', AUTO) AS "AUTO: CST", -- nurswgvml006 is in CST
  CEIL(CAST(date_format(time, 'M') AS NUMBER)/3) AS "Quarter"
FROM "mpstat.cpu_busy"
  WHERE datetime >= NOW - 5*MINUTE
  AND entity = 'nurswgvml006'
  LIMIT 1
```

```ls
| entity       | datetime                 | Metric TZ  | Entity TZ   | default                  | ISO 8601             | Local Database        | GMT Offset          | PDT                 | PDT t/z                   | AUTO: CST                 | Quarter |
|--------------|--------------------------|------------|-------------|--------------------------|----------------------|-----------------------|---------------------|---------------------|---------------------------|---------------------------|---------|
| nurswgvml006 | 2017-04-06T11:03:19.000Z | US/Eastern | US/Mountain | 2017-04-06T11:03:19.000Z | 2017-04-06T11:03:19Z | 2017-04-06 11:03:19   | 2017-04-06 03:03:19 | 2017-04-06 04:03:19 | 2017-04-06 04:03:19-07:00 | 2017-04-06 05:03:19-06:00 | 2       |
```

```ls
| format                                                    | date_format value          |
|-----------------------------------------------------------|----------------------------|
| time                                                      | 1468411675000              |
| date_format(time)                                         | 2017-07-13T12:07:55.000Z   |
| date_format(time+60000)                                   | 2017-07-13T12:08:55.000Z   |
| date_format(time,'yyyy-MM-dd''T''HH:mm:ss.SSS''Z'','UTC') | 2017-07-13T12:07:55.000Z   |
| date_format(time,'yyyy-MM-dd HH:mm:ss')                   | 2017-07-13 12:07:55        |
| date_format(time,'yyyy-MM-dd HH:mm:ss','PST')             | 2017-07-13 05:07:55        |
| date_format(time,'yyyy-MM-dd HH:mm:ss','GMT-08:00')       | 2017-07-13 04:07:55        |
| date_format(time,'yyyy-MM-dd HH:mm:ssZ','PST')            | 2017-07-13 05:07:55-0700   |
| date_format(time,'yyyy-MM-dd HH:mm:ssZZ','PST')           | 2017-07-13 05:07:55-07:00  |
```

The `date_format` function can also be used to print period start and end times:

```sql
SELECT datetime AS period_start, date_format(time+60*60000) AS period_end, AVG(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= CURRENT_DAY
GROUP BY PERIOD(1 HOUR)
```

```ls
| period_start             | period_end               | AVG(value) |
|--------------------------|--------------------------|------------|
| 2017-08-25T00:00:00.000Z | 2017-08-25T01:00:00.000Z | 7.7        |
| 2017-08-25T01:00:00.000Z | 2017-08-25T02:00:00.000Z | 8.2        |
| 2017-08-25T02:00:00.000Z | 2017-08-25T03:00:00.000Z | 6.7        |
```

In addition to formatting, the `date_format` function can be used in the `WHERE`, `GROUP BY`, and `HAVING` clauses to filter and group dates by month, day, or hour.

```sql
SELECT date_format(time, 'EEE'), AVG(value)
FROM "mpstat.cpu_busy"
  WHERE datetime >= CURRENT_MONTH
GROUP BY date_format(time, 'EEE')
  ORDER BY 2 DESC
```

```ls
| date_format(time,'EEE') | AVG(value) |
|-------------------------|------------|
| Mon                     | 31.9       |
| Wed                     | 31.8       |
| Sun                     | 31.4       |
| Tue                     | 31.2       |
| Thu                     | 29.6       |
| Sat                     | 29.6       |
| Fri                     | 29.3       |
```

Refer to [diurnal](examples/diurnal.md) query examples.

By retrieving date parts from the `time` column, the records can be filtered by calendar.
The following query includes only daytime hours (from 08:00 till 17:59) during weekdays (Monday till Friday).

```sql
SELECT datetime, date_format(time, 'EEE') AS "day of week", avg(value), count(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= previous_week AND datetime < current_week
  AND CAST(date_format(time, 'H') AS number) BETWEEN 8 AND 17
  AND date_format(time, 'u') < 6
GROUP BY PERIOD(1 hour)
```

```ls
| datetime             | day of week  | avg(value)  | count(value) | 
|----------------------|--------------|-------------|--------------| 
| 2018-03-12 08:00:00  | Mon          | 14.535      | 223          | 
| 2018-03-12 09:00:00  | Mon          | 12.626      | 225          | 
| 2018-03-12 10:00:00  | Mon          | 12.114      | 225          | 
| 2018-03-12 11:00:00  | Mon          | 11.314      | 225          | 
...
```

### DATE_PARSE

The `date_parse` function parses the date and time string into Unix milliseconds.

```java
date_parse(string datetime[, string time_format[, string time_zone]])
```

* The default `time_format` is ISO 8601: `yyyy-MM-dd'T'HH:mm:ss.SSSZZ`. See supported pattern letters [here](time-pattern.md).
* The default `time_zone` is the database time zone.

```sql
/* Parse date using the default ISO 8601 format.*/
date_parse('2017-03-31T12:36:03.283Z')

/* Parse date using the ISO 8601 format, without milliseconds */
date_parse('2017-03-31T12:36:03Z', 'yyyy-MM-dd''T''HH:mm:ssZZ')

/* Parse date using the database time zone. */
date_parse('31.03.2017 12:36:03.283', 'dd.MM.yyyy HH:mm:ss.SSS')

/* Parse date using the offset specified in the timestamp string. */
date_parse('31.03.2017 12:36:03.283 -08:00', 'dd.MM.yyyy HH:mm:ss.SSS ZZ')

/* Parse date using the time zone specified in the timestamp string. */
date_parse('31.03.2017 12:36:03.283 Europe/Berlin', 'dd.MM.yyyy HH:mm:ss.SSS ZZZ')

/* Parse date using the time zone provided as the third argument. */
date_parse('31.01.2017 12:36:03.283', 'dd.MM.yyyy HH:mm:ss.SSS', 'Europe/Berlin')

/* Parse date using the UTC offset provided as the third argument. */
date_parse('31.01.2017 12:36:03.283', 'dd.MM.yyyy HH:mm:ss.SSS', '+01:00')

/* If the time zone (offset) is specified in the timestamp string,
it should be exactly the same as provided by the third argument. */
date_parse('31.01.2017 12:36:03.283 Europe/Berlin', 'dd.MM.yyyy HH:mm:ss.SSS ZZZ', 'Europe/Berlin')
```

### EXTRACT

The `extract` function returns an integer value corresponding to the specified part (component) of the provided date.

```sql
EXTRACT(datepart FROM datetime | time | datetime expression)
```

`datepart` can be YEAR, QUARTER, MONTH, DAY, HOUR, MINUTE, or SECOND.

The evaluation is based on the database time zone. The date argument can refer to the `time` or `datetime` columns including support for calendar expressions.

```sql
SELECT datetime,
  EXTRACT(year FROM datetime) AS "year",
  EXTRACT(quarter FROM datetime) AS "quarter",
  EXTRACT(month FROM datetime) AS "month",
  EXTRACT(day FROM datetime) AS "day",
  EXTRACT(hour FROM datetime) AS "hour",
  EXTRACT(minute FROM datetime) AS "minute",
  EXTRACT(second FROM datetime) AS "second",
  EXTRACT(day FROM now - 1*DAY) AS "prev_day",
  EXTRACT(month FROM now + 1*MONTH) AS "next_month"
FROM "mpstat.cpu_busy"
  WHERE datetime > current_hour
```

```ls
| datetime             | year | quarter | month | day | hour | minute | second | prev_day | next_month |
|----------------------|------|---------|-------|-----|------|--------|--------|----------|------------|
| 2017-07-29T21:00:12Z | 2017 | 3       | 7     | 29  | 21   | 0      | 12     | 28       | 8          |
```

### SECOND

The `second` function returns the current seconds in the provided date.

```sql
SECOND (datetime | time | datetime expression)
```

### MINUTE

The `minute` function returns the current minutes in the provided date.

```sql
MINUTE (datetime | time | datetime expression)
```

### HOUR

The `hour` function returns the current hour of the day (0 - 23) in the provided date.

```sql
HOUR (datetime | time | datetime expression)
```

### DAY

The `day` function returns the current day of month in the provided date.

```sql
DAY (datetime | time | datetime expression)
```

### DAYOFWEEK

The `dayofweek` function returns the current day of week (1-7, starting with Monday) in the provided date.

```sql
DAYOFWEEK (datetime | time | datetime expression)
```

### MONTH

The `month` function returns the current month (1-12) in the provided date.

```sql
MONTH (datetime | time | datetime expression)
```

### QUARTER

The `quarter` function returns the current quarter of the year in the provided date.

```sql
QUARTER (datetime | time | datetime expression)
```

### YEAR

The `year` function returns the current year in the provided date.

```sql
YEAR (datetime | time | datetime expression)
```

### CURRENT_TIMESTAMP

The `CURRENT_TIMESTAMP` function returns current database time in ISO-8601 format. It is analogous to the `NOW` functions which returns current database time in Unix milliseconds.

```sql
SELECT CURRENT_TIMESTAMP
```

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
-- same as   datetime > NOW - 1 * DAY
WHERE datetime > CURRENT_TIME - 1 * DAY
```

### DBTIMEZONE

The `DBTIMEZONE` function returns the current database time zone name or offset.

```sql
SELECT DBTIMEZONE
-- returns GMT0
```

## Mathematical Functions

| **Function** | **Description** |
|:---|:---|
| `ABS(num)` | Absolute value of the specified number. |
| `CEIL(num)` | Smallest integer that is greater than or equal to the specified number. |
| `FLOOR(num)` | Largest integer that is less than or equal to the specified number. |
| `ROUND(num [,m])` | Number rounded to `m` decimal places. |
| `MOD(num, m)` | Remainder of the first numerical argument divided by `m`.|
| `POWER(num, m)`  | Number raised to the power `m`. |
| `EXP(num)` | `e` (2.71828183) raised to the power of the specified number. |
| `LN(num)` | Natural logarithm of the specified number. |
| `LOG(num, m)`  | Base-`num` logarithm of the numerical argument `m`. |
| `SQRT(num)` | Square root of the specified number. |

```sql
SELECT value, ABS(value), CEIL(value), FLOOR(value), ROUND(value), MOD(value, 3),
  POWER(value, 2), EXP(value), LN(value), LOG(10, value), SQRT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= NOW - 1*MINUTE
  AND entity = 'nurswgvml007'
```

```ls
| value | ABS(value) | CEIL(value) | FLOOR(value) | ROUND(value) | MOD(value,3) | POWER(value,2) | EXP(value) | LN(value) | LOG(10,value) | SQRT(value) |
|-------|------------|-------------|--------------|--------------|--------------|----------------|------------|-----------|---------------|-------------|
| 4.040 | 4.040      | 5.000       | 4.000        | 4.000        | 1.040        | 16.322         | 56.826     | 1.396     | 0.606         | 2.010       |
| 7.070 | 7.070      | 8.000       | 7.000        | 7.000        | 1.070        | 49.985         | 1176.148   | 1.956     | 0.849         | 2.659       |
```

## String Functions

| **Function** | **Description** |
|:---|:---|
| `UPPER(s)` | Converts characters in a specified string to upper case. |
| `LOWER(s)` | Converts characters in a specified string to lower case. |
| `REPLACE(s-1, s-2, s-3)` | Replaces all occurrences of `s-2` with `s-3` in a specified string `s-1`.<br>If `s-2` is not found, the function returns the original string `s-1`.|
| `LENGTH(s)` | Number of characters in a specified string. |
| `CONCAT(s-1, s-2 [, s-N] )` | Concatenates multiple strings into one string. <br>`NULL` and `NaN` values are concatenated as empty strings.<br>The function also accepts numeric values which are converted to strings using `#.##` pattern. |
| `LOCATE(s-1, s-2 [, start])` | Searches for the **first** string `s-1` in the second string `s-2`.<br>Returns the position at which `s-1` is found in `s-2`, after the optional `start` position. <br>The first character has a position of 1. The function returns 0 if string `s-1` is not found. |
| `SUBSTR(str, start[, length])` | Substring of `str` starting at `start` position with maximum length of `length`. <br>The first character has a position of 1. <br>`start` position of 0 is processed similarly to position 1.<br>If `length` is not specified or is 0, the function returns the substring beginning with `start` position.|

```sql
SELECT datetime, UPPER(REPLACE(entity, 'nurswg', '')) AS "entity", value,
  SUBSTR(tags.file_system, LOCATE('vg', tags.file_system)) AS fs
FROM "df.disk_used"
  WHERE datetime >= NOW - 1*MINUTE
AND LOWER(tags.file_system) LIKE '%root'
  ORDER BY datetime
```

```ls
| datetime             | entity | value     | fs                      |
|----------------------|--------|-----------|-------------------------|
| 2017-09-30T07:57:28Z | VML006 | 8298304.0 | vg_nurswgvml006-lv_root |
| 2017-09-30T07:57:29Z | VML007 | 8052512.0 | vg_nurswgvml007-lv_root |
```

## Other Functions

### ISNULL

The `ISNULL` function returns `arg2` if `arg1` is `NULL` or `NaN` (Non-A-Number) in the case of numeric expressions.

```sql
ISNULL(arg1, arg2)
```

The function accepts arguments with different data types, for example numbers and strings `ISNULL(value, text)`.

>If the datatypes are different, the database will classify the column as `JAVA_OBJECT` to the [JDBC](https://github.com/axibase/atsd-jdbc) driver.

### COALESCE

The `COALESCE` function returns the first argument that is not `NULL` and not `NaN` (Non-A-Number) in case of numeric expressions.

```sql
COALESCE(arg1, arg2, ..., argN)
```

At least two arguments must be specified. If all arguments evaluate to `NULL` or `NaN`, the function returns `NULL`.

The function accepts arguments with different data types, for example numbers and strings `COALESCE(value, text, 'Unknown')`.

>If the datatypes are different, the database will classify the column as `JAVA_OBJECT` to the [JDBC](https://github.com/axibase/atsd-jdbc) driver.

### LAG

The `LAG` function lets you access the previous row of the same result set. If the previous row doesn't exist, the function returns `NULL`.

```sql
LAG(columnName)
```

```sql
SELECT date_format(datetime, 'yyyy') AS "Date",
  SUM(value) AS "Current Period",
  LAG(SUM(value)) AS "Previous Period",
  SUM(value)-LAG(SUM(value)) AS "Change",
  round(100*(SUM(value)/LAG(SUM(value))-1),1) AS "Change, %"
FROM "cc.cases-by-primary-type"
  WHERE tags.etype = 'OUTAGE'
GROUP BY entity, tags.etype, period(1 year)
```

```ls
| Date | Current Period | Previous Period | Change | Change, % |
|------|----------------|-----------------|--------|-----------|
| 2001 | 654            | null            | null   | null      |
| 2002 | 650            | 654             | -4     | -0.6      |
| 2003 | 590            | 650             | -60    | -9.2      |
```

The function can be referenced in the `WHERE` clause to filter rows based on previous row values:

```sql
SELECT datetime, text, LAG(text)
  FROM "Unit_BatchID"
WHERE entity = 'qz-1211'
 AND text = '800' OR LAG(text) = '800'
```

```ls
| datetime             | text     | lag(text) |
|----------------------|----------|-----------|
| 2017-10-04T01:52:05Z | 700      | null      | -- excluded: text is '900' and LAG is null
| 2017-10-04T02:00:34Z | Inactive | 700       | -- excluded: text is 'Inactive' and LAG = '700'  
| 2017-10-04T02:01:20Z | 800      | Inactive  |
| 2017-10-04T02:03:05Z | Inactive | 800       |
| 2017-10-04T02:03:10Z | 800      | Inactive  |
| 2017-10-04T02:07:05Z | Inactive | 800       |
| 2017-10-04T02:09:09Z | 900      | Inactive  | -- excluded: text is '900' and LAG = 'Inactive'
| 2017-10-04T02:12:30Z | Inactive | 900       | -- excluded: text is 'Inactive' and LAG = '900'
```

The `LAG` function in the `SELECT` expression is applied to the filtered result set, after some rows have been excluded by the `LAG` function as part of the `WHERE` clause. Therefore, `LAG()` in `SELECT` and `LAG()` in `WHERE` clauses may return different values.

```sql
SELECT datetime, LAG(value), value, LEAD(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN '2017-04-02T14:19:15Z' AND '2017-04-02T14:21:15Z'
  --AND value > LAG(value) AND value < LEAD(value)
```

* Rows before filtering

```ls
| datetime             | lag(value) | value | lead(value) |
|----------------------|------------|-------|-------------|
| 2017-04-02T14:19:17Z | null       | 25.5  | 6.1         |
| 2017-04-02T14:19:33Z | 25.5       | 6.1   | 13.3        |
| 2017-04-02T14:19:49Z | 6.1        | 13.3  | 55.0        | +
| 2017-04-02T14:20:05Z | 13.3       | 55.0  | 6.1         |
| 2017-04-02T14:20:21Z | 55.0       | 6.1   | 7.0         |
| 2017-04-02T14:20:37Z | 6.1        | 7.0   | 8.0         | +
| 2017-04-02T14:20:53Z | 7.0        | 8.0   | 20.2        | +
| 2017-04-02T14:21:09Z | 8.0        | 20.2  | null        |
```

* Rows after filtering

```ls
| datetime             | lag(value) | value | lead(value) |
|----------------------|------------|-------|-------------|
| 2017-04-02T14:19:49Z | null       | 13.3  | 7.0         | LAG and LEAD in SELECT show different values
| 2017-04-02T14:20:37Z | 13.3       | 7.0   | 8.0         |
| 2017-04-02T14:20:53Z | 7.0        | 8.0   | null        |
```

### LEAD

The `LEAD` function lets you access the next row of the same result set. If the next row doesn't exist, the function returns `NULL`.

```sql
LEAD(columnName)
```

The `LEAD` function operates similarly to the `LAG` function.

### CAST

The `CAST` function transforms a string into a number, or a number into a string.

```sql
CAST(inputString AS number)
CAST(inputNumber AS string)
```

The returned number can be used in arithmetic expressions, whereas the returned string can be passed as an argument into string functions.

```sql
SELECT datetime, value, entity, tags,
  value/CAST(LOOKUP('disk-size', CONCAT(entity, ',', tags.file_system, ',', tags.mount_point)) AS number) AS "pct_used"
FROM "disk.stats.used"
  WHERE datetime >= CURRENT_HOUR
```

The result of `CAST(inputNumber AS string)` is formatted with the `#.##` pattern to remove the fractional part from integer values stored as decimals. The numbers are rounded to the nearest `0.01`.

`CAST` of `NaN` to string returns `NULL`.

### metrics()

```sql
metrics(string entityName)
```

The `metrics()` function is supported in `atsd_series` queries and retrieves all metrics collected by the specified entity.

The list of metrics can be then optional filtered with additional conditions as part of the `WHERE` clause.

```sql
SELECT metric, datetime, value
  FROM atsd_series
WHERE metric IN metrics('nurswgvml007')
  AND metric LIKE 'mpstat.cpu%'
  -- AND metric NOT LIKE 'df.%'
  AND datetime >= CURRENT_HOUR
ORDER BY datetime
  LIMIT 10
```

```ls
| metric            | datetime             | value |
|-------------------|----------------------|-------|
| mpstat.cpu_system | 2017-04-06T16:00:02Z | 8.3   |
| mpstat.cpu_nice   | 2017-04-06T16:00:02Z | 0.0   |
| mpstat.cpu_steal  | 2017-04-06T16:00:02Z | 0.0   |
| mpstat.cpu_idle   | 2017-04-06T16:00:02Z | 70.7  |
| mpstat.cpu_user   | 2017-04-06T16:00:02Z | 17.9  |
| mpstat.cpu_iowait | 2017-04-06T16:00:02Z | 2.0   |
| mpstat.cpu_busy   | 2017-04-06T16:00:02Z | 29.3  |
| mpstat.cpu_system | 2017-04-06T16:00:18Z | 4.6   |
| mpstat.cpu_nice   | 2017-04-06T16:00:18Z | 0.1   |
| mpstat.cpu_steal  | 2017-04-06T16:00:18Z | 0.0   |
```

### `endtime()`

The `endtime()` function evaluates the specified [calendar](../shared/calendar.md) keywords in the user-defined [time zone](../shared/timezone-list.md).

```sql
ENDTIME(calendarExpression, string timeZone)
```

The function can be used to perform calendar arithmetic in a time zone different from the database time zone.

```sql
SELECT value, datetime,
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'UTC') AS "UTC_datetime",
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'US/Pacific') AS "PST_datetime"
FROM "mpstat.cpu_busy"
  WHERE entity = 'nurswgvml007'
  -- select data between 0h:0m:0s of the previous day and 0h:0m:0s of the current day according to PST time zone
AND datetime BETWEEN endtime(YESTERDAY, 'US/Pacific') AND endtime(CURRENT_DAY, 'US/Pacific')
  ORDER BY datetime
```

```ls
| value | datetime             | UTC_datetime           | PST_datetime           |
|-------|----------------------|------------------------|------------------------|
| 6.86  | 2017-06-16T07:00:05Z | 2017-06-16T07:00:05UTC | 2017-06-16T00:00:05PDT |
| 6.06  | 2017-06-16T07:00:21Z | 2017-06-16T07:00:21UTC | 2017-06-16T00:00:21PDT |
  ....
| 3.03  | 2017-06-17T06:59:29Z | 2017-06-17T06:59:29UTC | 2017-06-16T23:59:29PDT |
| 2.97  | 2017-06-17T06:59:45Z | 2017-06-17T06:59:45UTC | 2017-06-16T23:59:45PDT |
```

### LOOKUP

The `LOOKUP` function translates the key into a corresponding value using the specified replacement table. The function returns a string if the replacement table exists and the key is found, and returns `NULL` otherwise. The key comparison is case-sensitive.

```sql
LOOKUP(string replacementTable, string key)
```

If the key is numeric, such as in the `LOOKUP('table-1', value)` case, the number is formatted with `#.##` pattern to remove fractional `.0` parts from integer values stored as decimals.

* Dictionary

The primary purpose of a replacement table is to act as a dictionary for decoding series tags/values.

```sql
SELECT datetime, entity, ISNULL(LOOKUP('tcp-status-codes', value), value)
  FROM "docker.tcp-connect-status"
WHERE datetime >= NOW - 5*MINUTE
  AND LOOKUP('tcp-status-codes', value) NOT LIKE '%success%'
```

If the searched key is a number provided by the `value` column or an arithmetic expression, it is formatted into a string with a `#.##` pattern.

```ls
1.0     -> 1
1.20    -> 1.2
1.23    -> 1.23
1.2345  -> 1.23
```

For `DIGSTRING(int code)`

```sql
SELECT datetime, entity, value, LOOKUP('pi-system', value)
  FROM atsd_series
WHERE metric = 'digtag-test'
  AND datetime >= PREVIOUS_HOUR
```

* Fact Table

In addition, replacement tables can be used as *fact* tables, storing numeric data without a time dimension.

Replacement table 'us-region':

```ls
1=New-England
2=Middle-Atlantic
3=East-North-Central
...
```

Replacement table 'city-size':

```ls
Akron,OH=197542
Albany,NY=98469
Albuquerque,NM=559121
...
```

```sql
SELECT date_format(time, 'yyyy-MM-dd') AS "date", value, tags.city, tags.state,
  LOOKUP('us-region', tags.region) AS "region",
  LOOKUP('city-size', CONCAT(tags.city, ',', tags.state)) AS "population",
  value/CAST(LOOKUP('city-size', CONCAT(tags.city, ',', tags.state)) AS Number)*1000 AS "cases_per_pop"
FROM "cdc.pneumonia_cases"
  WHERE tags.city = 'Boston'
ORDER BY datetime DESC
  LIMIT 1
```

```ls
| date       | value | tags.city | tags.state | region      | population | cases_per_pop |
|------------|-------|-----------|------------|-------------|------------|---------------|
| 2017-10-01 | 131.0 | Boston    | MA         | New-England | 667137     | 0.2           |
```

## CASE Expression

The `CASE` expression provides a way to use `IF THEN` logic in various parts of the query. Both simple and searched syntax options are supported.

### Searched `CASE` Expression

The searched `CASE` expression evaluates a sequence of boolean expressions and returns a matching result expression.

```sql
CASE  
     WHEN search_expression THEN result_expression
     [ WHEN search_expression THEN result_expression ]
     [ ELSE result_expression ]
END  
```

Each `search_expression` should evaluate to a boolean (true/false) value.

The `result_expression` can be a number, a string, or an expression. Result expressions may return values of different data types.

>If the data types are different (such as a number and a string), the database will classify the column with `JAVA_OBJECT` to the [JDBC](https://github.com/axibase/atsd-jdbc) driver.

If no `search_expression` is matched and the `ELSE` condition is not specified, the `CASE` expression returns `NULL`.

```sql
SELECT entity, tags.*, value,
  CASE
    WHEN LOCATE('//', tags.file_system) = 1 THEN 'nfs'
    ELSE 'local'
  END AS "FS_Type"
  FROM "df.disk_used"
WHERE datetime >= CURRENT_HOUR
  WITH ROW_NUMBER(entity, tags ORDER BY time DESC) <= 1
```

```ls
| entity       | tags.file_system                    | tags.mount_point | value      | FS_Type |
|--------------|-------------------------------------|------------------|------------|---------|
| nurswgvml006 | //u113411.store01/backup            | /mnt/u113411     | 1791024684 | nfs     |
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | /                | 6045216    | local   |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive | 56934368   | local   |
| nurswgvml007 | //u113563.store02/backup            | /mnt/u113563     | 1791024684 | nfs     |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                | 9064008    | local   |
```

```sql
SELECT entity, AVG(value),
    CASE
      WHEN AVG(value) < 20 THEN 'under-utilized'
      WHEN AVG(value) > 80 THEN 'over-utilized'
      ELSE 'right-sized'
    END AS "Utilization"
  FROM "mpstat.cpu_busy"
WHERE datetime >= CURRENT_HOUR
  GROUP BY entity
```

The `CASE` expression can be used to handle `NULL` and `NaN` values:

```sql
SELECT entity, datetime, value, text,
  CASE
    WHEN value IS NULL THEN -1
    ELSE value
  END,
  CASE
    WHEN text IS NULL THEN 'CASE: text is NULL'
    ELSE text
  END
  FROM atsd_series
WHERE metric IN ('temperature', 'status')
  AND datetime >= '2017-10-13T08:00:00Z'
```

### Simple `CASE` Expression

The simple `CASE` expression compares the `input_expression` with `compare_expression`s and returns the `result_expression` when the comparison is true.

```sql
CASE input_expression
     WHEN compare_expression THEN result_expression
     [ WHEN compare_expression THEN result_expression ]
     [ ELSE result_expression ]
END  
```

```sql
SELECT entity, datetime, value,
  CASE entity
    WHEN 'nurswgvml006' THEN 'NUR-1'
    WHEN 'nurswgvml301' OR 'nurswgvml302' THEN 'NUR-3'
    ELSE 'Unknown'
  END AS "location"
FROM "mpstat.cpu_busy"
  WHERE datetime >= PREVIOUS_MINUTE
```

The `CASE` expressions can be nested by using `CASE` within the `result_expression`:

```sql
CASE date_format(time, 'yyyy')           
    WHEN '2016' THEN
      CASE
        WHEN CAST(date_format(time, 'D') AS NUMBER) > 5 THEN '17'
        ELSE '16'
      END
    WHEN '2017' THEN '18'
    WHEN '2018' THEN '17'      
    ELSE '15'
END AS "Tax Day"
```

## Interval Number

The `INTERVAL_NUMBER()` function can be referenced in the `SELECT` expression. It returns an index, starting with `1`, of the current time interval in queries selecting [multiple intervals](#interval-condition) using a `datetime` `OR` condition or `datetime` subquery.

```sql
SELECT datetime, count(*), INTERVAL_NUMBER()
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND (datetime BETWEEN current_day AND next_day
    OR datetime BETWEEN current_day-1*WEEK AND next_day-1*WEEK)
GROUP BY PERIOD(1 DAY)
```

```ls
| datetime             | count(*) | interval_number() |
|----------------------|----------|-------------------|
| 2017-04-09T00:00:00Z | 5393     | 1                 |
| 2017-04-16T00:00:00Z | 5191     | 2                 |
```

## Case Sensitivity

* SQL keywords are case-insensitive.
* Entity column values, metric column values, and tag names are case-**insensitive**, except in `LIKE` and `REGEX` operators.
* Text column values are case-**sensitive**.
* Tag column values are case-**sensitive**.

```sql
SELECT metric, entity, datetime, value, tags.*
  FROM "df.disk_used"
WHERE datetime >= NOW - 5*MINUTE
  AND entity = 'NurSwgvml007' -- case-INSENSITIVE entity value
  AND tags.file_system = '/dev/mapper/vg_nurswgvml007-lv_root' -- case-sensitive tag value
```

```ls
| metric       | entity       | datetime             | value     | tags.mount_point | tags.file_system                    |
|--------------|--------------|----------------------|-----------|------------------|-------------------------------------|
| df.disk_used | nurswgvml007 | 2017-06-19T06:12:26Z | 8715136.0 | /                | /dev/mapper/vg_nurswgvml007-lv_root |
```

Changing the case of a tag value condition `tags.file_system = '/DEV/mapper/vg_nurswgvml007-lv_root'` would cause the error **TAG_VALUE not found**.

## NULL

Scalar expressions with arithmetic operators such as `number + NULL` produce `NULL` if any operand is `NULL`.

Likewise, numeric and string operators, except `IS NULL` and `IS NOT NULL`, return `NULL` if any operand is `NULL`.

`IS NULL` and `IS NOT NULL` operators are supported for `tags.{name}` and `tags.entity.{name}` columns in the `WHERE` clause.

Assuming tags.status is `NULL`:

| **Result** | **Expression** |
|:---|:---|
| `NULL` | `tags.status > 'a'` |
| `NULL` | `tags.status <= 'a'` |
| `NULL` | `tags.status <> 'a'` |
| `NULL` | `tags.status = NULL` |
| `NULL` | `tags.status = NULL` |
| `NULL` | `tags.status <> NULL` |
| `NULL` | `tags.status = tags.status` |
| `true` | `tags.status IS NULL` |
| `false` | `tags.status IS NOT NULL` |
| `NULL` | `tags.status IS NULL AND tags.status = NULL` |

Since the `WHERE` clause selects only rows that evaluate to `true`, conditions such as `tags.{name} = 'a' OR tags.{name} != 'a'` will not include rows with undefined `{name}` tag because both expressions will evaluate to `NULL` and (`NULL` OR `NULL`) still returns `NULL`.

`NULL` and `NaN` values are ignored by aggregate functions.

Logical expressions treat `NaN` as `NULL`. Refer to the truth tables above for more details on how `NULL` is evaluated by logical operators.

## Not a Number (NaN)

Unlike relational databases where division by zero or square root of a negative number may cause an execution error, ATSD returns special values if the computation result cannot be represented with a real number.

The returned values follow [IEEE 754-2008](https://standards.ieee.org/findstds/standard/754-2008.html) standard.

* NaN for indeterminate results such as `0/0` (zero divided by zero).
* NaN for illegal values
* Signed Infinity for x/0 where x != 0

Since the `long/bigint` data type does not have a reserved `Infinity` value, the returned Double `Infinity` value, when cast to `long`, is set to the `Long.MAX_VALUE`/`Long.MIN_VALUE` value.

```sql
SELECT value, SQRT(value-1), value/0, 1/0, -1/0, 1/0-1/0
  FROM "mpstat.cpu_busy"
LIMIT 1
```

```ls
| value | SQRT(value-1) | value/0 | 1111111111/0          | 1/0 | -1/0 | 1/0-1/0 |
|-------|---------------|---------|-----------------------|-----|------|---------|
| 0.0   | NaN           | NaN     | 9223372036854775807.0 | ∞   | -∞   | NaN     |
```

The result of comparing NaN with another number is indeterminate (NULL).

## Authorization

The database filters returned records based on [entity read permissions](../administration/user-authorization.md#entity-permissions) of the user executing the query.

As a result, the same query executed by different users may produce [different result sets](permissions.md).

Scheduled SQL queries are executed with [All Entities: Read](../administration/user-authorization.md#all-entities-permissions) permission and are not filtered.

## Options

The `OPTION` clause provides hints to the database optimizer on how to execute the given query most efficiently.

The query may contain multiple `OPTION` clauses specified at the end of the statement.

### `ROW_MEMORY_THRESHOLD` Option

The database may choose to process rows using the local file system as opposed to memory if the query includes one of the following clauses:

* `JOIN`
* `ORDER BY`
* `GROUP BY`
* `WITH INTERPOLATE`
* `WITH ROW_NUMBER`

The `OPTION (ROW_MEMORY_THRESHOLD {n})` forces the database to perform processing in memory if the number of rows is within the specified threshold `{n}`.

Example:

```sql
SELECT entity, datetime, AVG(value), tags
  FROM "df.disk_used"
WHERE datetime >= CURRENT_DAY
  GROUP BY entity, tags, PERIOD(2 HOUR)
ORDER BY entity, tags.file_system, datetime
  OPTION (ROW_MEMORY_THRESHOLD 10000)
```

If `{n}` is zero or negative, the results are processed using the local file system.

This clause overrides the conditional allocation of shared memory established with the **Settings:Server Properties**:`sql.tmp.storage.max_rows_in_memory` setting which is set to `50*1024` rows by default.

The `sql.tmp.storage.max_rows_in_memory` limit is shared by concurrently executing queries. If a query selects more rows than remain in the shared memory, it will be processed using the local file system which may result in increased response times during heavy read activity.

> The row count threshold is applied to the number of rows selected from the underlying table, and not the number rows returned to the client.

**Example**. Temporary Table Grouping and In-Memory Ordering

![Temp Table Grouping and In-Memory Ordering](images/in-memory-ordering.png)

## API Endpoint

The API SQL endpoint is located at the `/api/sql` path.

### Specification

[SQL Query API Endpoint](api.md)

### Validation Query

To test a connection, execute the following query:

```sql
SELECT 1
```

This query can be utilized as a validation query in database connection pool implementations such as [Apache Commons DBCP](https://commons.apache.org/proper/commons-dbcp/configuration.html).

### Sample Responses

* [JSON format](sql.json)
* [CSV format](sql.csv)

## Scheduler

SQL statements can be executed interactively via the SQL console as well as on a [schedule](scheduled-sql.md).

Scheduled execution allows for generated report files to be distributed to email subscribers or stored on a local file system.

The data returned by SQL statements can be exported in the following formats:

|**Endpoint**|**Formats**|
|:---|:---|
|API  |CSV, JSON|
|Web Console  |CSV, JSON, HTML|
|Scheduler|CSV, JSON, Excel|

The [**Store** option](scheduled-sql-store.md) allows for query results to be stored back in the database as new derived series.

## Monitoring

Monitoring query execution is an important administrative task in order to optimize database performance, to identify and prevent expensive and long-running queries, and to provide feedback to end-users and application developers.

### Query Reporting

The database keeps track of query executions including detailed statistics in an in-memory structure. The list of running and completed queries is available on the **Admin:SQL Query Statistics** page.

The list can be filtered by user, source, status, query part, and elapsed time. Additional information about the query is displayed on the query detail page.

Users with an `ADMIN` role are authorized to view and cancel all queries whereas non-administrative users are restricted to viewing and cancelling only their own queries.

![Query Reporting](images/sql-query-reporting.png)

Query Detail Fields:

| **Name** | **Description** |
|:---|:---|
| `Status` | New, Running, Completed, Error, Cancelled. |
| `Source` | api, console, scheduled. |
| `User` | Name of the user who initiated the query.<br>For API clients, username specified in login credentials. |
| `Query Id` | Unique query identifier. |
| `Query Text` | Query statement text. |
| `Start Time` | Query start time. |
| `Elapsed Time` | Time elapsed between start time and completion (or current) time. |
| `Returned Records` | Number of rows returned to the client. |
| `Records Fetched` | Number of time:value pairs. |
| `Rows Fetched` | Number of HBase rows. |
| `Result Bytes` | Number of bytes in Result objects from HBase region servers. |
| `Remote Result Bytes` | Number of bytes in Result objects from remote region servers. |
| `Millis between next()` | Total number of milliseconds spent between sequential scan.next() calls. |
| `RPC Calls` | Number of RPC calls. |
| `RPC Remote Calls` | Number of remote RPC calls. |
| `RPC Retries` | Number of RPC retries. |
| `RPC Remote Retries` | Number of remote RPC retries.  |
| `Regions Scanned` | Number of regions scanned. |
| `Regions Not Serving` | Number of `NotServingRegionException` instances caught. |

![Query Details](images/sql-query-details.png)

### Cancelling Queries

A running query can be cancelled at any time, for example if its is execution time is longer than expected.

When a query is cancelled results are not returned to the client and the query is terminated with an error.

A query submitted via the `/api/sql` endpoint can be [cancelled](api.md#cancelling-the-query) by submitting a request to `/api/sql/cancel?queryId=myid` url and referencing the user-defined handle with the `queryId` parameter.

### Query Logging

Queries executed by the database are recorded in the main application log `atsd.log` at the INFO level.

Each query is assigned a unique identifier for correlating starting and closing events.

```txt
2017-08-15 18:44:01,183;INFO;qtp1878912978-182;com.axibase.tsd.service.sql.SqlQueryServiceImpl;Starting sql query execution. [uid=218], user: user003, source: scheduled, sql: SELECT entity, AVG(value) AS "Average", median(value), MAX(value), count(*),
   percentile(50, value), percentile(75, value), percentile(90, value),  percentile(99, value) FROM "mpstat.cpu_busy"
  WHERE time BETWEEN PREVIOUS_DAY and CURRENT_DAY GROUP BY entity ORDER BY AVG(value) DESC

2017-08-15 18:44:02,369;INFO;qtp1878912978-182;com.axibase.tsd.service.sql.SqlQueryServiceImpl;Sql query execution took 1.19 s, rows returned 7. [uid=218], user: user003, sql: SELECT entity, AVG(value) AS "Average", median(value), MAX(value), count(*),
   percentile(50, value), percentile(75, value), percentile(90, value),  percentile(99, value) FROM "mpstat.cpu_busy"
  WHERE time BETWEEN PREVIOUS_DAY and CURRENT_DAY GROUP BY entity ORDER BY AVG(value) DESC
```

### Query Control Messages

Execution events are also stored as messages with type=`sql` and source=`api|console|scheduled` for monitoring query performance using the built-in Rule Engine.

The following message tags are available for filtering and grouping:

| **Name** | **Description** |
|:---|:---|
| `uid`    | Unique query id which is reset on application restart. |
| `format` | Result set format: csv, json, html. |
| `user`   | User initiating the query. |
| `query`  | Query text. |

> Messages for scheduled queries include additional tags `query_name`, `query_id`, `output_path`, `email_subject`, and `email_subscribers`.

## Query Performance

The most efficient query path is **metric+entity+date+tags**.

Query execution speed can be improved by adopting the following guidelines for the `WHERE` clause:

* Specify start time and end time whenever possible to limit the time range.
* Specify entity name whenever possible to avoid a scan of all rows in the virtual table.

## Optimizing

Given the massive amount of data stored in ATSD, it is possible to build a query that may cause performance issues for the database.

Consider the following recommendations when developing queries:

* Pre-test queries on a smaller dataset in an ATSD-development instance.
* Avoid queries without any conditions. Apply `LIMIT` to reduce the number of rows returned.
* Add the `WHERE` clause. Include as many conditions to the `WHERE` clause as possible, in particular add entity and [interval conditions](#interval-condition).
* Make `WHERE` conditions narrow and specific, for example, specify a small time interval.
* Avoid the `ORDER BY` clause since it may cause a full scan and a copy of data to a temporary table.
* Add the `LIMIT 1` clause to reduce the number of rows returned. Note that `LIMIT` will not prevent expensive queries with `ORDER BY` and `GROUP BY` clauses because `LIMIT` is applied to final results and not to the number of rows read from the database.
* Develop a simple query first. Adjust conditions gradually as you inspect the results. Add grouping, partitioning, and ordering to finalize the query.

To assist in inspecting query results, the following `LIMIT 1` queries have been locally optimized to provide improved performance:

Ascending order:

```sql
SELECT * FROM "mpstat.cpu_busy" LIMIT 1
SELECT * FROM "mpstat.cpu_busy" ORDER BY datetime LIMIT 1
SELECT * FROM "mpstat.cpu_busy" WHERE entity = 'nurswgvml007' ORDER BY datetime LIMIT 1
```

Descending order:

```sql
SELECT * FROM "mpstat.cpu_busy" ORDER BY time DESC LIMIT 1
SELECT * FROM "mpstat.cpu_busy" ORDER BY datetime DESC LIMIT 1
SELECT * FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_DAY ORDER BY time DESC LIMIT 1
SELECT * FROM "mpstat.cpu_busy" WHERE entity = 'nurswgvml007' ORDER BY datetime DESC LIMIT 1
```

## SQL Compatibility

While the [differences](https://github.com/axibase/atsd-jdbc/blob/master/capabilities.md#database-capabilities) between SQL dialect implemented in ATSD and SQL specification standards are numerous, the following exceptions to widely used constructs are worth mentioning:

* Self-joins are not supported.
* `LEFT OUTER JOIN` and `RIGHT OUTER JOIN` queries are not supported.
* Subqueries are supported only by the `BETWEEN` operator applied to the `time` and `datetime` columns.
* `UNION`, `EXCEPT` and `INTERSECT` operators are not supported. Query [atsd_series](examples/select-atsd_series.md) table as a `UNION ALL` alternative.
* In case of division by zero, the database returns `NaN` according to the IEEE 754-2008 standard instead of terminating processing with a computational error.
* The `WITH` operator is supported only in the following clauses: `WITH ROW_NUMBER`, `WITH INTERPOLATE`.
* The `DISTINCT` operator is not supported and can be emulated with the `GROUP BY` clause in specific cases.

## Examples

### Selecting Examples

* [All Columns](examples/select-all-columns.md)
* [Defined Columns](examples/select-pre-defined-columns.md)
* [All Series Tags](examples/select-all-tags.md)
* [Text Value Column](examples/select-text-value.md)
* [Field Columns](examples/select-field-columns.md)
* [Entity Tag Columns](examples/select-entity-tag-columns.md)
* [Entity Metadata](examples/select-metadata.md)
* [Metric Tag Columns](examples/select-metric-tag-columns.md)
* [Computed Columns](examples/select-computed-columns.md)
* [Mathematical Functions](examples/select-math.md)
* [String Functions](examples/string-functions.md)
* [LOOKUP Function](examples/lookup.md)
* [CASE Expression](examples/case.md)
* [Interval Number](examples/select-interval-number.md)
* [Column Alias](examples/alias-column.md)
* [Table Alias](examples/alias-table.md)
* [Escape Quotes](examples/select-escape-quote.md)
* [atsd_series Table](examples/select-atsd_series.md)
* [Date Format](examples/datetime-format.md)
* [Date Extract Functions](examples/date-extract.md)
* [Date Utility Functions](examples/date-functions.md)
* [Limit Row Count](examples/limit.md)
* [Limit by Partition](examples/limit-partition.md)

### Filtering Examples

* [Filter by Date](examples/filter-by-date.md)
* [Filter by Series Tag](examples/filter-by-series-tag.md)
* [Filter by NULL Series Tag](examples/filter-null-tag.md)
* [Filter by Series Tag with Comparison Operators](examples/filter-operators-string.md)
* [Filter by Entity](examples/filter-by-entity.md)
* [Filter by Entity Tag](examples/filter-by-entity-tag.md)
* [Filter by Entity Group](examples/filter-by-entity-group.md)
* [Filter Not-a-Number](examples/filter-not-a-number.md)

### Ordering Examples

* [Order By Time](examples/order-by-time.md)
* [Order By Value](examples/order-by-value.md)
* [Order By Multiple Columns](examples/order-by-multiple-columns.md)
* [String Collation](examples/order-by-string-collation.md)

### Aggregation

* [Average Value](examples/aggregate.md)
* [Percentiles](examples/aggregate-percentiles.md)
* [First/Last](examples/aggregate-first-last.md)
* [Counter Aggregator](examples/aggregate-counter.md)
* [Maximum Value Time](examples/aggregate-max-value-time.md)
* [Period Aggregation](examples/aggregate-period.md)
* [Sliding Window Statistics](examples/aggregate-sliding-window.md)

### Grouping Examples

* [Group by Query with Order By](examples/group-by-query-with-order-by.md)
* [Grouped Average](examples/grouped-average.md)
* [Group by Tags](examples/group-by-tags.md)
* [Group with Having](examples/group-having.md)
* [Grouped and Having](examples/grouped-having.md)

### Interpolation Examples

* [Interpolate](examples/interpolate.md)
* [Interpolate with Extend](examples/interpolate-extend.md)
* [Interpolate Edges](examples/interpolate-edges.md)

### Regularization Examples

* [Linear Function](examples/regularize.md#interpolation-function-linear)
* [Previous (Step) Function](examples/regularize.md#interpolation-function-previous)
* [Auto Function](examples/regularize.md#interpolation-function-auto)
* [Fill](examples/regularize.md#fill-nan)
* [Alignment](examples/regularize.md#alignment)
* [Comparison with GROUP BY](examples/regularize.md#group-by-period-compared-to-with-interpolate)
* [Join regularized series](examples/regularize.md#join-example)
* [Interpolated Value Filter](examples/regularize.md#value-filter)

### Partitioning Examples

* [Partitioning using Row Number Function](examples/partition-row-number.md)
* [Top-N Query using Row Number Function](examples/partition-row-number-top-N-tags.md)
* [Last Time](examples/last-time.md)

### Subquery Examples

* [Inline Views](examples/inline-view.md)

### Join Examples

* [Join](examples/join.md)
* [Join Using Entity](examples/join-using-entity.md)
* [Join: Derived Series](examples/join-derived-series.md)
* [Outer Join With Aggregation](examples/outer-join-with-aggregation.md)
* [Outer Join](examples/outer-join.md)

### Security Examples

* [Permissions](permissions.md)

### Consolidated Examples

* [PI Compatibility](examples/pi.md)
