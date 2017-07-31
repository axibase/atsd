# Select Pre-Defined Columns

## Query

```sql
SELECT time, datetime, value, text, metric, entity, tags, metric.tags, entity.tags, entity.groups
  FROM df.disk_used
WHERE entity = 'nurswgvml006' 
  AND datetime > now - 5 * minute
ORDER BY datetime
```

## Results

```ls
| time          | datetime             | value    | text | metric    | entity       | tags                                                          | metric.tags         | entity.tags                                                           | entity.groups                                                                                                                                           | 
|---------------|----------------------|----------|------|-----------|--------------|---------------------------------------------------------------|---------------------|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------| 
| 1499177885000 | 2017-07-04T14:18:05Z | 6652408  | null | disk_used | nurswgvml006 | file_system=/dev/mapper/vg_nurswgvml006-lv_root;mount_point=/ | table=Disk (script) | app=Hadoop/HBASE;environment=prod;ip=10.102.0.5;loc_area=dc1;os=Linux | java-loggers;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-linux;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs | 
| 1499177885000 | 2017-07-04T14:18:05Z | 58663856 | null | disk_used | nurswgvml006 | file_system=/dev/sdc1;mount_point=/media/datadrive            | table=Disk (script) | app=Hadoop/HBASE;environment=prod;ip=10.102.0.5;loc_area=dc1;os=Linux | java-loggers;nmon-linux;nmon-linux-beta;nmon-sub-group;nur-collectors;scollector-linux;scollector-nur;solarwind-vmware-vm;tcollector - linux;VMware VMs | 
```
