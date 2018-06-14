# Counter Aggregator

## Overview

The `COUNTER` and `DELTA` functions calculate the difference between values within the given period.

The functions returns the sum of the differences between consecutive values in the period. The starting (first) value is the last value from the previous period, if available.

### `COUNTER` function

```javascript
SUM (v(i) - v(i-1) < 0 ? v(i) : v(i) - v(i-1))
```

If the difference between two values is negative, the difference is replaced with the second value itself.

```ls
| value | counter | delta |
|-------|---------|-------|
| 10    | 0       | 0     |
| 20    | 10      | 10    |
| 3     | 3       | -17   |
| 15    | 12      | 12    |
| ===== | ======= | ===== |
| -     | 25      | 5     |
```

### `DELTA` function

```javascript
SUM (v(i) - v(i-1))
```

If the difference between values is always non-negative, the `DELTA` aggregator produces the same result as the `COUNTER` aggregator.

View [ChartLab](https://apps.axibase.com/chartlab/2f607d1b/17/) examples illustrating the difference between the functions.

## Query - Detailed

```sql
SELECT datetime, count(value), max(value), first(value), last(value), counter(value), delta(value)
  FROM log_event_total_counter
WHERE entity = 'nurswgvml201' AND tags.level = 'ERROR'
  AND datetime >= '2015-09-30T09:00:00Z' AND datetime < '2015-09-30T10:00:00Z'
GROUP BY period(5 minute)
```

## Results

```ls
| datetime                 | count(value) | max(value) | first(value) | last(value) | counter(value) | delta(value) |
|--------------------------|-------------:|-----------:|-------------:|------------:|----------------|--------------|
| 2015-09-30T09:00:00.000Z | 5.0          | 3.0        | 2.0          | 3.0         | 1.0            | 1.0          |
| 2015-09-30T09:05:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 0.0            | 0.0          |
| 2015-09-30T09:10:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 0.0            | 0.0          |
| 2015-09-30T09:15:00.000Z | 6.0          | 5.0        | 2.0          | 5.0         | 5.0            | 2.0          |
| 2015-09-30T09:20:00.000Z | 5.0          | 8.0        | 7.0          | 8.0         | 3.0            | 3.0          |
| 2015-09-30T09:25:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 3.0            | -5.0         |
| 2015-09-30T09:30:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 0.0            | 0.0          |
| 2015-09-30T09:35:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 0.0            | 0.0          |
| 2015-09-30T09:40:00.000Z | 10.0         | 1803.0     | 3.0          | 1803.0      | 1800.0         | 1800.0       |
| 2015-09-30T09:45:00.000Z | 5.0          | 1806.0     | 1803.0       | 1806.0      | 3.0            | 3.0          |
| 2015-09-30T09:50:00.000Z | 4.0          | 3.0        | 3.0          | 3.0         | 3.0            | -1803.0      |
| 2015-09-30T09:55:00.000Z | 5.0          | 3.0        | 2.0          | 3.0         | 3.0            | 0.0          |
```

## Detailed Values

```ls
| datetime                 | value  |
|--------------------------|--------|
| 2015-09-30T09:00:05.869Z | 2.0    |
| 2015-09-30T09:00:17.860Z | 3.0    |
| 2015-09-30T09:00:28.195Z | 3.0    |
| 2015-09-30T09:00:33.526Z | 3.0    |
| 2015-09-30T09:00:38.858Z | 3.0    |
| 2015-09-30T09:05:32.217Z | 3.0    |
| 2015-09-30T09:06:00.211Z | 3.0    |
| 2015-09-30T09:07:00.321Z | 3.0    |
| 2015-09-30T09:08:00.353Z | 3.0    |
| 2015-09-30T09:10:36.214Z | 3.0    |
| 2015-09-30T09:11:36.503Z | 3.0    |
| 2015-09-30T09:12:36.836Z | 3.0    |
| 2015-09-30T09:13:36.901Z | 3.0    |
| 2015-09-30T09:15:01.917Z | 2.0    |
| 2015-09-30T09:15:30.948Z | 3.0    |
| 2015-09-30T09:15:36.279Z | 3.0    |
| 2015-09-30T09:16:36.369Z | 3.0    |
| 2015-09-30T09:17:36.454Z | 3.0    |
| 2015-09-30T09:19:36.559Z | 5.0    |
| 2015-09-30T09:20:05.540Z | 7.0    |
| 2015-09-30T09:20:10.547Z | 8.0    |
| 2015-09-30T09:20:15.565Z | 8.0    |
| 2015-09-30T09:20:20.571Z | 8.0    |
| 2015-09-30T09:20:25.578Z | 8.0    |
| 2015-09-30T09:25:32.833Z | 3.0    |
| 2015-09-30T09:26:03.818Z | 3.0    |
| 2015-09-30T09:27:04.143Z | 3.0    |
| 2015-09-30T09:28:04.438Z | 3.0    |
| 2015-09-30T09:30:13.153Z | 3.0    |
| 2015-09-30T09:30:34.830Z | 3.0    |
| 2015-09-30T09:31:34.965Z | 3.0    |
| 2015-09-30T09:32:35.065Z | 3.0    |
| 2015-09-30T09:35:32.089Z | 3.0    |
| 2015-09-30T09:36:00.095Z | 3.0    |
| 2015-09-30T09:37:00.125Z | 3.0    |
| 2015-09-30T09:38:00.437Z | 3.0    |
| 2015-09-30T09:40:06.418Z | 3.0    |
| 2015-09-30T09:40:11.748Z | 3.0    |
| 2015-09-30T09:40:16.778Z | 3.0    |
| 2015-09-30T09:40:22.108Z | 3.0    |
| 2015-09-30T09:43:35.007Z | 93.0   |
| 2015-09-30T09:43:40.023Z | 453.0  |
| 2015-09-30T09:43:45.044Z | 903.0  |
| 2015-09-30T09:43:50.375Z | 1399.0 |
| 2015-09-30T09:43:55.707Z | 1803.0 |
| 2015-09-30T09:44:55.744Z | 1803.0 |
| 2015-09-30T09:45:01.407Z | 1803.0 |
| 2015-09-30T09:45:06.740Z | 1806.0 |
| 2015-09-30T09:45:34.740Z | 1806.0 |
| 2015-09-30T09:46:35.064Z | 1806.0 |
| 2015-09-30T09:47:35.398Z | 1806.0 |
| 2015-09-30T09:50:33.322Z | 3.0    |
| 2015-09-30T09:51:03.995Z | 3.0    |
| 2015-09-30T09:52:04.000Z | 3.0    |
| 2015-09-30T09:53:04.009Z | 3.0    |
| 2015-09-30T09:55:04.351Z | 2.0    |
| 2015-09-30T09:55:34.683Z | 3.0    |
| 2015-09-30T09:56:34.718Z | 3.0    |
| 2015-09-30T09:57:35.040Z | 3.0    |
| 2015-09-30T09:58:35.257Z | 3.0    |
```

## Query - Filtered

If the rows are filtered in the `WHERE` condition such that intermediate periods are empty, the first (starting) value is obtained from the most recent period preceding the current period.

In the example below, the first value is the last value of the previous Sunday.

```sql
SELECT datetime, date_format(time, 'EEEE') AS "day-of-week",
  min(value), max(value), max(value)- min(value) AS "max-min", first(value), last(value), last(value)-first(value) AS "last-first", delta(value)
FROM "so.tags.count"
WHERE entity = 'stackoverflow-python'
  AND datetime >= '2017-01-01T00:00:00Z' and datetime < '2017-02-06T00:00:00.000Z'
  AND date_format(time, 'EEEE') = 'Sunday'
GROUP BY period(1 day)
  --HAVING date_format(time, 'EEEE') = 'Sunday'
```

## Results

```ls
| datetime             | day-of-week | min(value) | max(value) | max-min | first(value) | last(value) | last-first | delta(value) |
|----------------------|-------------|------------|------------|---------|--------------|-------------|------------|--------------|
| 2017-01-01T00:00:00Z | Sunday      | 677557     | 677798     | 241     | 677557       | 677798      | 241        | 241          |
| 2017-01-08T00:00:00Z | Sunday      | 680671     | 681048     | 377     | 680671       | 681048      | 377        | 3250         |
| 2017-01-15T00:00:00Z | Sunday      | 684065     | 684449     | 384     | 684065       | 684449      | 384        | 3401         |
| 2017-01-22T00:00:00Z | Sunday      | 687657     | 688064     | 407     | 687657       | 688064      | 407        | 3615         |
| 2017-01-29T00:00:00Z | Sunday      | 690772     | 691213     | 441     | 690772       | 691213      | 441        | 3149         |
| 2017-02-05T00:00:00Z | Sunday      | 694730     | 695097     | 367     | 694730       | 695097      | 367        | 3884         |
```

The same query where filtering is applied to grouped rows (by period) produces daily differences since the first value used by the `DELTA` function is the last value of the previous day.

```sql
SELECT datetime, date_format(time, 'EEEE') AS "day-of-week",
  min(value), max(value), max(value)- min(value) AS "max-min", first(value), last(value), last(value)-first(value) AS "last-first", delta(value)
FROM "so.tags.count"
WHERE entity = 'stackoverflow-python'
  AND datetime >= '2017-01-01T00:00:00Z' and datetime < '2017-02-06T00:00:00.000Z'
  --AND date_format(time, 'EEEE') = 'Sunday'
GROUP BY period(1 day)
  HAVING date_format(time, 'EEEE') = 'Sunday'
```

## Results

```ls
| datetime             | day-of-week | min(value) | max(value) | max-min | first(value) | last(value) | last-first | delta(value) |
|----------------------|-------------|------------|------------|---------|--------------|-------------|------------|--------------|
| 2017-01-01T00:00:00Z | Sunday      | 677557     | 677798     | 241     | 677557       | 677798      | 241        | 241          |
| 2017-01-08T00:00:00Z | Sunday      | 680671     | 681048     | 377     | 680671       | 681048      | 377        | 403          |
| 2017-01-15T00:00:00Z | Sunday      | 684065     | 684449     | 384     | 684065       | 684449      | 384        | 403          |
| 2017-01-22T00:00:00Z | Sunday      | 687657     | 688064     | 407     | 687657       | 688064      | 407        | 423          |
| 2017-01-29T00:00:00Z | Sunday      | 690772     | 691213     | 441     | 690772       | 691213      | 441        | 458          |
| 2017-02-05T00:00:00Z | Sunday      | 694730     | 695097     | 367     | 694730       | 695097      | 367        | 385          |
```
