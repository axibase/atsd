# Select Metadata

Entity metadata contains entity tags with user-defined names as well as predefined fields `label`, `timeZone`, and `interpolate`.

Entity tags can be accessed with `entity.tags.{tag-name}` syntax whereas entity fields are accessible with `entity.{field-name}` syntax.

The `entity.*` expression expands to multiple columns containing all entity fields.

The list of pre-defined columns is provided [here](../README.md#predefined-columns).

## Named Columns

### Query

```sql
SELECT datetime, value, tags,
  entity, -- entity name
  entity.tags, -- all entity tags, concatenated into one string
  entity.tags.app, -- specific entity tag
  entity.label, -- entity field 'label'
  entity.timeZone, -- entity field 'timeZone'
  entity.groups -- list of groups of which the entity is member, concatenated into one string
FROM "df.disk_used"
  WHERE entity IN ('nurswgvml007', 'nurswgvml006')
AND tags.mount_point = '/'
AND datetime > now - 5*MINUTE
  ORDER BY datetime
```

### Results

```ls
| datetime                 | value   | tags                                                          | entity       | entity.tags                                                                              | entity.tags.app | entity.label | entity.timeZone        | entity.groups                                                                                                                                                                |
|--------------------------|---------|---------------------------------------------------------------|--------------|------------------------------------------------------------------------------------------|-----------------|--------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2017-01-20T12:47:06.000Z | 9075988 | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/ | nurswgvml007 | alias=007;app=ATSD;environment=prod;ip=192.0.2.6;loc_area=dc1;loc_code=nur,nur;os=Linux | ATSD            | NURswgvml007 | PST                    | java-loggers;java-virtual-machine;jetty-web-server;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs |
| 2017-01-20T12:47:09.000Z | 6410480 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | nurswgvml006 | app=Hadoop/HBase;environment=prod;ip=192.0.2.5;loc_area=dc1;os=Linux                    | Hadoop/HBase    | NURSWGVML006 | America/Bahia_Banderas | java-loggers;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-linux;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs                      |
```

## All Entity Columns

### Query

```sql
SELECT datetime, value, entity.*
FROM "mpstat.cpu_busy"
  WHERE entity IN ('nurswgvml007', 'nurswgvml006')
AND tags.mount_point = '/'
AND datetime > now - 5*MINUTE
  ORDER BY datetime
```

### Results

```ls
| datetime            | value | entity.name  | entity.label | entity.creationTime | entity.timeZone | entity.interpolate | entity.groups               | entity.enabled | entity.tags                                                                                                                   |
|---------------------|-------|--------------|--------------|---------------------|-----------------|--------------------|-----------------------------|----------------|-------------------------------------------------------------------------------------------------------------------------------|
| 2019-01-30 11:34:27 |   7.8 | nurswgvml006 | NURSWGVML006 |                     | US/Mountain     |                    | nmon-linux;scollector-linux | true           | app=Hadoop/HBASE;environment=prod;ip=192.0.2.1;loc_area=dc1;monitor.env=Production;os=Linux                                   |
| 2019-01-30 11:34:29 |   7.0 | nurswgvml007 | NURswgvml007 |                     | PST             | LINEAR             | tcollector;scollector-linux | true           | alias=007;app=ATSD;cpu_count=1;environment=prod;ip=198.51.100.1;loc_area=dc1;loc_code=nur,nur;monitor.env=Production;os=Linux |
```

## All Metric Columns

### Query

```sql
SELECT datetime, value, metric.*
FROM "mpstat.cpu_busy"
  WHERE entity IN ('nurswgvml007', 'nurswgvml006')
AND tags.mount_point = '/'
AND datetime > now - 5*MINUTE
  ORDER BY datetime
```

### Results

```ls
| datetime            | value | metric.name     | metric.label | metric.timeZone | metric.interpolate | metric.lastInsertTime | metric.creationTime | metric.description | metric.dataType | metric.enabled | metric.persistent | metric.filter | metric.retentionIntervalDays | metric.versioning | metric.minValue | metric.maxValue | metric.invalidValueAction | metric.units | metric.tags                                   |
|---------------------|-------|-----------------|--------------|-----------------|--------------------|-----------------------|---------------------|--------------------|-----------------|----------------|-------------------|---------------|------------------------------|-------------------|-----------------|-----------------|---------------------------|--------------|-----------------------------------------------|
| 2019-01-30 11:40:19 |   2.5 | mpstat.cpu_busy | CPU Busy %   | US/Eastern      | LINEAR             |         1548848699000 |                     |                    | DECIMAL         | true           | true              |               |                            0 | false             |             0.0 |           100.0 | TRANSFORM                 |              | source=iostat;table=System;threshold_value=90 |
| 2019-01-30 11:40:21 |   8.0 | mpstat.cpu_busy | CPU Busy %   | US/Eastern      | LINEAR             |         1548848699000 |                     |                    | DECIMAL         | true           | true              |               |                            0 | false             |             0.0 |           100.0 | TRANSFORM                 |              | source=iostat;table=System;threshold_value=90 |
```