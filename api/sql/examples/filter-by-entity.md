# Filter by Entity

## Filter Results by Entity Name

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime > current_hour
```

### Results

```ls
| datetime                 | entity       | value | 
|--------------------------|--------------|-------| 
| 2016-07-14T14:53:10.000Z | nurswgvml007 | 7.1   | 
| 2016-07-14T14:53:26.000Z | nurswgvml007 | 6.0   | 
| 2016-07-14T14:53:42.000Z | nurswgvml007 | 9.0   | 
```

## Filter Results Excluding a Particular Entity

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity != 'nurswgvml007'
  AND datetime > current_hour
ORDER BY datetime
```

### Results

```ls
| datetime                 | entity       | value | 
|--------------------------|--------------|-------| 
| 2016-07-14T14:00:04.000Z | nurswgvml009 | 100.0 | 
| 2016-07-14T14:00:06.000Z | nurswgvml006 | 21.2  | 
| 2016-07-14T14:00:08.000Z | nurswgvml010 | 2.0   | 
| 2016-07-14T14:00:08.000Z | nurswgvml011 | 39.2  | 
| 2016-07-14T14:00:12.000Z | nurswgvml102 | 2.0   | 
| 2016-07-14T14:00:16.000Z | nurswgvml502 | 3.5   | 
```

## Filter Results for Multiple Entities

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity IN ('nurswgvml006', 'nurswgvml007')
  AND datetime > current_hour
ORDER BY datetime  
```

### Results

```ls
| datetime                 | entity       | value | 
|--------------------------|--------------|-------| 
| 2016-07-14T14:00:02.000Z | nurswgvml007 | 100.0 | 
| 2016-07-14T14:00:06.000Z | nurswgvml006 | 21.2  | 
| 2016-07-14T14:00:18.000Z | nurswgvml007 | 100.0 | 
| 2016-07-14T14:00:22.000Z | nurswgvml006 | 22.0  | 
| 2016-07-14T14:00:34.000Z | nurswgvml007 | 19.0  | 
| 2016-07-14T14:00:38.000Z | nurswgvml006 | 21.4  | 
```

## Filter Results Excluding Particular Entities

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity NOT IN ('nurswgvml006', 'nurswgvml007')
  AND datetime > current_hour
ORDER BY datetime  
```

### Results

```ls
| datetime                 | entity       | value | 
|--------------------------|--------------|-------| 
| 2016-07-14T15:00:04.000Z | nurswgvml502 | 51.1  | 
| 2016-07-14T15:00:06.000Z | nurswgvml009 | 3.0   | 
| 2016-07-14T15:00:10.000Z | nurswgvml011 | 100.0 | 
| 2016-07-14T15:00:13.000Z | nurswgvml102 | 2.0   | 
| 2016-07-14T15:00:14.000Z | nurswgvml010 | 27.7  | 
| 2016-07-14T15:00:26.000Z | nurswgvml011 | 42.7  | 
```

## Filter Results for Entity Name Pattern

### Query

```sql
SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE entity LIKE 'nurswgvml00%'
  AND datetime > current_hour
ORDER BY datetime  
```

### Results

```ls
| datetime                 | entity       | value | 
|--------------------------|--------------|-------| 
| 2016-07-14T14:00:02.000Z | nurswgvml007 | 100.0 | 
| 2016-07-14T14:00:04.000Z | nurswgvml009 | 100.0 | 
| 2016-07-14T14:00:06.000Z | nurswgvml006 | 21.2  | 
| 2016-07-14T14:00:18.000Z | nurswgvml007 | 100.0 | 
| 2016-07-14T14:00:20.000Z | nurswgvml009 | 100.0 | 
| 2016-07-14T14:00:22.000Z | nurswgvml006 | 22.0  | 
| 2016-07-14T14:00:34.000Z | nurswgvml007 | 19.0  | 
| 2016-07-14T14:00:36.000Z | nurswgvml009 | 100.0 | 
| 2016-07-14T14:00:38.000Z | nurswgvml006 | 21.4  | 
```
