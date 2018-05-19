# Weekly Change Log: April 3 - April 9, 2017

## ATSD

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|---------------------------------------------------------------------|
| 4000 | sql | Bug | Standardize NaN and NULL processing in aggregation functions: [`min_value_time`](../../sql#aggregation-functions) and [`max_value_time`](../../sql#aggregation-functions). |
| [4057](#issue-4057) | sql | Feature | Add support for conditions containings multiple expressions in `CASE`. |
| [4083](#issue-4083) | sql | Feature | Allow `metric LIKE` condition in [`atsd_series`](../../sql#atsd_series-table) queries. |
| 4082 | sql | Bug | Fix issued with failing query cancellation requests. |
| 4081 | api-network | Bug | Fix processing of commands with multiline text containing lines starting with `time` keyword. |
| 4075 | sql | Bug | Optimize queries with [`metrics()`](../../sql#metrics) function by pushing down predicates into the subquery. |
| 4079 | sql | Bug | Metric/entity `timeZone` field should return time zone name instead of toString output. |
| 4067 | sql | Bug | [`SELECT 1`](../../sql#validation-query) query fails to return both header row and one data row. |
| 4074 | sql | Bug | Fix NullPointerException when ordering by NULL tag with [`ROW_MEMORY_THRESHOLD 0`](../../sql#row_memory_threshold-option) option |
| 4066 | log_aggregator | Bug | Eliminate duplicate log aggregator instances when logback configuration is reloaded.  |
| 4070 | sql | Bug | Optimize processing of `OR datetime` condition. |
| [4060](#issue-4060) | sql | Feature | Add support for [`LAG`](../../sql#lag) and [`LEAD`](../../sql#lead) functions in the `BETWEEN` operator. |
| 4058 | sql | Bug | Fix NullPointerException in partitioned [`OUTER JOIN`](../../sql#outer-join) queries with externally sorted results. |
| 4047 | sql | Bug | Fix error raised when using `IN` operator in `WHERE` condition containing [`LAG`](../../sql#lag) and [`LEAD`](../../sql#lead) functions. |

## Collector

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 4090 | jdbc | Bug | Don't log error if `InterpolateType` value is `NULL`. |
| 4078 | core | Bug | Fix parsing `series` commands with '=' symbol in the text field.  |
| 4061 | file | Bug | Save error messages if FTP connection fails. |

### Issue 4057

```sql
SELECT entity, datetime, value,
CASE entity
  WHEN 'nurswgvml006' OR 'nurswgvml007' THEN '00'
  ELSE 'Unknown'
END AS 'ent'
FROM cpu_busy
WHERE datetime >= previous_minute
```

### Issue 4083

```sql
SELECT entity, metric, datetime, value
  FROM atsd_series
WHERE metric LIKE 'cpu_*'
  AND datetime >= CURRENT_HOUR
ORDER BY datetime
```

### Issue 4060

```sql
SELECT datetime, LAG(value), value, LEAD(value)
  FROM cpu_busy
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN '2017-04-02T14:19:15Z' AND '2017-04-02T14:21:15Z'
  AND value BETWEEN LAG(value) AND LEAD(value)
```
