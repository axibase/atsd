# Aggregate - Recent Values

## Window without Series Tag Grouping

### Query

```sql
SELECT entity, avg(value), max(value), last(value), count(*)
 FROM "mpstat.cpu_busy"
WHERE datetime >= now - 1 * HOUR
 GROUP BY entity
```

### Results

```ls
| entity       | avg(value) | max(value) | last(value) | count(*) |
|--------------|------------|------------|-------------|----------|
| nurswgvml006 | 20         | 100        | 50          | 223      |
| nurswgvml007 | 16         | 100        | 49          | 223      |
| nurswgvml009 | 16         | 100        | 10          | 225      |
| nurswgvml010 | 14         | 100        | 68          | 223      |
| nurswgvml011 | 6          | 100        | 0           | 226      |
| nurswgvml102 | 1          | 9          | 1           | 224      |
| nurswgvml502 | 5          | 75         | 28          | 223      |
```

## Window with Tags

### Query

```sql
SELECT entity, tags, avg(value), max(value), last(value), count(*)
 FROM "df.disk_used"
WHERE datetime >= now - 1 * HOUR
 GROUP BY entity, tags
```

### Results

```ls
| entity       | tags                                                  | avg(value)   | max(value)   | last(value)  | count(*)     |
|--------------|----------------------------------------------------------------------|--------------|--------------|--------------|
| nurswgvml006 | file_system=//u113452/backup;mount_point=/mnt/u113452 | 1693287308.0 | 1693287308.0 | 1693287308.0 | 218.0        |
| nurswgvml007 | file_system=//u113452/backup;mount_point=/mnt/u113452 | 1693287308.0 | 1693287308.0 | 1693287308.0 | 219.0        |
| nurswgvml010 | file_system=//u113452/backup;mount_point=/mnt/u113452 | 1693287308.0 | 1693287308.0 | 1693287308.0 | 218.0        |
| nurswgvml011 | file_system=//u113452/backup;mount_point=/mnt/u113452 | 1693287308.0 | 1693287308.0 | 1693287308.0 | 223.0        |
| nurswgvml102 | file_system=//u113452/backup;mount_point=/mnt/u113452 | 1693287308.0 | 1693287308.0 | 1693287308.0 | 220.0        |
```
