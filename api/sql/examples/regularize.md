# Transforming Unevenly Space Series to Regular Serieszzzz

**WITH INTERPOLATE** clause provides a way to transform unevenly spaced time series into regular series.

The underlying transformation calculates values at regular intervals using linear or step interpolation. 

Unlike `GROUP BY PERIOD` clause with `LINEAR` option, which interpolates missing periods, `WITH INTERPOLATE` clause operates on raw values.

Refer to an example in [Chartlab](https://apps.axibase.com/chartlab/471a2a40) that illustrates the difference between interpolating raw and aggregated values.

The regularized series can be used in `JOIN` queries, `WHERE` condition, `ORDER BY` and `GROUP BY` clauses just like the original series.

The regular times can be aligned to the server calendar or begin with the start of the selection interval.

## Calculation

The interpolated values are calculated based on two adjacent values. 

Irregular series:

```ls
| time                 | value | 
|----------------------|-------| 
| 2016-09-17T08:00:00Z | 3.70  |
| 2016-09-17T08:00:26Z | 4.40  |
| 2016-09-17T08:01:14Z | 9.00  |
| 2016-09-17T08:01:30Z | 2.30  |
```

Regular `30 SECOND` series calculated with `LINEAR` function:

```ls
| time                 | value | 
|----------------------|-------| 
| 2016-09-17T08:00:00Z | 3.70  | returned "as is" because raw value is available at 08:00:00Z
| 2016-09-17T08:00:30Z | 4.78  | = 4.4 + (9.0-4.4) * ((00:30-00:26)/(01:14-00:26)) = 4.4 + 4.6*(4/48)  = 4.783
| 2016-09-17T08:01:00Z | 7.66  | = 4.4 + (9.0-4.4) * ((01:00-00:26)/(01:14-00:26)) = 4.4 + 4.6*(34/48) = 7.658
| 2016-09-17T08:01:30Z | 2.30  | returned "as is" because raw value is available at 08:01:30Z
```

Regular `30 SECOND` series calculated with `PREVIOUS` function:

```ls
| time                 | value | 
|----------------------|-------| 
| 2016-09-17T08:00:00Z | 3.70  | returned "as is" because raw value is available at 08:00:00Z
| 2016-09-17T08:00:30Z | 4.40  | based on previous value of 4.40 recorded at 08:00:26Z
| 2016-09-17T08:01:00Z | 4.40  | based on previous value of 4.40 recorded at 08:00:26Z
| 2016-09-17T08:01:30Z | 2.30  | returned "as is" because raw value is available at 08:01:30Z
```

## Examples

* [Chartlab examples](https://apps.axibase.com/chartlab/8ffeda09)

![Interpolation Options](../images/interpolation_modes.png)

### Raw Values

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
  AND datetime >= '2016-09-16T00:00:00Z' AND datetime < '2016-09-18T00:00:00Z'
```

```ls
| datetime                 | value   | 
|--------------------------|---------| 
| 2016-09-17T00:00:00.000Z |   4.500 | 
| 2016-09-17T01:23:11.000Z |     NaN | 
| 2016-09-17T02:00:05.000Z | -70.000 | 
| 2016-09-17T08:00:18.000Z |  10.400 | 
| 2016-09-17T08:00:26.000Z |   4.400 | 
| 2016-09-17T08:01:14.000Z |   9.000 | 
| 2016-09-17T08:01:34.000Z |   2.100 | 
| 2016-09-17T08:01:52.000Z |  26.500 | 
| 2016-09-17T08:02:10.000Z |   0.000 | 
| 2016-09-17T08:03:00.000Z |   7.700 | 
| 2016-09-17T08:04:48.000Z |   6.600 | 
| 2016-09-17T23:04:00.000Z | -23.400 | 
```

### Interpolation Function: LINEAR

Values at regular times are linearly interpolated between neighboring values.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR)
```

> Value at 08:00:00 is not returned because there is no prior value  in `INNER` mode to interpolate between it and value at 08:00:18.

> Values at 08:05:00 and 08:05:30 are not returned because there is no value after 08:04:48 in `INNER` mode.

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| 2016-09-17T08:00:30.000Z |  4.783 | 
| 2016-09-17T08:01:00.000Z |  7.658 | 
| 2016-09-17T08:01:30.000Z |  3.480 | 
| 2016-09-17T08:02:00.000Z | 14.722 | 
| 2016-09-17T08:02:30.000Z |  3.080 | 
| 2016-09-17T08:03:00.000Z |  7.700 | 
| 2016-09-17T08:03:30.000Z |  7.394 | 
| 2016-09-17T08:04:00.000Z |  7.089 | 
| 2016-09-17T08:04:30.000Z |  6.783 |
```

Boundary parameter `OUTER` retrieves values outside of the selection interval to be used for interpolating leading/trailing values.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER)
```

Prior value outside of the interval, found at 02:00:05, is used to calculate an interpolated value between the outside value and the first raw value within the interval. 

Next value outside the interval, found at 23:04:00, is used to interpolate last value within the interval.

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| 2016-09-17T08:00:00.000Z | 10.333 | - interpolated between values at 02:00:05 and 08:00:26
| 2016-09-17T08:00:30.000Z |  4.783 | 
| 2016-09-17T08:01:00.000Z |  7.658 | 
| 2016-09-17T08:01:30.000Z |  3.480 | 
| 2016-09-17T08:02:00.000Z | 14.722 | 
| 2016-09-17T08:02:30.000Z |  3.080 | 
| 2016-09-17T08:03:00.000Z |  7.700 | 
| 2016-09-17T08:03:30.000Z |  7.394 | 
| 2016-09-17T08:04:00.000Z |  7.089 | 
| 2016-09-17T08:04:30.000Z |  6.783 | 
| 2016-09-17T08:05:00.000Z |  6.593 | - interpolated between values at 08:04:48 and 23:04:00
| 2016-09-17T08:05:30.000Z |  6.577 | - interpolated between values at 08:04:48 and 23:04:00
```

### Interpolation Function: PREVIOUS

Values at regular times are set to the previous value.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, PREVIOUS, OUTER)
```

```ls
| datetime                 | value   | 
|--------------------------|---------| 
| 2016-09-17T08:00:00.000Z | -70.000 | - set to previous value at 02:00:05
| 2016-09-17T08:00:30.000Z |   4.400 | - set to previous value at 08:00:26
| 2016-09-17T08:01:00.000Z |   4.400 | 
| 2016-09-17T08:01:30.000Z |   9.000 | 
| 2016-09-17T08:02:00.000Z |  26.500 | 
| 2016-09-17T08:02:30.000Z |   0.000 | 
| 2016-09-17T08:03:00.000Z |   7.700 | 
| 2016-09-17T08:03:30.000Z |   7.700 | 
| 2016-09-17T08:04:00.000Z |   7.700 | 
| 2016-09-17T08:04:30.000Z |   7.700 | 
| 2016-09-17T08:05:00.000Z |   6.600 | - set to previous value at 08:04:48
| 2016-09-17T08:05:30.000Z |   6.600 | - set to previous value at 08:04:48
```

### Interpolation Function: AUTO

In `AUTO` mode, values are interpolated based on **Interpolate** setting for each metric separately.

* metric1 **Interpolate** setting: `LINEAR`
* metric2 **Interpolate** setting: `PREVIOUS`

```sql
SELECT metric, datetime, value FROM atsd_series 
  WHERE metric IN ('metric1', 'metric2')
AND entity = 'e1'
  AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:01:30Z'
WITH INTERPOLATE(30 SECOND, AUTO, OUTER)
  ORDER BY metric
```

```ls
| metric  | datetime                 | value   | 
|---------|--------------------------|---------| 
| metric1 | 2016-09-17T08:00:00.000Z | 10.333  | - interpolated with LINEAR
| metric1 | 2016-09-17T08:00:30.000Z | 4.783   | - interpolated with LINEAR
| metric1 | 2016-09-17T08:01:00.000Z | 7.658   | - interpolated with LINEAR
| metric2 | 2016-09-17T08:00:00.000Z | -70.000 | - interpolated with PREVIOUS
| metric2 | 2016-09-17T08:00:30.000Z | 4.400   | - interpolated with PREVIOUS
| metric2 | 2016-09-17T08:01:00.000Z | 4.400   | - interpolated with PREVIOUS
```

### Fill: NONE

Missing periods that cannot be interpolated are ignored and not included in the resultset.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:01:30Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, NONE)
```

Value at 08:00:00 because prior value in `INNER` mode was no available for linear interpolation.

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| no record @08:00:00.000Z |        | - row excluded
| 2016-09-17T08:00:30.000Z |  4.783 | 
| 2016-09-17T08:01:00.000Z |  7.658 | 
```

### Fill: NAN

Missing periods that cannot be interpolated are returned with `NaN` (Not a Number) value.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:01:30Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, NONE)
```

Value at 08:00:00 because prior value in `INNER` mode was no available for linear interpolation.

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| 2016-09-17T08:00:00.000Z |    NaN | 
| 2016-09-17T08:00:30.000Z |  4.783 | 
| 2016-09-17T08:01:00.000Z |  7.658 | 
```

### Fill: EXTEND

Missing periods at the beginning of the selection interval that cannot be interpolated are set to first raw value.

Missing periods at the end of the selection interval that cannot be interpolated are set to last raw value.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, EXTEND)
```

Value at 08:00:00 because prior value in `INNER` mode was no available for linear interpolation.

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| 2016-09-17T08:00:00.000Z | 10.400 | - set as first raw value at 08:00:18
| 2016-09-17T08:00:30.000Z |  4.783 | 
| 2016-09-17T08:01:00.000Z |  7.658 | 
...
| 2016-09-17T08:04:30.000Z |  6.783 | 
| 2016-09-17T08:05:00.000Z |  6.600 | - set as last raw value at 08:04:48
| 2016-09-17T08:05:30.000Z |  6.600 | - set as last raw value at 08:04:48
```

### Alignment

The default `CALENDAR` alignment defines regular timestamps according to the calendar, for example, a 30 second interval starts at 0 seconds each minute, and 5 minute start at 0 seconds every 5 minutes starting with 0 minute of the current hour.

#### `CALENDAR`

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:10Z' AND datetime < '2016-09-17T08:01:40Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER, NONE, CALENDAR)
```

```ls
| datetime                 | value | 
|--------------------------|-------| 
| 2016-09-17T08:00:30.000Z | 4.783 | 
| 2016-09-17T08:01:00.000Z | 7.658 | 
| 2016-09-17T08:01:30.000Z | 3.480 | 
```

#### `START_TIME`

`START_TIME` alignment defines regular timestamps according to the start time specified in the query.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:10Z' AND datetime < '2016-09-17T08:01:40Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER, NONE, START_TIME)
```

```ls
| datetime                 | value  | 
|--------------------------|--------| 
| 2016-09-17T08:00:10.000Z | 10.370 | 
| 2016-09-17T08:00:40.000Z | 5.742  |
| 2016-09-17T08:01:10.000Z | 8.617  |
```

### `GROUP BY PERIOD` compared to `WITH INTERPOLATE`

The `GROUP BY PERIOD()` clause calculates value for all values in each period by applying an aggregation function such as average, maximum, first, last etc.

If the period doesn't have any values, the period is omitted from results.

An optional `LINEAR` directive for `GROUP BY PERIOD()` clause changes the default behavior and returns results missing periods by applying linear interpolation between values of the neighboring periods.

* [Chartlab examples](https://apps.axibase.com/chartlab/471a2a40)

![Interpolation Options](../images/aggregation_vs_interpolation.png)

#### Data

```ls
| datetime                 | value   | 
|--------------------------|---------| 
| 2016-09-17T02:00:05.000Z | -70.000 | 
| 2016-09-17T08:00:18.000Z |  10.400 | 
| 2016-09-17T08:00:26.000Z |   4.400 | 
| 2016-09-17T08:01:14.000Z |   9.000 | 
| 2016-09-17T08:01:34.000Z |   2.100 | 
```

#### `GROUP BY PERIOD`

```sql
SELECT datetime, first(value), last(value), avg(value) FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:02:00Z'
  GROUP BY PERIOD(30 SECOND, LINEAR)
```

```ls
| datetime                 | first(value) | last(value) | avg(value) | 
|--------------------------|--------------|-------------|------------| 
| 2016-09-17T08:00:00.000Z | 10.40        |  4.40       |  7.40      | -- The period has 2 values. Set to first value at 08:00:18, last value at 08:00:26 or using an aggregation function such as average
| 2016-09-17T08:00:30.000Z |  9.70        |  6.70       |  8.20      | -- The period has no values. Linearly interpolated between 08:00:00 and 08:01:00; 10.40 + (9.00-10.40)* 30sec/60sec = 9.70
| 2016-09-17T08:01:00.000Z |  9.00        |  9.00       |  9.00      | -- The period has only 1 record. last(), first(), and avg() return the same result.
| 2016-09-17T08:01:30.000Z |  2.10        | 26.50       | 14.30      | -- The period has 2 values, calculated similar to period starting 08:00:00.
```

#### `WITH INTERPOLATE`

`WITH INTERPOLATE` clause, on the other hand, calculates values at calendar-aligned timestamps using neighboring raw values.


```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:02:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER)
```

```ls
| datetime                 | value | 
|--------------------------|-------| 
| 2016-09-17T08:00:00.000Z | 10.33 | -- Linearly interpolated between prior value of -70 at 02:00:05 and first value of 10.40 at 08:00:18.
| 2016-09-17T08:00:30.000Z |  4.78 | -- Linearly interpolated between 4.40 at 08:00:26 and 9.00 at 08:01:14.
| 2016-09-17T08:01:00.000Z |  7.66 | -- Linearly interpolated between 4.40 at 08:00:26 and 9.00 at 08:01:14.
| 2016-09-17T08:01:30.000Z |  3.48 | -- Linearly interpolated between 9.00 at 08:01:14 and 2.10 at 08:01:34.
```

If raw values had extra samples recorded within values in each period, such values would be ignored.

```ls
| time     | value   | 
|----------|---------| 
| 08:00:18 |   10.40 | -- used to interpolate value at 08:00:00 between 02:00:05 and 08:00:18
| 08:00:19 |  100.50 | -- ignored
| 08:00:20 |  200.40 | -- ignored
| 08:00:21 |  400.10 | -- ignored
| 08:00:22 |  600.20 | -- ignored
| 08:00:23 | -100.30 | -- ignored
| 08:00:24 |     0.0 | -- ignored
| 08:00:25 |    10.3 | -- ignored
| 08:00:26 |    4.40 | -- used to interpolate value at 08:00:30 between 08:00:26 and 08:01:14
```

### Combination

#### `GROUP BY` Example

The interpolation and `GROUP BY` clauses can be combined. 

`WITH INTERPOLATE` transformation is performed first, with regular series subsequently processed by aggregation functions. 

```sql
SELECT datetime, count(value), avg(value) FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:02:00Z'
  GROUP BY PERIOD (60 SECOND)
WITH INTERPOLATE(30 SECOND, LINEAR, OUTER)
```

```ls
| datetime                 | count(value) | avg(value) | 
|--------------------------|--------------|------------| 
| 2016-09-17T08:00:00.000Z | 2.000        | 7.558      | 
| 2016-09-17T08:01:00.000Z | 2.000        | 5.569      | 
```

#### `JOIN` Example 

`WITH INTERPOLATE` transformation regularizes all series returned by the query to the same timestamps so that their values can be joined.

Series **t1**. This series is interpolated with `PREVIOUS` function.

```sql
SELECT t1.entity, t1.datetime, t1.value
  FROM meminfo.memfree t1
WHERE t1.datetime >= '2016-09-18T14:00:00.000Z' AND t1.datetime < '2016-09-18T14:01:00.000Z'
  AND t1.entity = 'nurswgvml006'
```

```ls
| t1.entity    | t1.datetime              | t1.value | 
|--------------|--------------------------|----------| 
| nurswgvml006 | 2016-09-18T14:00:06.000Z | 75336.0  | 
| nurswgvml006 | 2016-09-18T14:00:21.000Z | 71260.0  | 
| nurswgvml006 | 2016-09-18T14:00:36.000Z | 68904.0  | 
| nurswgvml006 | 2016-09-18T14:00:51.000Z | 68156.0  | 
```

Series **t2**. This series is interpolated with `LINEAR` function.

```sql
SELECT t2.entity, t2.datetime, t2.value
  FROM mpstat.cpu_busy t2
WHERE t2.datetime >= '2016-09-18T14:00:00.000Z' AND t2.datetime < '2016-09-18T14:01:00.000Z'
  AND t2.entity = 'nurswgvml006'
```

```ls
| t2.entity    | t2.datetime              | t2.value | 
|--------------|--------------------------|----------| 
| nurswgvml006 | 2016-09-18T14:00:10.000Z | 100.0    | 
| nurswgvml006 | 2016-09-18T14:00:26.000Z | 79.2     | 
| nurswgvml006 | 2016-09-18T14:00:42.000Z | 16.2     | 
| nurswgvml006 | 2016-09-18T14:00:58.000Z | 9.0      | 
```

JOINed multi-variate series:

```sql
SELECT t1.entity AS 'entity', t1.datetime AS 'datetime', t1.value as 'cpu', t2.value as 'mem'
  FROM meminfo.memfree t1
  JOIN mpstat.cpu_busy t2
WHERE t1.datetime >= '2016-09-18T14:00:00.000Z' AND t1.datetime < '2016-09-18T14:01:00.000Z'
AND t1.entity = 'nurswgvml006'
  WITH INTERPOLATE(15 SECOND, AUTO)
```

```ls
| entity       | datetime                 | cpu     | mem  | 
|--------------|--------------------------|---------|------| 
| nurswgvml006 | 2016-09-18T14:00:15.000Z | 75336.0 | 93.5 | 
| nurswgvml006 | 2016-09-18T14:00:30.000Z | 71260.0 | 63.4 | 
| nurswgvml006 | 2016-09-18T14:00:45.000Z | 68904.0 | 14.8 | 
```

Without interpolation, a join of Series 1 and Series 2 would have produced an empty result because their raw times are different.

### `value` Filter

value condition in `WHERE` clause is applied to interpolated values.

```sql
SELECT datetime, value
  FROM mpstat.cpu_busy
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
```

```ls
| datetime                 | value | 
|--------------------------|-------| 
| 2016-09-18T14:03:38.000Z | 4.0   | 
| 2016-09-18T14:03:54.000Z | 3.0   | 
| 2016-09-18T14:04:10.000Z | 7.1   | 
| 2016-09-18T14:04:26.000Z | 100.0 | 
```

Without `INTERPOLATE` raw values can be filtered out with `value` condition as usual.

```sql
SELECT datetime, value
  FROM mpstat.cpu_busy
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
  AND value < 100
```

```ls
| datetime                 | value | 
|--------------------------|-------| 
| 2016-09-18T14:03:38.000Z | 4.0   | 
| 2016-09-18T14:03:54.000Z | 3.0   | 
| 2016-09-18T14:04:10.000Z | 7.1   | 
```

Once `INTERPOLATE` clause is added, the value filter is applied to interpolated values instead of raw values.

The following queries produce the same result because `value < 100` is no longer applied to raw values and as such sample at 14:04:26 remains in the series for the purpose of interpolation.

```sql
SELECT datetime, value
  FROM mpstat.cpu_busy
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
  WITH INTERPOLATE(15 SECOND, LINEAR)
```

```sql
SELECT datetime, value
  FROM mpstat.cpu_busy
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
AND value < 100
  WITH INTERPOLATE(15 SECOND, LINEAR)
```

The above queries return the same result:

```ls
| datetime                 | value | 
|--------------------------|-------| 
| 2016-09-18T14:03:45.000Z | 3.6   | 
| 2016-09-18T14:04:00.000Z | 4.6   | 
| 2016-09-18T14:04:15.000Z | 36.2  | 
```

### Input Commands

```ls
series e:e1   m:metric1=4.5 d:2016-09-17T00:00:00Z
series e:e1   m:metric1=NaN d:2016-09-17T01:23:11Z
series e:e1 m:metric1=-70.0 d:2016-09-17T02:00:05Z
series e:e1  m:metric1=10.4 d:2016-09-17T08:00:18Z
series e:e1   m:metric1=4.4 d:2016-09-17T08:00:26Z
series e:e1   m:metric1=9.0 d:2016-09-17T08:01:14Z
series e:e1   m:metric1=2.1 d:2016-09-17T08:01:34Z
series e:e1  m:metric1=26.5 d:2016-09-17T08:01:52Z
series e:e1   m:metric1=0.0 d:2016-09-17T08:02:10Z
series e:e1   m:metric1=7.7 d:2016-09-17T08:03:00Z
series e:e1   m:metric1=6.6 d:2016-09-17T08:04:48Z
series e:e1 m:metric1=-23.4 d:2016-09-17T23:04:00Z

series e:e2  m:metric1=10.4 d:2016-09-17T01:23:11Z

series e:e3   m:metric1=1.0 d:2016-09-17T01:01:00Z
series e:e3   m:metric1=NaN d:2016-09-17T01:03:00Z
series e:e3   m:metric1=4.0 d:2016-09-17T01:04:00Z

series e:e1 m:metric2=-70.0 d:2016-09-17T02:00:05Z
series e:e1  m:metric2=10.4 d:2016-09-17T08:00:18Z
series e:e1   m:metric2=4.4 d:2016-09-17T08:00:26Z
series e:e1   m:metric2=9.0 d:2016-09-17T08:01:14Z
series e:e1   m:metric2=2.1 d:2016-09-17T08:01:34Z
```



