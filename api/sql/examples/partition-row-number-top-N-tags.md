# Partition

## Query using `ROW_NUMBER` partitioning with `ORDER BY` average

Retrieve top-3 15-minute periods with maximum average disk usage, for each disk matching '/dev*' pattern.

```sql
SELECT entity, tags.*, datetime, avg(value)
  FROM "df.disk_used"
WHERE datetime BETWEEN '2017-05-30T00:00:00Z' AND '2017-05-31T00:00:00Z'
  AND tags.file_system LIKE '/dev/%'
  AND entity LIKE '%00%'
GROUP BY entity, tags, period(15 minute)
  WITH row_number(entity, tags ORDER BY avg(value) DESC) <= 3
```

## Results

```ls
| entity       | tags.file_system                    | tags.mount_point | datetime             | avg(value) |
|--------------|-------------------------------------|------------------|----------------------|------------|
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                | 2017-05-30T22:45:00Z | 8655026.5  |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                | 2017-05-30T23:45:00Z | 8654091.1  |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                | 2017-05-30T21:45:00Z | 8651712.4  |
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | /                | 2017-05-30T23:30:00Z | 6646798.4  |
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | /                | 2017-05-30T23:45:00Z | 6646737.4  |
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | /                | 2017-05-30T23:15:00Z | 6646709.7  |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive | 2017-05-30T01:15:00Z | 63184084.9 |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive | 2017-05-30T01:30:00Z | 62713797.9 |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive | 2017-05-30T01:45:00Z | 61794611.6 |
```

## Query using `ROW_NUMBER` partitioning and display row number

```sql
SELECT entity, datetime, avg(value), row_number()
  FROM "mpstat.cpu_busy"
WHERE datetime BETWEEN '2017-05-30T00:00:00Z' AND '2017-05-31T00:00:00Z'
  AND entity LIKE '%00%'
GROUP BY entity, period(15 minute)
  WITH row_number(entity ORDER BY avg(value) DESC) <= 3
ORDER BY entity, datetime
```

## Results

```ls
| entity       | datetime             | avg(value) | row_number() |
|--------------|----------------------|------------|--------------|
| nurswgvml006 | 2017-05-30T01:00:00Z | 100.0      | 1            |
| nurswgvml006 | 2017-05-30T01:15:00Z | 100.0      | 2            |
| nurswgvml006 | 2017-05-30T01:30:00Z | 94.7       | 3            |
| nurswgvml007 | 2017-05-30T15:00:00Z | 13.6       | 3            |
| nurswgvml007 | 2017-05-30T16:30:00Z | 77.5       | 1            |
| nurswgvml007 | 2017-05-30T16:45:00Z | 28.1       | 2            |
```
