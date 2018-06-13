# Interpolate with `EXTEND`

* If the `VALUE {n}` interpolation function is specified in the `PERIOD` clause, the `EXTEND` option sets empty leading/trailing period values to equal `{n}`.
* Without the `VALUE {n}` function, the `EXTEND` option adds missing periods at the beginning and end of the selection interval using the `NEXT` and `PREVIOUS` interpolation functions.
* If the query doesn't contain a start date condition, `EXTEND` is _not_ applied to leading periods because the start date is not known.
* If the query doesn't contain an end date condition, `EXTEND` is _not_ applied to trailing periods because the end date is not known.

## Data

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:25:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-03T09:25:04.000Z | 17.0  |
| 2016-06-03T09:25:20.000Z | 2.0   |
| 2016-06-03T09:25:36.000Z | 6.9   |
| 2016-06-03T09:25:52.000Z | 1.0   |
| 2016-06-03T09:26:08.000Z | 6.9   |
| 2016-06-03T09:26:24.000Z | 0.0   |
| 2016-06-03T09:26:40.000Z | 2.0   |
| 2016-06-03T09:26:56.000Z | 5.0   |
-- no data betweeen 26:56 and 38.24 --
| 2016-06-03T09:38:24.000Z | 0.0   |
| 2016-06-03T09:38:40.000Z | 4.0   |
| 2016-06-03T09:38:56.000Z | 4.0   |
| 2016-06-03T09:39:12.000Z | 8.1   |
| 2016-06-03T09:39:28.000Z | 7.0   |
| 2016-06-03T09:39:44.000Z | 18.8  |
```

## Query without `EXTEND`

If the query selects 2-minute periods for the 09:30 - 09:40 interval, the first period is dated 09:38

```sql
SELECT datetime, count(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:30:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY PERIOD(1 MINUTE)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-06-03T09:38:00.000Z | 2.7        |
| 2016-06-03T09:39:00.000Z | 11.3       |
```

## Query with `EXTEND`

Query with `EXTEND` adds missing periods at the beginning of the interval by applying the `NEXT` interpolation function.

```sql
SELECT datetime, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:30:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY PERIOD(1 MINUTE, EXTEND)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-06-03T09:30:00.000Z | 2.7        |
| 2016-06-03T09:31:00.000Z | 2.7        |
| 2016-06-03T09:32:00.000Z | 2.7        |
| 2016-06-03T09:33:00.000Z | 2.7        |
| 2016-06-03T09:34:00.000Z | 2.7        |
| 2016-06-03T09:35:00.000Z | 2.7        |
| 2016-06-03T09:36:00.000Z | 2.7        |
| 2016-06-03T09:37:00.000Z | 2.7        |
| 2016-06-03T09:38:00.000Z | 2.7        |
| 2016-06-03T09:39:00.000Z | 11.3       |
```

## Query with Inner `LINEAR` Interpolation and without `EXTEND` Option

```sql
SELECT datetime, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:37:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY PERIOD(10 second, LINEAR)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-06-03T09:38:20.000Z | 0.0        |
| 2016-06-03T09:38:30.000Z | 2.0        |
| 2016-06-03T09:38:40.000Z | 4.0        |
| 2016-06-03T09:38:50.000Z | 4.0        |
| 2016-06-03T09:39:00.000Z | 6.1        |
| 2016-06-03T09:39:10.000Z | 8.1        |
| 2016-06-03T09:39:20.000Z | 7.0        |
| 2016-06-03T09:39:30.000Z | 12.9       |
| 2016-06-03T09:39:40.000Z | 18.8       |
```

## Query with Inner `LINEAR` Interpolation and with `EXTEND` Option

To apply interpolation both to inner periods as well as to leading/trailing periods, include both the `EXTEND` option and an interpolation function in the `PERIOD` clause.

```sql
SELECT datetime, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:37:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY PERIOD(10 second, LINEAR, EXTEND)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-06-03T09:37:00.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:37:10.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:37:20.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:37:30.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:37:40.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:37:50.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:38:00.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:38:10.000Z | 0.0        | + EXTEND -> interpolated with NEXT
| 2016-06-03T09:38:20.000Z | 0.0        |
| 2016-06-03T09:38:30.000Z | 2.0        | + inner  -> interpolated with LINEAR
| 2016-06-03T09:38:40.000Z | 4.0        |
| 2016-06-03T09:38:50.000Z | 4.0        |
| 2016-06-03T09:39:00.000Z | 6.1        | + inner -> interpolated with LINEAR
| 2016-06-03T09:39:10.000Z | 8.1        |
| 2016-06-03T09:39:20.000Z | 7.0        |
| 2016-06-03T09:39:30.000Z | 12.9       | + inner -> interpolated with LINEAR
| 2016-06-03T09:39:40.000Z | 18.8       |
| 2016-06-03T09:39:50.000Z | 18.8       | + EXTEND -> interpolated with PREVIOUS
```

## Query with Inner `VALUE` Interpolation and with `EXTEND` Option

The `VALUE {n}` interpolation function applies both to inner and leading/trailing periods.

```sql
SELECT datetime, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:37:00.000Z' AND datetime < '2016-06-03T09:40:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY PERIOD(10 second, VALUE -10, EXTEND)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-06-03T09:37:00.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:37:10.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:37:20.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:37:30.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:37:40.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:37:50.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:38:00.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:38:10.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
| 2016-06-03T09:38:20.000Z | 0.0        |
| 2016-06-03T09:38:30.000Z | -10.0      | + inner -> interpolated with VALUE -10
| 2016-06-03T09:38:40.000Z | 4.0        |
| 2016-06-03T09:38:50.000Z | 4.0        |
| 2016-06-03T09:39:00.000Z | -10.0      | + inner -> interpolated with VALUE -10
| 2016-06-03T09:39:10.000Z | 8.1        |
| 2016-06-03T09:39:20.000Z | 7.0        |
| 2016-06-03T09:39:30.000Z | -10.0      | + inner -> interpolated with VALUE -10
| 2016-06-03T09:39:40.000Z | 18.8       |
| 2016-06-03T09:39:50.000Z | -10.0      | + EXTEND -> interpolated with VALUE -10
```

## Query with Incomplete Interval

### Data

```ls
series d:2016-07-20T11:08:00.000Z e:e-ext m:m-ext-1=9.4
series d:2016-07-20T11:24:00.000Z e:e-ext m:m-ext-1=5.4
series d:2016-07-20T11:42:00.000Z e:e-ext m:m-ext-1=1.2
series d:2016-07-20T11:42:00.000Z e:e-ext m:m-ext-1=3.0
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-07-20T11:08:00.000Z | 9.4   |
| 2016-07-20T11:24:00.000Z | 5.4   |
| 2016-07-20T11:42:00.000Z | 3.0   |
```

### Complete Interval Specified

Both start and end date are specified in the `WHERE` clause. The `EXTEND` option is applied to both leading and trailing periods.

```sql
SELECT datetime, avg(value)
  FROM "m-ext-1"
WHERE datetime >= '2016-07-20T11:00:00Z' AND datetime < '2016-07-20T12:00:00Z'
  AND entity = 'e-ext'
GROUP BY PERIOD(5 minute, VALUE -10, EXTEND)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-07-20T11:00:00.000Z | -10.0      |
| 2016-07-20T11:05:00.000Z | 9.4        |
| 2016-07-20T11:10:00.000Z | -10.0      |
| 2016-07-20T11:15:00.000Z | -10.0      |
| 2016-07-20T11:20:00.000Z | 5.4        |
| 2016-07-20T11:25:00.000Z | -10.0      |
| 2016-07-20T11:30:00.000Z | -10.0      |
| 2016-07-20T11:35:00.000Z | -10.0      |
| 2016-07-20T11:40:00.000Z | 3.0        |
| 2016-07-20T11:45:00.000Z | -10.0      |
| 2016-07-20T11:50:00.000Z | -10.0      |
| 2016-07-20T11:55:00.000Z | -10.0      |
```

### End Date is not Specified

An end date is **not** specified in the `WHERE` clause. As a result, the `EXTEND` option is **not** applied to trailing periods.

```sql
SELECT datetime, avg(value)
  FROM "m-ext-1"
WHERE datetime >= '2016-07-20T11:00:00Z'
  AND entity = 'e-ext'
GROUP BY PERIOD(5 minute, VALUE -10, EXTEND)
```

```ls
| datetime                 | avg(value) |
|--------------------------|------------|
| 2016-07-20T11:00:00.000Z | -10.0      |
| 2016-07-20T11:05:00.000Z | 9.4        |
| 2016-07-20T11:10:00.000Z | -10.0      |
| 2016-07-20T11:15:00.000Z | -10.0      |
| 2016-07-20T11:20:00.000Z | 5.4        |
| 2016-07-20T11:25:00.000Z | -10.0      |
| 2016-07-20T11:30:00.000Z | -10.0      |
| 2016-07-20T11:35:00.000Z | -10.0      |
| 2016-07-20T11:40:00.000Z | 3.0        |
```
