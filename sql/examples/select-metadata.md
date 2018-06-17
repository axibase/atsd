# Select Metadata

Entity metadata contains entity tags with user-defined names as well as predefined fields `label`, `timeZone`, and `interpolate`.

Entity tags can be accessed with `entity.tags.{tag-name}` syntax whereas entity fields are accessible with `entity.{field-name}` syntax.

The list of pre-defined columns is provided [here](../README.md#predefined-columns).

## Query

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

## Results

```ls
| datetime                 | value   | tags                                                          | entity       | entity.tags                                                                              | entity.tags.app | entity.label | entity.timeZone        | entity.groups                                                                                                                                                                |
|--------------------------|---------|---------------------------------------------------------------|--------------|------------------------------------------------------------------------------------------|-----------------|--------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2017-01-20T12:47:06.000Z | 9075988 | file_system=/dev/mapper/vg_nurswgvml007-lv_root;mount_point=/ | nurswgvml007 | alias=007;app=ATSD;environment=prod;ip=10.102.0.6;loc_area=dc1;loc_code=nur,nur;os=Linux | ATSD            | NURswgvml007 | PST                    | java-loggers;java-virtual-machine;jetty-web-server;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs |
| 2017-01-20T12:47:09.000Z | 6410480 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | nurswgvml006 | app=Hadoop/HBase;environment=prod;ip=10.102.0.5;loc_area=dc1;os=Linux                    | Hadoop/HBase    | NURSWGVML006 | America/Bahia_Banderas | java-loggers;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-linux;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs                      |
```
