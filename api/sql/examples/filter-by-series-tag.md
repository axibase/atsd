# Filter by Series Tag

Filter by entity and series tag using the `LIKE` pattern.

## Query

```sql
SELECT datetime, value, tags.file_system 
  FROM "df.disk_used"_percent 
WHERE entity = 'nurswgvml007'
  AND tags.file_system LIKE '/d%' 
  AND datetime >= now - 1 * hour
```

## Results

```ls
| datetime                 | value | tags.file_system                    | 
|--------------------------|-------|-------------------------------------| 
| 2016-07-15T10:33:55.000Z | 68.4  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:34:10.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:34:25.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:34:40.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:34:55.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:35:10.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:35:25.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:35:40.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:35:55.000Z | 68.5  | /dev/mapper/vg_nurswgvml007-lv_root | 
| 2016-07-15T10:36:10.000Z | 68.1  | /dev/mapper/vg_nurswgvml007-lv_root | 
```
