# Last Time

The `last_time` function returns last time in milliseconds when data was received for a given series.

The database tracks information about last insert times, last values, and insert counters for each series in a dedicated table, separate from the main data table.

Unlike the data table, the last insert table is updated with a delay of 15 seconds in order to minimize write load on the system by de-duplicating frequent updates that may arrive within the 15-second interval.

As a result, values returned by the `last_time` function may be lagging behind by a few seconds and expressions such as `WITH time > last_time` may actually produce records.

## Query

Returns data for the most recent 30 second interval for each series.

```sql
SELECT * FROM "mpstat.cpu_busy"
  WHERE datetime > current_day
AND entity LIKE 'n%00%'
  WITH time > last_time - 30*SECOND
```

## Results

```ls
| entity       | datetime                 | value | 
|--------------|--------------------------|------:| 
| nurswgvml007 | 2016-09-08T07:47:24.000Z | 4.0   | 
| nurswgvml007 | 2016-09-08T07:47:40.000Z | 4.1   | 
| nurswgvml006 | 2016-09-08T07:47:26.000Z | 4.0   | 
| nurswgvml006 | 2016-09-08T07:47:42.000Z | 66.0  | 
```

## Query

Returns avg() for the most recent hour for each series.  

```sql
SELECT entity, AVG(cpu_busy.value)
  FROM "mpstat.cpu_busy"
WHERE datetime > previous_month
  GROUP BY entity
WITH time > last_time - 1 * HOUR
```

## Results

```ls
| entity       | AVG(cpu_busy.value) | 
|--------------|--------------------:| 
| nurswgvml006 | 15.4                | 
| nurswgvml007 | 8.0                 | 
| nurswgvml009 | 5.9                 | 
| nurswgvml010 | 4.6                 | 
| nurswgvml011 | 3.2                 | 
| nurswgvml102 | 1.2                 | 
| nurswgvml301 | 0.9                 | 
| nurswgvml502 | 2.3                 | 
```

## Query

Same as above, grouped by period.  

```sql
SELECT entity, datetime, AVG(cpu_busy.value)
  FROM "mpstat.cpu_busy"
WHERE datetime > previous_month
  GROUP BY entity, period(1 HOUR)
WITH time > last_time - 1 * HOUR
```

## Results

```ls
| entity       | datetime                 | AVG(cpu_busy.value) | 
|--------------|--------------------------|--------------------:| 
| nurswgvml006 | 2016-09-08T07:00:00.000Z | 15.4                | 
| nurswgvml006 | 2016-09-08T08:00:00.000Z | 32.0                | 
| nurswgvml007 | 2016-09-08T07:00:00.000Z | 8.0                 | 
| nurswgvml007 | 2016-09-08T08:00:00.000Z | 8.2                 | 
| nurswgvml009 | 2016-08-25T06:00:00.000Z | 5.8                 | 
| nurswgvml009 | 2016-08-25T07:00:00.000Z | 6.0                 | 
| nurswgvml010 | 2016-09-08T07:00:00.000Z | 4.2                 | 
| nurswgvml010 | 2016-09-08T08:00:00.000Z | 4.1                 | 
| nurswgvml011 | 2016-08-24T11:00:00.000Z | 1.7                 | 
| nurswgvml011 | 2016-08-24T12:00:00.000Z | 3.5                 | 
| nurswgvml102 | 2016-08-25T06:00:00.000Z | 1.3                 | 
| nurswgvml102 | 2016-08-25T07:00:00.000Z | 1.1                 | 
| nurswgvml301 | 2016-09-08T07:00:00.000Z | 0.9                 | 
| nurswgvml301 | 2016-09-08T08:00:00.000Z | 0.1                 | 
| nurswgvml502 | 2016-09-08T07:00:00.000Z | 1.9                 | 
| nurswgvml502 | 2016-09-08T08:00:00.000Z | 5.9                 | 
```
