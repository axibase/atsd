# Select Metric Tags

Similar to series tags, metric tags can be selected with:

* `metric.tags`: serialized to name=value;name=value
* `metric.tags.*`: expand to multiple columns
* `metric.tags.{name}`: include column with a specific metric tag

## Query

```sql
SELECT entity, datetime, value, metric, metric.tags, metric.tags.*, metric.tags.source
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime > now - 5 * MINUTE
```

## Results

```ls
| entity       | datetime                 | value | metric   | metric.tags                | metric.tags.source | metric.tags.table | metric.tags.source |
|--------------|--------------------------|-------|----------|----------------------------|--------------------|-------------------|--------------------|
| nurswgvml006 | 2016-08-16T10:46:13.000Z | 4.0   | cpu_busy | source=iostat;table=System | iostat             | System            | iostat             |
| nurswgvml006 | 2016-08-16T10:46:29.000Z | 2.0   | cpu_busy | source=iostat;table=System | iostat             | System            | iostat             |
| nurswgvml006 | 2016-08-16T10:46:45.000Z | 3.0   | cpu_busy | source=iostat;table=System | iostat             | System            | iostat             |
```

## Query

```sql
SELECT t1.entity, t1.datetime, t1.value, t2.value, t2.tags, t1.metric.tags, t2.metric.tags
  FROM "df.disk_used" t1
  JOIN USING ENTITY "mpstat.cpu_busy" t2
WHERE t1.entity = 'nurswgvml006'
  AND t1.datetime > now - 5 * minute
```

```ls
| t1.entity    | t1.datetime              | t1.value     | t2.value | t2.tags                                                         | t1.metric.tags      | t2.metric.tags             |
|--------------|--------------------------|--------------|----------|-----------------------------------------------------------------|---------------------|----------------------------|
| nurswgvml006 | 2016-07-15T10:41:27.000Z | 1753141830.0 | 13.0     | file_system=//u113452.nurstr003/backup;mount_point=/mnt/u113452 | table=Disk (script) | source=iostat;table=System |
| nurswgvml006 | 2016-07-15T10:41:27.000Z | 5614484.0    | 13.0     | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/   | table=Disk (script) | source=iostat;table=System |
| nurswgvml006 | 2016-07-15T10:41:27.000Z | 53361316.0   | 13.0     | file_system=/dev/sdc1;mount_point=/media/datadrive              | table=Disk (script) | source=iostat;table=System |
```
