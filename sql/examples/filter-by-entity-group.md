# Filter by Entity Group

Supported syntax:

```sql
entity.groups IN ('group-1', 'group-2') -- entity belongs to one of the groups listed in the IN clause
entity.groups NOT IN ('group-1', 'group-1') -- entity does NOT belong to any of the groups listed in the IN clause
'group-1' IN entity.groups -- entity belongs to the specified group
'group-1' NOT IN entity.groups -- entity does NOT belong to the specified group
```

Entity Group names are case-sensitive.

## Select Entities Belonging to the Specified Entity Group

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE 'nur-collectors' IN entity.groups
  AND datetime > current_hour
ORDER BY datetime
```

### Results

```ls
| datetime                 | entity       | value |
|--------------------------|--------------|-------|
| 2016-07-14T15:00:04.000Z | nurswgvml502 | 51.1  |
| 2016-07-14T15:00:06.000Z | nurswgvml009 | 3.0   |
| 2016-07-14T15:00:07.000Z | nurswgvml007 | 44.7  |
| 2016-07-14T15:00:10.000Z | nurswgvml011 | 100.0 |
| 2016-07-14T15:00:13.000Z | nurswgvml102 | 2.0   |
```

## Include Entity Groups Column in the Result Set

### Query

```sql
SELECT datetime, entity, value, entity.groups
  FROM "mpstat.cpu_busy"
WHERE 'nur-collectors' IN entity.groups
  AND datetime > current_hour
ORDER BY datetime
```

### Results with Entity Groups Column

```ls
| datetime                 | entity       | value | entity.groups                                                                                                                                                                |
|--------------------------|--------------|-------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2016-07-14T15:00:04.000Z | nurswgvml502 | 51.1  | nmon-linux;nmon-linux-beta;nur-collectors;scollector-nur;tcollector - linux                                                                                                  |
| 2016-07-14T15:00:06.000Z | nurswgvml009 | 3.0   | VMware VMs;nmon-linux;nmon-linux-beta;nur-collectors;oracle-hosts;scollector-nur;solarwind-vmware-vm;tcollector - linux                                                      |
| 2016-07-14T15:00:07.000Z | nurswgvml007 | 44.7  | VMware VMs;java-loggers;java-virtual-machine;jetty-web-server;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-nur;solarwind-vmware-vm;tcollector - linux |
| 2016-07-14T15:00:10.000Z | nurswgvml011 | 100.0 | VMware VMs;nmon-linux;nmon-linux-beta;nur-collectors;scollector-nur;solarwind-vmware-vm;solarwinds-base;tcollector - linux                                                   |
| 2016-07-14T15:00:13.000Z | nurswgvml102 | 2.0   | VMware VMs;nmon-linux;nmon-linux-beta;nur-collectors;solarwind-vmware-vm;tcollector - linux                                                                                  |
```

## Check Expression in Entity Group

```sql
SELECT entity, REPLACE(entity, 'nurswgvml', '') AS sfx, count(value)
  FROM cpu_busy
WHERE datetime > current_hour
  AND is_entity_in_group(sfx, 'nur-hbase')
GROUP BY entity
```

```txt
| entity       | sfx | count(value) |
|--------------|-----|--------------|
| nurswgvml010 | 010 |          156 |
| nurswgvml501 | 501 |          156 |
| nurswgvml502 | 502 |          156 |
| nurswgvml301 | 301 |           80 |
```