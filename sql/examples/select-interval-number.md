# INTERVAL_NUMBER Function

The `INTERVAL_NUMBER` function can be referenced only in the `SELECT` expression.

## Query

```sql
SELECT t1.entity, t1.metric, t1.datetime,
  t1.value, t5.text AS "Unit Batch Id", t6.text AS "Unit Procedure",
CASE INTERVAL_NUMBER()
  WHEN 1 THEN t5.text
  ELSE CONCAT(t5.text, '.', INTERVAL_NUMBER())
END AS "Unit Batch Number"
  FROM atsd_series t1
    JOIN "TV6.Unit_BatchID" t5
    JOIN "TV6.Unit_Procedure" t6
WHERE t1.metric = 'tv6.pack:r01'
  AND t1.datetime BETWEEN (
    SELECT datetime FROM "TV6.Unit_BatchID" WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800')
  )
  AND t1.entity = 'br-1211'
WITH INTERPOLATE(60 SECOND, AUTO, OUTER, TRUE, START_TIME)
  ORDER BY t1.datetime
```

## Results

```ls
| t1.entity | t1.metric    | t1.datetime          | t1.value | Unit Batch Id | Unit Procedure | Unit Batch Number |
|-----------|--------------|----------------------|----------|---------------|----------------|-------------------|
| br-1211   | tv6.pack:r01 | 2016-10-04T02:01:20Z | 79.9     | 800           | Proc1          | 800               |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:02:20Z | 83.7     | 800           | Proc3          | 800               |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:03:20Z | 75.0     | 800           | Proc1          | 800.1             |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:04:20Z | 64.2     | 800           | Proc1          | 800.1             |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:05:20Z | 51.9     | 800           | Proc2          | 800.1             |
| br-1211   | tv6.pack:r01 | 2016-10-04T02:06:20Z | 54.1     | 800           | Proc3          | 800.1             |
```

### Intervals Returned By Subquery

The subquery returns two intervals.

```sql
SELECT datetime, text
  FROM "TV6.Unit_BatchID"
WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800')
```

```ls
| datetime             | text     |
|----------------------|----------|
| 2016-10-04T02:01:20Z | 800      |
| 2016-10-04T02:03:05Z | Inactive |
| 2016-10-04T02:03:10Z | 800      |
| 2016-10-04T02:07:05Z | Inactive |
```
