# Join Using Entity

The `USING ENTITY` clause modifies the default `JOIN` condition. It uses only the entity and timestamp columns to join rows from merged tables instead of the default entity, timestamp, and tags columns.

## Join without `USING ENTITY`

```sql
SELECT t1.entity, t1.datetime, AVG(t1.value), AVG(t2.value), t2.tags.*
  FROM "mpstat.cpu_busy" t1
JOIN "df.disk_used" t2
  WHERE t1.datetime > current_hour
  AND t1.entity = 'nurswgvml007'
GROUP BY t1.entity, t2.tags, t1.period(15 minute)
  ORDER BY t1.datetime
```

## Results

No records.

The query produced no records because no series among the joined series has the same tags.

## Join with `USING ENTITY`

```sql
SELECT t1.entity, t1.datetime, AVG(t1.value), AVG(t2.value), t2.tags.*
  FROM "mpstat.cpu_busy" t1
JOIN USING ENTITY "df.disk_used" t2
  WHERE t1.datetime > current_hour
  AND t1.entity = 'nurswgvml007'
GROUP BY t1.entity, t2.tags, t1.period(15 minute)
  ORDER BY t1.datetime
```

## Results

```ls
| entity       | datetime                 | AVG(cpu_busy.value) | AVG(disk_used.value) | disk_used.tags.mount_point | disk_used.tags.file_system          |
|--------------|--------------------------|--------------------:|---------------------:|----------------------------|-------------------------------------|
| nurswgvml007 | 2016-06-18T10:00:00.000Z | 39.7                | 1744011571.0         | /mnt/u113452               | //u113452.nurstr003/backup          |
| nurswgvml007 | 2016-06-18T10:00:00.000Z | 39.7                | 8699302.7            | /                          | /dev/mapper/vg_nurswgvml007-lv_root |
```

## OUTER JOIN without `USING ENTITY`

```sql
SELECT datetime, ISNULL(t1.entity, t2.entity) AS server,
  AVG(t1.value), AVG(t2.value), t2.tags.*
FROM "mpstat.cpu_busy" t1
  OUTER JOIN "df.disk_used" t2
WHERE t1.datetime >= '2017-05-30T09:00:00Z' AND t1.datetime < '2017-05-30T09:30:00Z'
  AND t1.entity = 'nurswgvml007'
GROUP BY PERIOD(15 minute), server, t2.tags
  ORDER BY datetime
```

## Results

```ls
| datetime             | server       | avg(t1.value) | avg(t2.value) | t2.tags.file_system                 | t2.tags.mount_point |
|----------------------|--------------|---------------|---------------|-------------------------------------|---------------------|
| 2017-05-30T09:00:00Z | nurswgvml007 | 5.3           | NaN           | null                                | null                |
| 2017-05-30T09:00:00Z | nurswgvml007 | NaN           | 8631972.5     | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-30T09:00:00Z | nurswgvml007 | NaN           | 1491273399.0  | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-30T09:15:00Z | nurswgvml007 | 7.4           | NaN           | null                                | null                |
| 2017-05-30T09:15:00Z | nurswgvml007 | NaN           | 8632354.9     | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-30T09:15:00Z | nurswgvml007 | NaN           | 1491273399.0  | //u113452.nurstr003/backup          | /mnt/u113452        |
```

## OUTER JOIN with `USING ENTITY`

```sql
SELECT datetime, ISNULL(t1.entity, t2.entity) AS server,
  AVG(t1.value), AVG(t2.value), t2.tags.*
FROM "mpstat.cpu_busy" t1
  OUTER JOIN USING ENTITY "df.disk_used" t2
WHERE t1.datetime >= '2017-05-30T09:00:00Z' AND t1.datetime < '2017-05-30T09:30:00Z'
  AND t1.entity = 'nurswgvml007'
GROUP BY PERIOD(15 minute), server, t2.tags
  --HAVING t2.tags IS NOT NULL -- optionally exclude rows where t2.tags are null
  ORDER BY datetime
```

## Results

```ls
| datetime             | server       | avg(t1.value) | avg(t2.value) | t2.tags.file_system                 | t2.tags.mount_point |
|----------------------|--------------|---------------|---------------|-------------------------------------|---------------------|
| 2017-05-30T09:00:00Z | nurswgvml007 | 5.4           | NaN           | null                                | null                |
| 2017-05-30T09:00:00Z | nurswgvml007 | 5.0           | 8631972.5     | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-30T09:00:00Z | nurswgvml007 | 5.0           | 1491273399.0  | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-30T09:15:00Z | nurswgvml007 | 7.4           | NaN           | null                                | null                |
| 2017-05-30T09:15:00Z | nurswgvml007 | 6.1           | 8632354.9     | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-30T09:15:00Z | nurswgvml007 | 6.1           | 1491273399.0  | //u113452.nurstr003/backup          | /mnt/u113452        |
```
