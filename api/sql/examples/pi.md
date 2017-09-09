# PI Query Examples

## New `atsd_series` syntax options

### `WHERE metric LIKE` condition

```sql
SELECT datetime, metric, value
  FROM atsd_series
WHERE metric LIKE 'tv6.pack%'
  AND datetime BETWEEN '2016-10-04T00:00:00Z' AND '2016-10-05T00:00:00Z'
  AND entity = 'br-1211'
ORDER BY metric, datetime
```

```ls
| datetime             | metric       | value |
|----------------------|--------------|-------|
| 2016-10-04T01:58:12Z | tv6.pack:r01 | 90.4  |
| 2016-10-04T02:00:05Z | tv6.pack:r01 | 97.7  |
| 2016-10-04T02:00:35Z | tv6.pack:r01 | 77.1  |
| 2016-10-04T02:02:28Z | tv6.pack:r01 | 84.2  |
| 2016-10-04T02:04:15Z | tv6.pack:r01 | 65.2  |
| 2016-10-04T02:05:28Z | tv6.pack:r01 | 50.3  |
| 2016-10-04T02:07:42Z | tv6.pack:r01 | 60.1  |
| 2016-10-04T02:08:28Z | tv6.pack:r01 | 80.3  |
| 2016-10-04T02:09:16Z | tv6.pack:r01 | 87.1  |
| 2016-10-04T02:11:11Z | tv6.pack:r01 | 99.9  |
| 2016-10-04T02:00:14Z | tv6.pack:r03 | 47.7  |
| 2016-10-04T02:00:55Z | tv6.pack:r03 | 37.1  |
| 2016-10-04T02:02:18Z | tv6.pack:r03 | 44.2  |
| 2016-10-04T02:04:25Z | tv6.pack:r03 | 35.2  |
| 2016-10-04T02:05:18Z | tv6.pack:r03 | 40.3  |
| 2016-10-04T02:07:22Z | tv6.pack:r03 | 42.1  |
| 2016-10-04T02:08:28Z | tv6.pack:r03 | 46.3  |
| 2016-10-04T02:09:26Z | tv6.pack:r03 | 27.1  |
| 2016-10-04T02:10:11Z | tv6.pack:r03 | 49.9  |
| 2016-10-04T01:59:12Z | tv6.pack:r04 | 20.0  |
| 2016-10-04T02:00:14Z | tv6.pack:r04 | 27.7  |
| 2016-10-04T02:01:55Z | tv6.pack:r04 | 17.1  |
| 2016-10-04T02:02:38Z | tv6.pack:r04 | 24.2  |
| 2016-10-04T02:04:45Z | tv6.pack:r04 | 25.2  |
| 2016-10-04T02:05:08Z | tv6.pack:r04 | 20.3  |
| 2016-10-04T02:07:52Z | tv6.pack:r04 | 22.1  |
| 2016-10-04T02:08:18Z | tv6.pack:r04 | 26.3  |
| 2016-10-04T02:09:46Z | tv6.pack:r04 | 17.1  |
| 2016-10-04T02:10:21Z | tv6.pack:r04 | 19.9  |
```

### `WHERE metric IN metrics(entityName)` condition

```sql
SELECT datetime, metric, value
  FROM atsd_series
WHERE metric IN metrics('br-1211')
  AND datetime BETWEEN '2016-10-04T00:00:00Z' AND '2016-10-05T00:00:00Z'
  AND entity = 'br-1211'
WITH INTERPOLATE(5 MINUTE)
  ORDER BY metric, datetime
```

```ls
| datetime             | metric       | value |
|----------------------|--------------|-------|
| 2016-10-04T02:00:00Z | tv6.pack:r01 | 97.4  |
| 2016-10-04T02:05:00Z | tv6.pack:r01 | 56.0  |
| 2016-10-04T02:10:00Z | tv6.pack:r01 | 92.0  |
| 2016-10-04T02:05:00Z | tv6.pack:r03 | 38.6  |
| 2016-10-04T02:10:00Z | tv6.pack:r03 | 44.3  |
| 2016-10-04T02:00:00Z | tv6.pack:r04 | 26.0  |
| 2016-10-04T02:05:00Z | tv6.pack:r04 | 22.0  |
| 2016-10-04T02:10:00Z | tv6.pack:r04 | 18.2  |
```

### JOINs

```sql
SELECT t1.entity, t1.metric, t1.datetime,
  t1.value,
  t2.text AS "Elapsed Time",
  t3.text AS "Unit Batch Id",
  t4.text AS "Unit Procedure"
FROM atsd_series t1
  JOIN "TV6.Elapsed_Time" t2
  JOIN "TV6.Unit_BatchID" t3
  JOIN "TV6.Unit_Procedure" t4
WHERE t1.metric LIKE 'tv6.pack%'
  AND t1.datetime BETWEEN '2016-10-04T00:00:00Z' AND '2016-10-05T00:00:00Z'
  AND t1.entity = 'br-1211'
WITH INTERPOLATE(1 MINUTE, LINEAR, INNER, NONE, START_TIME)
  ORDER BY t1.metric, t1.datetime
```

```ls
| t1.entity | t1.metric    | t1.datetime          | t1.value | Elapsed Time | Unit Batch Id | Unit Procedure |
|-----------|--------------|----------------------|----------|--------------|---------------|----------------|
| br-1211   | tv6.pack:r01 | 2016-10-04T02:00:00Z | 97.4     | 475.0        | 700           | Proc3          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:01:00Z | 78.7     | 26.0         | Inactive      | Inactive       |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:02:00Z | 82.4     | 35.0         | 800           | Proc2          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:03:00Z | 78.5     | 95.0         | 800           | Proc3          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:04:00Z | 67.9     | 155.0        | 800           | Proc1          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:05:00Z | 56.0     | 215.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:06:00Z | 52.6     | 275.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:07:00Z | 57.0     | 335.0        | 800           | Proc3          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:08:00Z | 68.0     | 395.0        | Inactive      | Inactive       |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:09:00Z | 84.8     | 455.0        | Inactive      | Inactive       |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:10:00Z | 92.0     | 51.0         | 900           | Proc1          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:01:00Z | 37.5     | 26.0         | Inactive      | Inactive       |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:02:00Z | 42.7     | 35.0         | 800           | Proc2          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:03:00Z | 41.2     | 95.0         | 800           | Proc3          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:04:00Z | 37.0     | 155.0        | 800           | Proc1          |
...
```

## New LAG and LEAD functions

* LAG function

```sql
SELECT datetime, text, LAG(text)
  FROM "TV6.Unit_BatchID"
WHERE entity = 'br-1211' AND (text = '800' OR LAG(text) = '800')
```

```ls
| datetime             | text     | lag(text) |
|----------------------|----------|-----------|
| 2016-10-04T02:01:20Z | 800      | null      |
| 2016-10-04T02:03:05Z | Inactive | 800       |
| 2016-10-04T02:03:10Z | 800      | Inactive  |
| 2016-10-04T02:07:05Z | Inactive | 800       |
```

* LEAD function [examples](../../README.md#lag)


## BETWEEN clause supports subqueries

* The `BETWEEN` clause (Interval condition) accepts subqueries

```sql
SELECT t1.entity, t1.metric, t1.datetime,
  t1.value,
  t2.text AS "Elapsed Time",
  t3.text AS "Unit Batch Id",
  t4.text AS "Unit Procedure"
FROM atsd_series t1
  JOIN "TV6.Elapsed_Time" t2
  JOIN "TV6.Unit_BatchID" t3
  JOIN "TV6.Unit_Procedure" t4
WHERE t1.metric LIKE 'tv6.pack%'
  -- subquery in the datatime condition
  AND t1.datetime BETWEEN (
    SELECT datetime FROM "TV6.Unit_BatchID"
    WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800')
  )
  AND t1.entity = 'br-1211'
WITH INTERPOLATE(1 MINUTE, LINEAR, OUTER, EXTEND, START_TIME)
  ORDER BY t1.metric, t1.datetime
```

```ls
| t1.entity | t1.metric    | t1.datetime          | t1.value | Elapsed Time | Unit Batch Id | Unit Procedure |
|-----------|--------------|----------------------|----------|--------------|---------------|----------------|
| br-1211   | tv6.pack:r01 | 2016-10-04T02:01:20Z | 79.9     | 26.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:02:20Z | 83.7     | 35.0         | 800           | Proc3          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:03:10Z | 76.7     | 95.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:04:10Z | 66.1     | 155.0        | 800           | Proc1          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:05:10Z | 54.0     | 215.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:06:10Z | 53.4     | 275.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:01:20Z | 39.2     | 26.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:02:20Z | 44.1     | 35.0         | 800           | Proc3          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:03:10Z | 40.5     | 95.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:04:10Z | 36.3     | 155.0        | 800           | Proc1          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:05:10Z | 39.5     | 215.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:06:10Z | 41.1     | 275.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:01:20Z | 20.8     | 26.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:02:20Z | 21.2     | 35.0         | 800           | Proc3          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:03:10Z | 24.5     | 95.0         | 800           | Proc1          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:04:10Z | 24.9     | 155.0        | 800           | Proc1          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:05:10Z | 20.3     | 215.0        | 800           | Proc2          |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:06:10Z | 21.0     | 275.0        | 800           | Proc2          |
```

## New `interval_number()` function

* The `interval_number()` function enumerates consecutive intervals in the SELECT statement.

```sql
SELECT t1.entity, t1.metric, t1.datetime,
  t1.value,
  t2.text AS "Elapsed Time",
  t3.text AS "Unit Batch Id",
  t4.text AS "Unit Procedure",
CASE interval_number()
  WHEN 0 THEN t3.text
  ELSE CONCAT(t3.text, '.', interval_number())
END AS "Unit Batch.#"
FROM atsd_series t1
  JOIN "TV6.Elapsed_Time" t2
  JOIN "TV6.Unit_BatchID" t3
  JOIN "TV6.Unit_Procedure" t4
WHERE t1.metric LIKE 'tv6.pack%'
  AND t1.datetime BETWEEN (
      SELECT datetime FROM "TV6.Unit_BatchID"
      WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800')
  )
  AND t1.entity = 'br-1211'
WITH INTERPOLATE(1 MINUTE, LINEAR, OUTER, EXTEND, START_TIME)
  ORDER BY t1.metric, t1.datetime
```

```ls
| t1.entity | t1.metric    | t1.datetime          | t1.value | Elapsed Time | Unit Batch Id | Unit Procedure | Unit Batch.# |
|-----------|--------------|----------------------|----------|--------------|---------------|----------------|--------------|
| br-1211   | tv6.pack:r01 | 2016-10-04T02:01:20Z | 79.9     | 26.0         | 800           | Proc1          | 800.1        |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:02:20Z | 83.7     | 35.0         | 800           | Proc3          | 800.1        |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:03:10Z | 76.7     | 95.0         | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:04:10Z | 66.1     | 155.0        | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:05:10Z | 54.0     | 215.0        | 800           | Proc2          | 800.2        |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:06:10Z | 53.4     | 275.0        | 800           | Proc2          | 800.2        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:01:20Z | 39.2     | 26.0         | 800           | Proc1          | 800.1        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:02:20Z | 44.1     | 35.0         | 800           | Proc3          | 800.1        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:03:10Z | 40.5     | 95.0         | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:04:10Z | 36.3     | 155.0        | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:05:10Z | 39.5     | 215.0        | 800           | Proc2          | 800.2        |
| br-1211   | tv6.pack:r03 | 2016-10-04T02:06:10Z | 41.1     | 275.0        | 800           | Proc2          | 800.2        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:01:20Z | 20.8     | 26.0         | 800           | Proc1          | 800.1        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:02:20Z | 21.2     | 35.0         | 800           | Proc3          | 800.1        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:03:10Z | 24.5     | 95.0         | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:04:10Z | 24.9     | 155.0        | 800           | Proc1          | 800.2        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:05:10Z | 20.3     | 215.0        | 800           | Proc2          | 800.2        |
| br-1211   | tv6.pack:r04 | 2016-10-04T02:06:10Z | 21.0     | 275.0        | 800           | Proc2          | 800.2        |
```

## User-defined timezones in PERIOD

* The PERIOD aggregation supports user-defined timezones.

```sql
SELECT datetime, date_format(time, 'yyyy-MM-dd HH:mm:ss z', "US/Eastern") AS "Local Date",
  max(value), min(value)
  FROM atsd_series
WHERE metric LIKE 'tv6.p%'
  AND datetime BETWEEN '2016-10-03T00:00:00Z' AND '2016-10-05T00:00:00Z'
  AND entity = 'br-1211'
  GROUP BY PERIOD(1 DAY, "US/Eastern")
```

```ls
| datetime             | Local Date              | max(value) | min(value) |
|----------------------|-------------------------|------------|------------|
| 2016-10-03T04:00:00Z | 2016-10-03 00:00:00 EDT | 99.9       | 17.1       |
```

## GROUP BY text

```sql
SELECT t1.metric,
  t4.text AS "Unit Procedure",
  min(t1.value), avg(t1.value), max(t1.value)
FROM atsd_series t1
  JOIN "TV6.Elapsed_Time" t2
  JOIN "TV6.Unit_BatchID" t3
  JOIN "TV6.Unit_Procedure" t4
WHERE t1.metric LIKE 'tv6.pack%'
  AND t1.datetime BETWEEN (
    SELECT datetime FROM "TV6.Unit_BatchID"
    WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800')
  )
  AND t1.entity = 'br-1211'
WITH INTERPOLATE(1 MINUTE, LINEAR, OUTER, EXTEND, START_TIME)
  GROUP BY t1.metric, t4.text
ORDER BY t1.metric, t4.text
```

```ls
| t1.metric    | Unit Procedure | min(t1.value) | avg(t1.value) | max(t1.value) |
|--------------|----------------|---------------|---------------|---------------|
| tv6.pack:r01 | Proc1          | 66.1          | 74.3          | 79.9          |
| tv6.pack:r01 | Proc2          | 53.4          | 53.7          | 54.0          |
| tv6.pack:r01 | Proc3          | 83.7          | 83.7          | 83.7          |
| tv6.pack:r03 | Proc1          | 36.3          | 38.7          | 40.5          |
| tv6.pack:r03 | Proc2          | 39.5          | 40.3          | 41.1          |
| tv6.pack:r03 | Proc3          | 44.1          | 44.1          | 44.1          |
| tv6.pack:r04 | Proc1          | 20.8          | 23.4          | 24.9          |
| tv6.pack:r04 | Proc2          | 20.3          | 20.7          | 21.0          |
| tv6.pack:r04 | Proc3          | 21.2          | 21.2          | 21.2          |
```
