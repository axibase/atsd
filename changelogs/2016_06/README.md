# Weekly Change Log: December 19-25, 2016

## ATSD

| Issue| Category    | Type    | Subject                                                                                               |
|------|-------------|---------|-------------------------------------------------------------------------------------------------------|
| [3737](#issue-3737) | sql         | Bug     | Fixed issue with long scan, followed by a timeout for an entity that does not collect the specified metric. |
| [3735](#issue-3735) | sql         | Bug     | Math functions do not accept arithmetic expressions in the `WHERE` clause. Updated error message to read `IllegalArgumentException: Aggregate functions are not supported in the WHERE clause`. |
| 3731 | api-rest    | Bug     | Fixed issue with property queries (`addMeta`:true) not returning metadata if the property type was set to `$entity_tags`. |
| 3729 | api-rest    | Bug     | Updated error URL and message text for requests to non-existent URLs. |
| [3727](#issue-3727) | api-network | Feature | Optimized TCP handler for faster processing of `series` commands streamed by a single TCP client. |
| [3725](#issue-3725) | sql         | Bug     | Optimized queries with `ORDER BY` and `LIMIT` clauses. |
| [3719](#issue-3719) | sql         | Feature | Optimized [windowing](../../sql/README.md#last_time-syntax) queries by narrowing the requested timespan based on minimum last insert date. |
| 3718 | UI          | Bug     | Changed metric form to prevent users from saving metric names without metric name validation. |
| 3715 | UI          | Feature | Updated styles on the account create page displayed post-installation. |
| 3714 | UI          | Bug     | Fixed errors with the Decimal Precision input in the [SQL Console](../../sql/sql-console.md). |
| [3713](#issue-3713) | sql         | Bug     | Fixed number format error raised in queries with the `WHERE` clause. |
| [3703](#issue-3703) | sql         | Feature | Added capability to display first/last sample time in windowing queries. |
| [3697](#issue-3697) | sql         | Feature | Modified processing sequence so that the `HAVING` filter is applied after period interpolation. |
| [3696](#issue-3696) | sql         | Bug     | Fixed issue with `ORDER BY [column-index]`. |
| [3694](#issue-3694) | sql         | Bug     | Optimized execution of `JOIN` queries by applying tag filters to all tables. |
| 3693 | UI          | Bug     | Fixed navigation issue between Query console and Query Plan. |
| [3689](#issue-3689) | sql         | Feature | Added support for the `SELECT 1` validation query. |
| 3687 | UI          | Bug     | Corrected User Group link on the Admin menu. |
| [3672](#issue-3672) | sql         | Feature | Added new details to query plan: start and end dates for each HBase scan and scans to atsd_li table. |
| [3555](#issue-3555) | sql         | Feature | Implemented [`LOOKUP`](../../sql/README.md#lookup) function to translate the key into a value using the specified replacement table. |
| [3421](#issue-3421) | sql         | Feature | Implemented the `searched case` variant of the [`CASE`](../../sql/README.md#case-expression) expression. |

## Collector

| Issue| Category    | Type    | Subject                                                                                               |
|------|-------------|---------|-------------------------------------------------------------------------------------------------------|
| 3732 | core        | Feature | Modified Collector start-up routine to wait until ATSD is ready when running jobs from the `docker-compose` file. |
| 3724 | core        | Feature     | Created a `docker-compose` file to launch `socrata-cdc` and the ATSD/Collector container bundle, used for computing statistics. |
| 3723 | data-source | Bug     | Added missing Avatica package dependencies to the ATSD JDBC driver. |
| 3722 | core        | Feature | Send `property` command with collector details to ATSD after a startup is completed. |
| 3686 | core        | Support | Added a list of pre-configured jobs and their xml files [here](https://axibase.com/docs/axibase-collector/job-autostart.html). |
| 3571 | admin       | Bug     | Modified Dockerfile to speed up Collector application startup at the expense of a slight larger image size. |

### Issue 3737

```sql
SELECT entity, tags.*, value, datetime
  FROM disk_used
WHERE datetime > now - 1 * day
  AND entity = 'nurswgvml501'
  WITH ROW_NUMBER(entity, tags ORDER BY time DESC) <= 1
```

### Issue 3735

```sql
SELECT entity, avg(value), ABS((last(value) / avg(value) - 1)*100)
  FROM cpu_busy
WHERE datetime > previous_minute
  AND ABS(value) > 0
GROUP BY entity
  HAVING ABS((last(value) / avg(value) - 1)*100) > 0
```

### Issue 3727

The TCP handler, running on the default port 8081, was optimized for faster processing of `series` commands streamed by a single TCP client. The new implementation provides a pool of
threads instead of a single one to offload parsing and processing from the TCP handler. The size of the pool is controlled with the `series.processing.pool.size` parameter on the
**Settings > Server Properties** page. The default value is 2 and is recommended to be set to the number of cores on the server.

As a result, the TCP processing and parsing throughput (measured in commands per second) has increased by 40% on average.

### Issue 3725

Previously, execution of queries with the `LIMIT` clause involved copying selected rows into a temporary table, even if only a small subset of the rows, restricted with `LIMIT`, was required.
Both `ASC` and `DESC` ordered results were optimized by reducing the number of rows copied into a temporary table. The following queries should see a 90% speedup in execution time.

```sql
SELECT *
  FROM mpstat.cpu_busy tot
  ORDER BY datetime DESC
LIMIT 10
```

```sql
SELECT *
  FROM mpstat.cpu_busy tot
  ORDER BY datetime
LIMIT 10
```

### Issue 3719

We added an optimization to narrow the start date in [windowing](../../sql/README.md#last_time-syntax) queries which is now determined as the minimum (last insert date) for all series.
Prior to this change, the start date was set to 0 (not applied) if it was not specified explicitly in the query.

```sql
SELECT date_format(time, 'yyyy-MM-dd') as 'date',
  tags.city, tags.state, sum(value)
FROM "dmv.incidents"
  GROUP BY entity, tags, datetime
WITH time = last_time
  ORDER BY sum(value) desc
```

The above query scans data with a start date determined as the earliest of all the matching series.
For example, if you have 3 series with the following last insert dates:

* A - 2016-12-21
* B - 2016-10-05
* C - 2016-12-20

The SQL optimizer adds a condition `AND datetime >= '2016-20-05T00:00:00Z'`, even if the interval condition is not included in the query.

### Issue 3713

```sql
SELECT tot.datetime, tot.tags.city as 'city', tot.tags.state as 'state',
 tot.value - t1.value - t24.value - t44.value - t64.value - t64o.value as 'other_deaths',
 t1.value as 'infant_deaths',
 t24.value as '1-24_deaths',
 t44.value as '25-44_deaths',
 t64.value as '45-64_deaths',
 t64o.value as '64+_deaths',
 tot.value as 'all_deaths'
FROM cdc.all_deaths tot
 JOIN cdc._1_year t1
 JOIN cdc._1_24_years t24
 JOIN cdc._25_44_years t44
 JOIN cdc._54_64_years t64
 JOIN cdc._65_years t64o
WHERE tot.entity = 'mr8w-325u'
 AND tot.tags.city = 'New York'
 AND tot.datetime > '2016-08-27T00:00:00Z'
 AND (tot.value - t1.value - t24.value - t44.value - t64.value - t64o.value) != 0
OPTION (ROW_MEMORY_THRESHOLD 500000)
```

### Issue 3703

Now aggregate functions such as `MAX`, `MIN`, and `DELTA` can be applied to the `time` column, which returns the sampling time in Unix milliseconds.
One of the use cases is to display the most recent time in windowing queries where the [last_time](../../sql/README.md#last_time-syntax) function can be utilized to select data for a sliding interval, such as the most recent 4 weeks for each series in the example below.

```sql
SELECT tags.city, tags.state, sum(value), date_format(max(time)) as Last_Date
  FROM dmv.incidents
GROUP BY entity, tags
  WITH time > last_time - 2*week
ORDER BY max(time)
```

```ls
| tags.city    | tags.state | sum(value) | Last_Date                |
|--------------|------------|------------|--------------------------|
| Fort Worth   | TX         | 411        | 2009-01-31T00:00:00.000Z |
| Philadelphia | PA         | 53882      | 2012-11-24T00:00:00.000Z |
| Pittsburgh   | PA         | 38926      | 2015-06-27T00:00:00.000Z |
| New Haven    | CT         | 13311      | 2016-07-16T00:00:00.000Z |
| Washington   | DC         | 41937      | 2016-08-06T00:00:00.000Z |
```

### Issue 3697

The sequence of period interpolation and period filtering with the [HAVING](../../sql/README.md#having-filter) clause was modified.
Now, the `HAVING` filter is applied after [PERIOD interpolation](../../sql/README.md#interpolation) whereas before it was the opposite.

```sql
SELECT date_format(period(1 MONTH)), count(value)
  FROM dmv.incidents
WHERE tags.city = 'Boston'
  AND datetime >= '2016-09-01T00:00:00Z' AND datetime < '2016-12-01T00:00:00Z'
GROUP BY period(1 MONTH, VALUE 0)
  HAVING count(value) > 0
ORDER BY datetime
```

Assuming there were no detailed records for this series in October 2016, the current result looks as follows:

```ls
| date_format(period(1 MONTH)) | sum(value) | count(value) |
|------------------------------|------------|--------------|
| 2016-09-01T00:00:00.000Z     | 537.0      | 4.0          |
| 2016-11-01T00:00:00.000Z     | 234.0      | 4.0          |
```

Previous result:

```ls
| date_format(period(1 MONTH)) | sum(value) | count(value) |
|------------------------------|------------|--------------|
| 2016-09-01T00:00:00.000Z     | 537.0      | 4.0          |
| 2016-10-01T00:00:00.000Z     | 0.0        | 0.0          | <- this period was added by interpolation set in period(1 MONTH, VALUE 0), after HAVING.
| 2016-11-01T00:00:00.000Z     | 234.0      | 4.0          |
```

### Issue 3696

```sql
SELECT date_format(period(1 MONTH)), sum(value), count(value)
  FROM cdc.all_deaths tot
WHERE tags.city = 'Boston'
  AND datetime >= '2016-01-01T00:00:00Z'
GROUP BY period(1 MONTH)
  HAVING count(value) >= 4
ORDER BY 1
```

### Issue 3694

The query optimizer was modified to apply tag filter specified in `JOIN` queries on one of the tables to the remaining tables, since
[JOINs](../../sql/README.md#joins) in ATSD perform merging of rows on time, entity, and series tags anyway. Prior to this change, the tag filter
was applied only to those tables where the filter was set explicitly.

![Figure 2](./Images/Figure2.png)

### Issue 3689

Implemented the special `SELECT 1` query, which is typically used to [test connectivity](../../sql/api.md#connection-query) and validate open
connections in the shared connection pool in active state.

### Issue 3672

SQL Query Plan is used for diagnosing slow query response times. The plan was extended to:

1) Display start and end dates for each HBase scan.</br>
2) Display scans to the atsd_li (last insert) table, which are used to add additional filters and to determine optimal query plan.</br>

![Figure 3](./Images/Figure3.png)

### Issue 3555

Implemented the [LOOKUP](../../sql/README.md#lookup) function, which translates the key into a value using the specified replacement table.

The primary purpose of a replacement table is to act as a dictionary for decoding series tags/values.

```sql
SELECT datetime, entity, value, LOOKUP('tcp-status-codes', value)
  FROM 'docker.tcp-connect-status'
WHERE datetime > now - 5 * MINUTE
  AND LOOKUP('tcp-status-codes', value) NOT LIKE '*success*'
LIMIT 10
```

```ls
| datetime                 | entity   | value | LOOKUP('tcp-status-codes',value) |
|--------------------------|----------|-------|----------------------------------|
| 2016-12-28T13:06:11.085Z | 1f4faa42 | 1     | Connection Error                 |
| 2016-12-28T13:06:11.085Z | 131b6339 | 1     | Connection Error                 |
| 2016-12-28T13:06:11.085Z | 37dc00da | 2     | No Route To Host                 |
```

### Issue 3421

Implemented the `searched case` variant of the [CASE](../../sql/README.md#case-expression) expression.

The `CASE` expression evaluates a sequence of boolean expressions and returns a matching result expression.

```sql
CASE
     WHEN search_expression THEN result_expression
     [ WHEN search_expression THEN result_expression ]
     [ ELSE result_expression ]
END
```

Refer to [examples](../../sql/examples/case.md) for additional information.

```sql
SELECT entity, avg(value),
    CASE
      WHEN avg(value) < 20 THEN 'under-utilized'
      WHEN avg(value) > 80 THEN 'over-utilized'
      ELSE 'right-sized'
    END AS 'Utilization'
  FROM cpu_busy
WHERE datetime > current_hour
  GROUP BY entity
```

```ls
| entity       | avg(value) | Utilization    |
|--------------|------------|----------------|
| nurswgvml006 | 6.2        | under-utilized |
| nurswgvml007 | 80.8       | over-utilized  |
| nurswgvml010 | 3.8        | under-utilized |
```
