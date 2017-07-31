# Outer Join

Outer Join missing column values filled with `NULL`.

## Query

```sql
SELECT *
  FROM mpstat.cpu_busy t1
FULL OUTER JOIN df.disk_used t2
  WHERE t1.datetime > current_hour
  AND df.disk_used.entity = 'nurswgvml007'
```

## Results

```ls
| t1.entity    | t1.datetime          | t1.value | t2.entity    | t2.datetime          | t2.value     | t2.tags.file_system                 | t2.tags.mount_point |
|--------------|----------------------|----------|--------------|----------------------|--------------|-------------------------------------|---------------------|
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:01Z | 8651324.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:01Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| nurswgvml007 | 2017-05-31T06:00:16Z | 2.1      | null         | null                 | null         | null                                | null                |
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:16Z | 8652464.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:16Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:31Z | 8653000.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:31Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
```

## Query with Row `datetime` Column

```sql
SELECT datetime, COALESCE(t1.entity, t2.entity) AS server, t1.*, t2.*
  FROM mpstat.cpu_busy t1
FULL OUTER JOIN df.disk_used t2
  WHERE t1.datetime > current_hour
  AND df.disk_used.entity = 'nurswgvml007'
```

## Results

```ls
| datetime             | server       | t1.entity    | t1.datetime          | t1.value | t2.entity    | t2.datetime          | t2.value     | t2.tags.file_system                 | t2.tags.mount_point |
|----------------------|--------------|--------------|----------------------|----------|--------------|----------------------|--------------|-------------------------------------|---------------------|
| 2017-05-31T06:00:01Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:01Z | 8651324.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:01Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:01Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-31T06:00:16Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:16Z | 2.1      | null         | null                 | null         | null                                | null                |
| 2017-05-31T06:00:16Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:16Z | 8652464.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:16Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:16Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-31T06:00:31Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:31Z | 8653000.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:31Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:31Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
```

## Query with Interpolate

```sql
SELECT datetime, COALESCE(t1.entity, t2.entity) AS server, t1.*, t2.*
  FROM mpstat.cpu_busy t1
FULL OUTER JOIN df.disk_used t2
  WHERE t1.datetime >= '2017-05-31T06:00:00Z' AND t1.datetime < '2017-05-31T06:00:30Z'
  AND t2.entity = 'nurswgvml007'
  WITH INTERPOLATE(15 second, LINEAR, OUTER)
```

## Results

```ls
| datetime             | server       | t1.entity    | t1.datetime          | t1.value | t2.entity    | t2.datetime          | t2.value     | t2.tags.file_system                 | t2.tags.mount_point |
|----------------------|--------------|--------------|----------------------|----------|--------------|----------------------|--------------|-------------------------------------|---------------------|
| 2017-05-31T06:00:00Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:00Z | 51.1     | null         | null                 | null         | null                                | null                |
| 2017-05-31T06:00:00Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:00Z | 8651262.9    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:00Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:00Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-31T06:00:15Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:15Z | 5.1      | null         | null                 | null         | null                                | null                |
| 2017-05-31T06:00:15Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:15Z | 8652388.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:15Z | nurswgvml007 | null         | null                 | null     | nurswgvml007 | 2017-05-31T06:00:15Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
```

## Query with Interpolate ignoring Tags

```sql
SELECT datetime, COALESCE(t1.entity, t2.entity) AS server, t1.*, t2.*
  FROM mpstat.cpu_busy t1
FULL OUTER JOIN USING ENTITY df.disk_used t2
  WHERE t1.datetime >= '2017-05-31T06:00:00Z' AND t1.datetime < '2017-05-31T06:00:30Z'
  AND t2.entity = 'nurswgvml007'
  WITH INTERPOLATE(15 second, LINEAR, OUTER)
```

## Results

```ls
| datetime             | server       | t1.entity    | t1.datetime          | t1.value | t2.entity    | t2.datetime          | t2.value     | t2.tags.file_system                 | t2.tags.mount_point |
|----------------------|--------------|--------------|----------------------|----------|--------------|----------------------|--------------|-------------------------------------|---------------------|
| 2017-05-31T06:00:00Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:00Z | 51.1     | nurswgvml007 | 2017-05-31T06:00:00Z | 8651262.9    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:00Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:00Z | 51.1     | nurswgvml007 | 2017-05-31T06:00:00Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        |
| 2017-05-31T06:00:15Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:15Z | 5.1      | nurswgvml007 | 2017-05-31T06:00:15Z | 8652388.0    | /dev/mapper/vg_nurswgvml007-lv_root | /                   |
| 2017-05-31T06:00:15Z | nurswgvml007 | nurswgvml007 | 2017-05-31T06:00:15Z | 5.1      | nurswgvml007 | 2017-05-31T06:00:15Z | 1491432638.0 | //u113452.nurstr003/backup          | /mnt/u113452        | 
```
