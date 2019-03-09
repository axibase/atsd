# Aggregate - Max Value Time

The time when the metric value reached its maximum over the last hour.

## Query

```sql
SELECT entity, MAX(value), date_format(MAX_VALUE_TIME(value), 'yyyy-MM-dd HH:mm:ss') AS "Max Time"
  FROM "mpstat.cpu_busy"
WHERE datetime > current_hour
  GROUP BY entity
```

## Results

```ls
| entity       | MAX(value) | Max Time            |
|--------------|------------|---------------------|
| awsswgvml001 | 100.0      | 2018-10-28 14:03:09 |
| nurswgvml003 | 15.84      | 2018-10-28 14:01:45 |
| nurswgvml006 | 100.0      | 2018-10-28 14:00:51 |
| nurswgvml007 | 100.0      | 2018-10-28 14:03:06 |
| nurswgvml010 | 88.49      | 2018-10-28 14:10:00 |
| nurswgvml011 | 11.11      | 2018-10-28 14:05:01 |
| nurswgvml102 | 41.0       | 2018-10-28 14:04:53 |
```
