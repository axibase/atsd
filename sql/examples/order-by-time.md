# ORDER By Time

## Query

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN now - 1 * hour AND now
  ORDER BY datetime
```

## Results

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-17T18:34:32.000Z | 6.1   |
| 2016-06-17T18:34:48.000Z | 2.0   |
| 2016-06-17T18:35:04.000Z | 83.3  |
| 2016-06-17T18:35:20.000Z | 5.0   |
| 2016-06-17T18:35:36.000Z | 5.0   |
| 2016-06-17T18:35:52.000Z | 3.0   |
| 2016-06-17T18:36:08.000Z | 4.0   |
| 2016-06-17T18:36:25.000Z | 7.0   |
| 2016-06-17T18:36:41.000Z | 4.0   |
| 2016-06-17T18:36:57.000Z | 3.0   |
```
