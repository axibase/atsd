# Date Utility Functions

## `CURRENT_TIMESTAMP`

The function returns current database date and time in ISO-8601 format with millisecond precision. 

### Query

```sql
SELECT CURRENT_TIMESTAMP
```

### Results

```ls
| CURRENT_TIMESTAMP        | 
|--------------------------| 
| 2017-07-11T14:32:07.100Z | 
```

### Query

```sql
SELECT entity, datetime, value 
  FROM mpstat.cpu_busy
WHERE datetime > CURRENT_TIMESTAMP - 1*DAY 
  LIMIT 1
```

### Results

```ls
| entity       | datetime                 | value | 
|--------------|--------------------------|-------| 
| nurswgvml007 | 2017-07-10T14:34:46.000Z | 2.97  | 
| nurswgvml007 | 2017-07-10T14:35:02.000Z | 59.18 | 
| nurswgvml007 | 2017-07-10T14:35:18.000Z | 51    | 
```

## `DBTIMEZONE` Function

The `DBTIMEZONE` returns the database timezone name.

### Query

```sql
SELECT DBTIMEZONE
```

### Results

```ls
| DBTIMEZONE | 
|------------| 
| GMT0       | 
```
