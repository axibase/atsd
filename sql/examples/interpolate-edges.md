# Interpolate Edges

## Data

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-19T09:10:00Z' AND datetime < '2016-06-19T09:40:00Z'
  AND entity = 'nurswgvml006'
```

```ls
| entity       | datetime                 | value |
|--------------|--------------------------|-------|
| nurswgvml006 | 2016-06-19T09:19:00.000Z |  9.0  |
| nurswgvml006 | 2016-06-19T09:23:00.000Z | 13.0  |
| nurswgvml006 | 2016-06-19T09:24:00.000Z | 14.0  |
| nurswgvml006 | 2016-06-19T09:27:00.000Z | 17.0  |
| nurswgvml006 | 2016-06-19T09:28:00.000Z | 18.0  |
| nurswgvml006 | 2016-06-19T09:30:00.000Z | 20.0  |
```

## Data within the 10 minute Half-Inclusive Interval [)

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-19T09:20:00Z' AND datetime < '2016-06-19T09:30:00Z'
  AND entity = 'nurswgvml006'
```

```ls
| entity       | datetime                 | value |
|--------------|--------------------------|-------|
| nurswgvml006 | 2016-06-19T09:23:00.000Z | 13.0  |
| nurswgvml006 | 2016-06-19T09:24:00.000Z | 14.0  |
| nurswgvml006 | 2016-06-19T09:27:00.000Z | 17.0  |
| nurswgvml006 | 2016-06-19T09:28:00.000Z | 18.0  |
```

## Grouped Data within the 10 Minute Half-Inclusive Interval [)

```sql
SELECT entity, datetime, MAX(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-19T09:20:00Z' AND datetime < '2016-06-19T09:30:00Z'
  AND entity = 'nurswgvml006'
  GROUP BY entity, PERIOD(1 MINUTE)
```

```ls
| entity       | datetime                 | MAX(value) |
|--------------|--------------------------|------------|
| nurswgvml006 | 2016-06-19T09:23:00.000Z | 13.0       |
| nurswgvml006 | 2016-06-19T09:24:00.000Z | 14.0       |
| nurswgvml006 | 2016-06-19T09:27:00.000Z | 17.0       |
| nurswgvml006 | 2016-06-19T09:28:00.000Z | 18.0       |
```

## Interpolation

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute, PREVIOUS)
```

```ls
| entity       | datetime                 | MAX(value) |
|--------------|--------------------------|------------|
| nurswgvml006 | 2016-06-19T09:23:00.000Z | 13.0       |
| nurswgvml006 | 2016-06-19T09:24:00.000Z | 14.0       |
| nurswgvml006 | 2016-06-19T09:25:00.000Z | 14.0       | + interpolated +
| nurswgvml006 | 2016-06-19T09:26:00.000Z | 14.0       | + interpolated +
| nurswgvml006 | 2016-06-19T09:27:00.000Z | 17.0       |
| nurswgvml006 | 2016-06-19T09:28:00.000Z | 18.0       |
```

* Interpolated values are calculated between neighboring values in the result set.
* Although data prior to 09:20:00 and at or after 09:30:00 exists in the database, the data is outside of the start and end date specified in the `WHERE` clause.
* Therefore, data for **leading** periods starting at 09:20:00, 09:21:00, 09:22:00 and for **trailing** period starting at 09:29:00 is not interpolated.
