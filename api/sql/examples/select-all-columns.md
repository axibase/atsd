# Select All Columns

`SELECT *` can be used to include all available columns in the result set.

The list of available columns includes time, datetime, value, text, metric, entity, and series tags.

> Note that the `SELECT *` expression includes only a subset of all the pre-defined columns. Columns such as `metric.label`, `entity.tags` or `time` should be referenced explicitly.

> Series tags can be included in the SELECT expression separately using `SELECT tags.{name}` syntax.

## Query Without Series Tags

```sql
SELECT *
  FROM mpstat.cpu_busy
WHERE entity = 'nurswgvml006'
  AND datetime > now - 5 * minute
```

## Results

```ls
| time          | datetime             | value | text | metric          | entity       | tags | 
|---------------|----------------------|-------|------|-----------------|--------------|------| 
| 1499177483000 | 2017-07-04T14:11:23Z | 3.03  | null | mpstat.cpu_busy | nurswgvml006 | null | 
| 1499177499000 | 2017-07-04T14:11:39Z | 6.19  | null | mpstat.cpu_busy | nurswgvml006 | null | 
| 1499177515000 | 2017-07-04T14:11:55Z | 1.02  | null | mpstat.cpu_busy | nurswgvml006 | null | 
```

## Query With Series Tags

```sql
SELECT *
  FROM df.disk_used
WHERE entity = 'nurswgvml006'
  AND datetime > now - 5 * minute
ORDER BY datetime
```

## Results

```ls
| time          | datetime             | value   | text | metric       | entity       | tags                                                          | 
|---------------|----------------------|---------|------|--------------|--------------|---------------------------------------------------------------| 
| 1499177539000 | 2017-07-04T14:12:19Z | 6652400 | null | df.disk_used | nurswgvml006 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | 
| 1499177554000 | 2017-07-04T14:12:34Z | 6652400 | null | df.disk_used | nurswgvml006 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | 
| 1499177569000 | 2017-07-04T14:12:49Z | 6652392 | null | df.disk_used | nurswgvml006 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | 
```

## Query - `JOIN`

If the query is joining multiple tables, the list of columns in the result set includes columns from each table.

In case of `JOIN`, column names are fully qualified and include both table name (alias) and column name.

```sql
SELECT *
  FROM df.disk_used
  JOIN USING entity mpstat.cpu_busy
WHERE mpstat.cpu_busy.entity = 'nurswgvml006'
  AND df.disk_used.datetime > now - 5 * minute
```

## Results

```ls
| disk_used.time | disk_used.datetime   | disk_used.value | disk_used.text | disk_used.metric | disk_used.entity | disk_used.tags                                                | cpu_busy.time | cpu_busy.datetime    | cpu_busy.value | cpu_busy.text | cpu_busy.metric | cpu_busy.entity | cpu_busy.tags | 
|----------------|----------------------|-----------------|----------------|------------------|------------------|---------------------------------------------------------------|---------------|----------------------|----------------|---------------|-----------------|-----------------|---------------| 
| 1499177675000  | 2017-07-04T14:14:35Z | 6652392         | null           | df.disk_used     | nurswgvml006     | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | 1499177675000 | 2017-07-04T14:14:35Z | 3              | null          | mpstat.cpu_busy | nurswgvml006    | null          | 
| 1499177675000  | 2017-07-04T14:14:35Z | 58659216        | null           | df.disk_used     | nurswgvml006     | file_system=/dev/sdc1;mount_point=/media/datadrive            | 1499177675000 | 2017-07-04T14:14:35Z | 3              | null          | mpstat.cpu_busy | nurswgvml006    | null          | 
```
