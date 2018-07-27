# Weekly Change Log: December 25, 2016 - January 08, 2017

## ATSD

| Issue         | Category        | Type | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3756](#issue-3756)          | sql             | Bug     | Tag filter for the 2nd table removes all rows in `JOIN` queries.                          |
| [3751](#issue-3751)          | api-rest        | Bug     | `isEmpty()` function causes parse error in the series [query](../../api/data/series/query.md) method.                                               |
| [3749](#issue-3749)          | sql             | Bug     | `LOCATE` function raises NPE in the `WHERE` clause.                                     |
| 3748          | test            | Support | CE web tests failing.                                                           |
| [3747](#issue-3747)          | sql             | Feature | `CAST` does not allow `date_format`.                                                 |
| [3746](#issue-3746)          | sql             | Feature | `u` pattern in the `date_format` function.                                            |
| [3741](#issue-3741)          | sql             | Bug     | `JOIN USING entity` fails to correctly merge rows with tags.                                                              |
| [3740](#issue-3740)          | api-rest        | Bug     | Series [query](../../api/data/series/query.md) for versioned metrics does not provide a history of text values. |
| [3738](#issue-3738)          | sql             | Bug     | Math function `ABS()` does not accept 2nd aggregate expressions. |
| [3721](#issue-3721)          | sql             | Feature | `LIKE` comparator optimized.                                                                |
| [3711](#issue-3711)          | sql             | Bug     | Slow parsing of queries with 30+ arguments in arithmetic expressions in the `SELECT` clause. |
| [3695](#issue-3695)          | sql             | Bug     | `GROUP BY` with join fails to return records.                                     |
| [3661](#issue-3661)          | sql             | Feature | [`CAST`](../../sql/README.md#cast) function implemented. |
| 3527          | jdbc            | Bug     | DbVisualizer hangs after repetitive query cancellations with the ATSD JDBC driver.  |

### Collector

| Issue         | Category        | Type | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3743](#issue-3743)          | pi              | Feature | Developed PI Server emulator for `picomp2` and `pipoint2` tables.                   |

## Charts

| Issue         | Category        | Type | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3754](#issue-3754)          | bar             | Bug     | Columns not created for series with statistic and wildcard matches.                          |
| [3654](#issue-3654)          | widget-settings | Feature | Support for meta fields in label-format.                                           |
| [3636](#issue-3636)          | data-loading    | Bug     | Series not displayed if requested for the entity group or with the entity expression.                                         |
| [3143](#issue-3143)          | table           | Bug     | Value and time columns of series with shorter periods are not displayed.         |

### Issue 3756

Fixed the SQL executor to return correct results for a query containing a tag filter on a joined table (`t64o.tags.city = 'New York'`).

```sql
SELECT t1.datetime, count(t1.value), count(t2.value)
  FROM dmv_incidents t1
  JOIN dmv_registrations t2
WHERE t1.entity = 'mr8w-325u'
  AND t1.tags.city = 'New York'
  AND t2.tags.city = 'New York'
GROUP BY t1.tags, t1.period(1 year)
```

### Issue 3751

Addressed an error for `entityExpression` in [series](../../api/data/series/query.md) query method when `isEmpty()` is specified with brackets.

```json
[{
  "startDate": "2016-12-27T09:59:30Z",
  "endDate":   "2016-12-27T10:00:00Z",
  "entityGroup": "nmon-sub-group",
  "entityExpression": "property_values('asset::function').isEmpty()",
  "metric": "cpu_busy"
}]
```

### Issue 3749

Fixed the SQL parser to allow [`LOCATE`](../../sql/README.md#string-functions) function to be used in the `WHERE` clause.

```sql
SELECT sum(value)
  FROM df.disk_used
WHERE datetime > now - 1 * minute
  AND LOCATE('/', tags.file_system) > 0
```

### Issue 3747

The [`CAST`](../../sql/README.md#cast) function now accepts output of the [`date_format`](../../sql/README.md#date_format) function as the argument, for example:

```sql
SELECT date_format(time, 'EEE HH') AS 'hour_in_day',
  avg(value)
FROM mpstat.cpu_busy
  WHERE datetime >= current_week
  AND CAST(date_format(time, 'H') AS number) >= 9 AND CAST(date_format(time, 'H') AS number) < 18
GROUP BY date_format(time, 'EEE HH')
  ORDER BY 2 DESC
```

### Issue 3746

Updated the `u` pattern to return a numeric value representing the [day number](https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html) within a week (1 = Monday, ..., 7 = Sunday).

```sql
SELECT date_format(time, 'E'),
  avg(value)
FROM mpstat.cpu_busy
  WHERE datetime >= previous_week
GROUP BY date_format(time, 'u')
  ORDER BY date_format(time, 'u')
```

### Issue 3741

Rows not merged as expected for tag names with the same names but different values by [`JOIN USING ENTITY`](../../sql/README.md#join-syntax). For example, the same tag `tag1` with different values `a` and `b`.

```ls
series d:2016-12-23T00:00:00.000Z e:e1 m:m3=1 t:tag1=a
series d:2016-12-23T00:00:00.000Z e:e1 m:m4=1 t:tag1=b
```

```sql
SELECT *
  FROM m3
  JOIN USING ENTITY m4
```

### Issue 3740

Fixed API processor to return the history of the `text` field for versioned metrics.

```ls
series e:e-vers-text d:2016-12-22T00:00:00Z x:vers-text-m=hello1
... wait, then insert again a different text value
series e:e-vers-text d:2016-12-22T00:00:00Z x:vers-text-m=hello2
```

```json
[{
  "startDate": "2016-12-20T00:00:00Z",
  "endDate":   "now",
  "entity": "*",
  "metric": "vers-text-m",
  "versioned": true
}]
```

```json
[
  {
    "entity": "e-vers-text",
    "metric": "vers-text-m",
    "data": [
      {
        "d": "2016-12-22T00:00:00.000Z",
        "v": "NaN",
        "x": "hello1",
        "version": {
          "d": "2016-12-22T14:00:37.743Z"
        }
      },
      {
        "d": "2016-12-22T00:00:00.000Z",
        "v": "NaN",
        "x": "hello2",
        "version": {
          "d": "2016-12-22T14:00:42.137Z"
        }
      }
    ]
  }
]
```

### Issue 3738

The `ABS()` function produces an error when an expression is submitted:

```sql
SELECT ABS(max(value)*avg(value))
  FROM mpstat.cpu_busy
WHERE datetime > previous_minute
```

### Issue 3721

Optimized `LIKE` operator to filter out series using the last insert table. The below query now provides similar performance such as for `tags.city = 'Philadelphia'`.

```sql
SELECT count(*)
  FROM dmv_incidents
WHERE entity = 'mr8w-325u'
  AND tags.city LIKE 'Philadelphia'
```

### Issue 3711

Upgraded lexer to resolve slow parsing of queries such as shown below:

```sql
SELECT value+value+value+value
  +value+value+value+value
  +value+value+value+value
  +value+value+value+value
  +value+value+value+value
  +value+value+value+value
  +value+value+value
FROM 'testmetric'
```

### Issue 3695

Fixed a defect with the `GROUP BY` and `JOIN` clauses to return results for the following queries:

```sql
SELECT sum(t1.value), sum(tot.value)
  FROM dmv_incidents tot
JOIN dmv_registrations t1
  WHERE tot.entity = 'mr8w-325u'
  AND tot.tags.city = 'New York'
GROUP BY tot.period(1 year)
```

### Issue 3661

The `CAST` function transforms a string into a number which can then be used in arithmetic expressions.

```sql
CAST(inputString AS Number)
```

```sql
SELECT datetime, value, entity, tags,
  value/CAST(LOOKUP('disk-size', concat(entity, ',', tags.file_system)) AS Number) AS 'pct_used'
FROM disk.stats.used
  WHERE datetime > current_hour
```

### Issue 3743

Released an initial version of the PI Server emulator, which returns results for queries against the virtual `picomp2` and `pipoint2` tables.
The emulator operates via the ATSD JDBC driver (not the PI JDBC driver).

```sql
SELECT *
FROM pipoint..pipoint2
```

### Issue 3754

Columns not created for series with a statistic and wildcard match: [ChartLab](https://apps.axibase.com/chartlab/506da7c3)

### Issue 3654

Added support for meta fields in label-format (and series tooltips) to ensure that that `meta.metric.tag` and `meta.entity.tag` can be replaced with metadata values, loaded from the server.

Meta-data examples are documented in the [Charts Documentation](https://github.com/axibase/charts/blob/master/configuration/meta-data.md).

[ChartLab](https://apps.axibase.com/chartlab/506da7c3)

### Issue 3636

Updated charts to display series if requested for an entity group or with an entity expression: [ChartLab](https://apps.axibase.com/chartlab/480bd642)

### Issue 3143

Fixed an issue which caused the value and time columns of series with shorter period to not be displayed: [ChartLab](https://apps.axibase.com/chartlab/adce7a9c)
