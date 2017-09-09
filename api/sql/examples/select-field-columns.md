# Select Field Columns

The list of columns available in the `SELECT` expression includes columns that are mapped to the following entity and metric fields:

* `metric.label`
* `metric.timezone`
* `metric.interpolate`
* `entity.label`
* `entity.timezone`
* `entity.interpolate`

## Query

```sql
SELECT datetime, entity, metric, value,
  metric.label, metric.timezone, ISNULL(metric.interpolate, 'N/A'),
  entity.label, entity.timezone, ISNULL(entity.interpolate, 'N/A')  
FROM atsd_series WHERE metric IN ('mpstat.cpu_busy', 'mpstat.cpu_user', 'mpstat.cpu_system')
  AND datetime BETWEEN '2016-10-16T17:10:00Z' AND '2016-10-16T17:10:20Z'
  AND entity LIKE 'nurswgvml0%'
  ORDER BY datetime
```

## Results

```ls
| datetime                 | entity       | metric     | value | metric.label | metric.timezone | ISNULL(metric.interpolate,'N/A') | entity.label                  | entity.timezone | ISNULL(entity.interpolate,'N/A') | 
|--------------------------|--------------|------------|-------|--------------|-----------------|----------------------------------|-------------------------------|-----------------|----------------------------------| 
| 2016-10-16T17:10:05.000Z | nurswgvml010 | cpu_busy   | 25.9  | CPU Busy %   | EST             | LINEAR                           | NURSWGVML010.corp.axibase.com | null            | N/A                              | 
| 2016-10-16T17:10:05.000Z | nurswgvml010 | cpu_system | 0.8   | CPU Sys %    | AEST            | LINEAR                           | NURSWGVML010.corp.axibase.com | null            | N/A                              | 
| 2016-10-16T17:10:05.000Z | nurswgvml010 | cpu_user   | 25.1  | CPU User %   | null            | LINEAR                           | NURSWGVML010.corp.axibase.com | null            | N/A                              | 
| 2016-10-16T17:10:07.000Z | nurswgvml009 | cpu_busy   | 1.0   | CPU Busy %   | EST             | LINEAR                           | null                          | UTC             | N/A                              | 
| 2016-10-16T17:10:07.000Z | nurswgvml009 | cpu_system | 1.0   | CPU Sys %    | AEST            | LINEAR                           | null                          | UTC             | N/A                              | 
| 2016-10-16T17:10:07.000Z | nurswgvml009 | cpu_user   | 0.0   | CPU User %   | null            | LINEAR                           | null                          | UTC             | N/A                              | 
| 2016-10-16T17:10:08.000Z | nurswgvml006 | cpu_busy   | 5.0   | CPU Busy %   | EST             | LINEAR                           | NURSWGVML006                  | CST             | N/A                              | 
| 2016-10-16T17:10:08.000Z | nurswgvml006 | cpu_system | 2.0   | CPU Sys %    | AEST            | LINEAR                           | NURSWGVML006                  | CST             | N/A                              | 
| 2016-10-16T17:10:08.000Z | nurswgvml006 | cpu_user   | 3.0   | CPU User %   | null            | LINEAR                           | NURSWGVML006                  | CST             | N/A                              | 
| 2016-10-16T17:10:13.000Z | nurswgvml007 | cpu_busy   | 15.5  | CPU Busy %   | EST             | LINEAR                           | NURswgvml007                  | PST             | LINEAR                           | 
| 2016-10-16T17:10:13.000Z | nurswgvml007 | cpu_system | 2.1   | CPU Sys %    | AEST            | LINEAR                           | NURswgvml007                  | PST             | LINEAR                           | 
| 2016-10-16T17:10:13.000Z | nurswgvml007 | cpu_user   | 13.4  | CPU User %   | null            | LINEAR                           | NURswgvml007                  | PST             | LINEAR                           | 
```

