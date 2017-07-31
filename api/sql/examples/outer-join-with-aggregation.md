# Outer Join with Aggregation

## Query

```sql
SELECT datetime, coalesce(t1.entity, t2.entity) AS server, AVG(t1.value), AVG(t2.value), t2.tags
  FROM mpstat.cpu_busy t1
FULL OUTER JOIN USING ENTITY df.disk_used t2
  WHERE t1.datetime >= '2017-05-31T06:00:00Z' AND t1.datetime < '2017-05-31T06:30:00Z'
GROUP BY server, PERIOD(15 MINUTE), t2.tags
  HAVING t2.tags IS NOT NULL
ORDER BY datetime, server, t2.tags
```

## Results

```ls
| datetime             | server       | avg(t1.value) | avg(t2.value) | t2.tags                                                                                        |
|----------------------|--------------|---------------|---------------|------------------------------------------------------------------------------------------------|
| 2017-05-31T06:00:00Z | nurswgvml006 | 3.5           | 6651453.0     | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/                                  |
| 2017-05-31T06:00:00Z | nurswgvml006 | 3.5           | 59722703.0    | file_system=/dev/sdc1;mount_point=/media/datadrive                                             |
| 2017-05-31T06:00:00Z | nurswgvml006 | 3.5           | 1491432638.0  | file_system=//u113452.nurstr003/backup;mount_point=/mnt/u113452                                |
| 2017-05-31T06:00:00Z | nurswgvml007 | 5.4           | 8641001.5     | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/                                  |
| 2017-05-31T06:00:00Z | nurswgvml007 | 5.4           | 1491432638.0  | file_system=//u113452.nurstr003/backup;mount_point=/mnt/u113452                                |
| 2017-05-31T06:15:00Z | nurswgvml006 | 6.3           | 6651532.0     | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/                                  |
| 2017-05-31T06:15:00Z | nurswgvml006 | 6.3           | 59695870.7    | file_system=/dev/sdc1;mount_point=/media/datadrive                                             |
| 2017-05-31T06:15:00Z | nurswgvml006 | 6.3           | 1491432638.0  | file_system=//u113452.nurstr003/backup;mount_point=/mnt/u113452                                |
| 2017-05-31T06:15:00Z | nurswgvml007 | 6.8           | 8642432.8     | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/                                  |
| 2017-05-31T06:15:00Z | nurswgvml007 | 6.8           | 1491432638.0  | file_system=//u113452.nurstr003/backup/backup;mount_point=/mnt/u113452                         |
```
