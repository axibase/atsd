# Select Predefined Columns

## Query

The query returns all [series columns](../README.md#series-columns) as well as entity tags, entity groups, metric tags, and a metric field column.

### Tags

The `tags` columns serialize tags into a colon-separated `key=value` string. Each tag can be referenced in a separate column using the `tags.{tag-name}` notation.

```sql
entity.tags.app
entity.tags.location
entity.tags."loc-area"
```

> Tag names containing special characters must be quoted.

### Fields

The [metric](../README.md#metric-columns) and [entity](../README.md#entity-columns) metadata fields can be accessed using the `metric.{field-name}` and `entity.{field-name}` notation.

```sql
metric.units
entity.label
entity.timeZone
```

### Query Text

```sql
SELECT time, datetime, value, text, metric, entity, tags, -- series columns, same as SELECT * columns
  entity.tags,     -- all entity tags in one column
  entity.tags.app, -- specific tag by name
  entity.groups,   -- all entity groups in one column
  metric.tags,     -- all entity tags in one column
  metric.units     -- metric metadata field
  FROM "df.disk_used"
WHERE entity = 'nurswgvml006'
  AND datetime > now - 5 * minute
ORDER BY datetime
```

### Results

```ls
| time           | datetime                  | value     | text  | metric     | entity        | tags                                                | entity.tags.app  | entity.tags                             | entity.groups              | metric.tags          | metric.units |
|----------------|---------------------------|-----------|-------|------------|---------------|-----------------------------------------------------|------------------|-----------------------------------------|----------------------------|----------------------|--------------|
| 1532408808000  | 2018-07-24T05:06:48.000Z  | 4796380   |       | disk_used  | nurswgvml006  | file_system=/dev/mapper/vg-lv_root;mount_point=/    | Hadoop/HBASE     | app=Hadoop/HBASE;ip=192.0.2.5;os=Linux  | nmon-linux;nur-collectors  | table=Disk (script)  | bytes        |
| 1532408808000  | 2018-07-24T05:06:48.000Z  | 61406796  |       | disk_used  | nurswgvml006  | file_system=/dev/sdb1;mount_point=/media/datadrive  | Hadoop/HBASE     | app=Hadoop/HBASE;ip=192.0.2.5;os=Linux  | nmon-linux;nur-collectors  | table=Disk (script)  | bytes        |
```
