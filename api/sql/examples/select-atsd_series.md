# Select FROM `atsd_series` Table

Querying the built-in `atsd_series` table allows specifying metric name in the `WHERE` clause instead of the `FROM` query.

At least one metric condition must be present in a `WHERE` clause of a valid `atsd_series` query. Metric names are case-insensitive.

The following queries are equivalent:

```sql
SELECT entity, metric, datetime, value
  FROM atsd_series
WHERE metric = 'mpstat.cpu_busy'
  AND datetime > current_hour
```

```sql
SELECT entity, metric, datetime, value
  FROM 'mpstat.cpu_busy'
WHERE datetime > current_hour
```

### Results

```ls
| entity       | metric   | datetime                 | value |
|--------------|----------|--------------------------|-------|
| nurswgvml007 | cpu_busy | 2016-08-08T15:26:14.000Z | 7.0   |
| nurswgvml007 | cpu_busy | 2016-08-08T15:26:30.000Z | 4.0   |
| nurswgvml007 | cpu_busy | 2016-08-08T15:26:46.000Z | 3.1   |
```

## Query Multiple Metrics

Unlike `FROM {metric}` syntax, `FROM atsd_series` allows querying multiple metrics similar to the `UNION ALL` operator.

```sql
SELECT entity, metric, datetime, value, tags
  FROM atsd_series
WHERE metric IN ('mpstat.cpu_busy', 'mpstat.cpu_user')
  AND entity = 'nurswgvml007'
  AND datetime > now - 2 * MINUTE
```

### Results

```ls
| entity       | metric   | datetime                 | value | tags |
|--------------|----------|--------------------------|-------|------|
| nurswgvml007 | cpu_busy | 2016-08-08T15:54:47.000Z | 6.1   | null |
| nurswgvml007 | cpu_busy | 2016-08-08T15:55:03.000Z | 11.9  | null |
| nurswgvml007 | cpu_user | 2016-08-08T15:54:47.000Z | 5.0   | null |
| nurswgvml007 | cpu_user | 2016-08-08T15:55:03.000Z | 5.9   | null |
```


By default results are ordered by metric. The default sort can be modified with the `ORDER BY` clause.

```sql
SELECT entity, metric, datetime, value, tags
  FROM atsd_series
WHERE metric IN ('mpstat.cpu_busy', 'mpstat.cpu_user')
  AND entity = 'nurswgvml007'
  AND datetime > now - 2 * MINUTE
ORDER BY datetime
```

### Results

```ls
| entity       | metric   | datetime                 | value | tags |
|--------------|----------|--------------------------|-------|------|
| nurswgvml007 | cpu_busy | 2016-08-08T15:54:47.000Z | 6.1   | null |
| nurswgvml007 | cpu_user | 2016-08-08T15:54:47.000Z | 5.0   | null |
| nurswgvml007 | cpu_busy | 2016-08-08T15:55:03.000Z | 11.9  | null |
| nurswgvml007 | cpu_user | 2016-08-08T15:55:03.000Z | 5.9   | null |
```

## Metric Condition

Metrics can be selected in the `WHERE` clause using the `=` and `LIKE` operators.

Both `AND` and `OR` boolean operators are supported when processing conditions in multiple-metric queries.

```sql
SELECT entity, metric, datetime, value, tags
  FROM atsd_series
WHERE (metric = 'df.disk_used' OR metric = 'df.disk_used_percent')
  AND entity = 'nurswgvml007'
  AND datetime > now - 2 * MINUTE
ORDER BY datetime
```

### Results

```ls
| entity       | metric            | datetime             | value      | tags                                                          |
|--------------|-------------------|----------------------|------------|---------------------------------------------------------------|
| nurswgvml007 | disk_used         | 2017-04-06T16:31:36Z | 9010776    | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/ |
| nurswgvml007 | disk_used         | 2017-04-06T16:31:36Z | 1848808233 | file_system=//nurstr/backup;mount_point=/mnt/u113452          |
| nurswgvml007 | disk_used_percent | 2017-04-06T16:31:36Z | 68.612     | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/ |
| nurswgvml007 | disk_used_percent | 2017-04-06T16:31:36Z | 88.158     | file_system=//nurstr/backup;mount_point=/mnt/u113452          |
| nurswgvml007 | disk_used         | 2017-04-06T16:31:51Z | 9011816    | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/ |
| nurswgvml007 | disk_used         | 2017-04-06T16:31:51Z | 1848808233 | file_system=//nurstr;mount_point=/mnt/u113452                 |
```

## Metric LIKE Condition

The maximum number of metrics matched with the `LIKE` operator is limited to 50. Otherwise, the SQL processor will raise an exception.

```sql
SELECT entity, metric, datetime, value, tags
  FROM atsd_series
WHERE metric LIKE 'cpu_s*' -- up to 50 metrics
  AND datetime >= CURRENT_HOUR
WITH ROW_NUMBER (entity, metric, tags ORDER BY time DESC) <= 1
  ORDER BY entity, metric, tags, time
```

### Results

```ls
| entity       | metric     | datetime             | value | tags |
|--------------|------------|----------------------|-------|------|
| nurswgvml006 | cpu_steal  | 2017-04-07T13:15:01Z | 0.0   | null |
| nurswgvml006 | cpu_system | 2017-04-07T13:15:01Z | 2.0   | null |
| nurswgvml007 | cpu_steal  | 2017-04-07T13:15:00Z | 0.0   | null |
| nurswgvml007 | cpu_system | 2017-04-07T13:15:00Z | 0.0   | null |
| nurswgvml010 | cpu_steal  | 2017-04-07T13:14:51Z | 0.0   | null |
| nurswgvml010 | cpu_system | 2017-04-07T13:14:51Z | 0.0   | null |
| nurswgvml301 | cpu_steal  | 2017-04-07T13:14:58Z | 0.0   | null |
| nurswgvml301 | cpu_system | 2017-04-07T13:14:58Z | 0.0   | null |
| nurswgvml502 | cpu_steal  | 2017-04-07T13:14:49Z | 0.0   | null |
| nurswgvml502 | cpu_system | 2017-04-07T13:14:49Z | 0.0   | null |
```

## `metrics()` Function

The `metrics()` function retrieves all metrics collected by the specified entity.

```sql
SELECT metric, datetime, value
  FROM atsd_series
WHERE metric IN metrics('nurswgvml007')
  AND metric LIKE 'mpstat.cpu*'
  -- AND metric NOT LIKE 'df.*'
  AND datetime >= CURRENT_HOUR
ORDER BY datetime
  LIMIT 10
```

### Results

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

## `JOIN` in `atsd_series`. Example 1

When metrics selected from `atsd_series` table are joined with metrics referenced in the query, each `atsd_series` metric is joined with a referenced metric separately.

```sql
SELECT base.entity, base.metric, base.datetime, base.value, t1.value AS 'cpu_sys'
  FROM atsd_series base
  JOIN mpstat.cpu_system t1
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
| nurswgvml007 | cpu_busy    | 2017-04-07T15:04:40Z | 4.0        | 1.0     | cpu_busy JOIN cpu_system
| nurswgvml007 | cpu_busy    | 2017-04-07T15:04:56Z | 3.0        | 1.0     | cpu_busy JOIN cpu_system
| nurswgvml007 | cpu_busy    | 2017-04-07T15:05:12Z | 5.2        | 1.0     | cpu_busy JOIN cpu_system
| nurswgvml007 | cpu_busy    | 2017-04-07T15:05:28Z | 2.0        | 1.0     | cpu_busy JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:08Z | 2.0        | 2.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:24Z | 3.1        | 2.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:40Z | 3.0        | 1.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:04:56Z | 2.0        | 1.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:05:12Z | 4.1        | 1.0     | cpu_user JOIN cpu_system
| nurswgvml007 | cpu_user    | 2017-04-07T15:05:28Z | 1.0        | 1.0     | cpu_user JOIN cpu_system
```

## `JOIN` in `atsd_series`. Example 2

```sql
SELECT t1.entity, t1.metric, t1.datetime,
  t1.value, t4.value AS 'Elapsed Time', t5.text AS 'Unit Batch Id', t6.text AS 'Unit Procedure'
  FROM atsd_series t1
    JOIN 'SV6.Elapsed_Time' t4
    JOIN 'SV6.Unit_BatchID' t5
    JOIN 'SV6.Unit_Procedure' t6
WHERE t1.metric IN metrics('br-1470')
  AND t1.metric NOT LIKE 'sv7*'
  AND t1.datetime BETWEEN '2016-10-04T02:00:00Z' AND '2016-10-04T02:10:00Z'
  AND t1.entity = 'br-1470'
WITH INTERPOLATE(180 second, AUTO, OUTER, EXTEND, START_TIME)
  ORDER BY t1.metric, t1.datetime
```

### Results

```ls
| t1.entity | t1.metric    | t1.datetime          | t1.value | Elapsed Time | Unit Batch Id | Unit Procedure |
|-----------|--------------|----------------------|----------|--------------|---------------|----------------|
| br-1470   | sv6.pack:r01 | 2016-10-04T02:00:00Z | 97.4     | 475.0        | 1413          | 1413-Proc3     |
| br-1470   | sv6.pack:r01 | 2016-10-04T02:03:00Z | 78.5     | 95.0         | 1414          | 1414-Proc1     |
| br-1470   | sv6.pack:r01 | 2016-10-04T02:06:00Z | 52.6     | 275.0        | 1414          | 1414-Proc2     |
| br-1470   | sv6.pack:r01 | 2016-10-04T02:09:00Z | 84.8     | 455.0        | 1414          | 1414-Proc3     |
| br-1470   | sv6.pack:r03 | 2016-10-04T02:00:00Z | 47.7     | 475.0        | 1413          | 1413-Proc3     |
| br-1470   | sv6.pack:r03 | 2016-10-04T02:03:00Z | 41.2     | 95.0         | 1414          | 1414-Proc1     |
| br-1470   | sv6.pack:r03 | 2016-10-04T02:06:00Z | 40.9     | 275.0        | 1414          | 1414-Proc2     |
| br-1470   | sv6.pack:r03 | 2016-10-04T02:09:00Z | 35.7     | 455.0        | 1414          | 1414-Proc3     |
| br-1470   | sv6.pack:r04 | 2016-10-04T02:00:00Z | 26.0     | 475.0        | 1413          | 1413-Proc3     |
| br-1470   | sv6.pack:r04 | 2016-10-04T02:03:00Z | 24.4     | 95.0         | 1414          | 1414-Proc1     |
| br-1470   | sv6.pack:r04 | 2016-10-04T02:06:00Z | 20.9     | 275.0        | 1414          | 1414-Proc2     |
| br-1470   | sv6.pack:r04 | 2016-10-04T02:09:00Z | 21.9     | 455.0        | 1414          | 1414-Proc3     |
```

## Limitations

* The metric condition supports only `=`, `IN` and `LIKE` operators, as well as the `metrics(entity)` function.
* The number of metrics retrieved with `metric LIKE '*expr*'` condition must not exceed 50.

## Numeric Precedence

If the `value` column in `atsd_series` query returns numbers for metrics with different [data types](../../../api/meta/metric/list.md#data-types), the prevailing data type is determined based on the following rules:

1. If all data types are integer (`short`, `integer`, `long`), return the prevailing **integer** type.
2. If all data types are decimal (`float`, `double`, `decimal`), return the prevailing **decimal** type.
3. If data types are both integer and decimal, return **decimal** type.
