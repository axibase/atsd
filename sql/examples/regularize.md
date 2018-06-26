# Transforming Unevenly Spaced Series to Regular Series

The **WITH INTERPOLATE** clause provides a way to transform unevenly spaced time series into regularly spaced series.

The underlying transformation calculates values at regular intervals using linear or step interpolation.

Unlike the `GROUP BY PERIOD` clause with the `LINEAR` option, which interpolates missing periods, the `WITH INTERPOLATE` clause operates using raw values. Here is an example in [ChartLab](https://apps.axibase.com/chartlab/471a2a40) that illustrates the difference between interpolating raw and aggregated values.

Similar to the original series, the regularized series can be used in `JOIN` queries, `WHERE` condition, `ORDER BY` and `GROUP BY` clauses.

The regularized timestamps can be aligned to the calendar or to begin with the start of the selection interval.

If the `WHERE` condition includes multiple selection intervals, the interpolation is performed for each interval separately.

## Calculation

The interpolated values are calculated based on two adjacent values.

If a raw value exists at the regularized timestamp, such value is used without modifications irrespective of neighboring values.

### Irregular Series

```ls
| time                 | value |
|----------------------|-------|
| 2016-09-17T08:00:00Z | 3.70  |
| 2016-09-17T08:00:26Z | 4.40  |
| 2016-09-17T08:01:14Z | 9.00  |
| 2016-09-17T08:01:30Z | 2.30  |
```

### Regular `30 SECOND` Series Calculated with the `LINEAR` Function

```ls
| time                 | value |
|----------------------|-------|
| 2016-09-17T08:00:00Z | 3.70  | returned without modifications because raw value is available at 08:00:00Z
| 2016-09-17T08:00:30Z | 4.78  | = 4.4 + (9.0-4.4) * ((00:30-00:26)/(01:14-00:26)) = 4.4 + 4.6*(4/48)  = 4.783
| 2016-09-17T08:01:00Z | 7.66  | = 4.4 + (9.0-4.4) * ((01:00-00:26)/(01:14-00:26)) = 4.4 + 4.6*(34/48) = 7.658
| 2016-09-17T08:01:30Z | 2.30  | returned without modifications because raw value is available at 08:01:30Z
```

### Regular `30 SECOND` Series Calculated with the `PREVIOUS` Function

```ls
| time                 | value |
|----------------------|-------|
| 2016-09-17T08:00:00Z | 3.70  | returned without modifications because raw value is available at 08:00:00Z
| 2016-09-17T08:00:30Z | 4.40  | based on previous value of 4.40 recorded at 08:00:26Z
| 2016-09-17T08:01:00Z | 4.40  | based on previous value of 4.40 recorded at 08:00:26Z
| 2016-09-17T08:01:30Z | 2.30  | returned without modifications because raw value is available at 08:01:30Z
```

## Examples

[![](../images/chartlab.png)](https://apps.axibase.com/chartlab/712f37cb)

![Interpolation Options](../images/regularize_sinusoid.png)

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

### Interpolation Function: `LINEAR`

Values at regular times are linearly interpolated between neighboring values.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR)
```

> A value at 08:00:00 is not returned because there is no prior value in the `INNER` mode to interpolate between it and the value at 08:00:18.
> Values at 08:05:00 and 08:05:30 are not returned because there is no value after 08:04:48 in the `INNER` mode.

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

The boundary parameter `OUTER` retrieves values outside of the selection interval to be used for interpolating leading/trailing values.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER)
```

The prior value outside of the interval, found at 02:00:05, is used to calculate an interpolated value between the outside value and the first raw value within the interval.

The next value outside the interval, found at 23:04:00, is used to interpolate the last value within the interval.

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

### Interpolation Function: `PREVIOUS`

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

### Interpolation Function: `AUTO`

In `AUTO` mode, values are interpolated based on the **Interpolate** setting for each metric separately.

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

### Fill `false`

Missing periods that cannot be interpolated are ignored and not included in the result set.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:01:30Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, FALSE)
```

The value at 08:00:00 is excluded because the prior value in the `INNER` mode is not available for linear interpolation.

```ls
| datetime                 | value  |
|--------------------------|--------|
| no record @08:00:00.000Z |        | - row excluded
| 2016-09-17T08:00:30.000Z |  4.783 |
| 2016-09-17T08:01:00.000Z |  7.658 |
```

### Fill: `NAN`

Missing periods that cannot be interpolated are returned with the `NaN` (Not a Number) value.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:01:30Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, NAN)
```

The value at 08:00:00 is `NaN` because the prior value in the `INNER` mode is not available for linear interpolation.

```ls
| datetime                 | value  |
|--------------------------|--------|
| 2016-09-17T08:00:00.000Z |    NaN |
| 2016-09-17T08:00:30.000Z |  4.783 |
| 2016-09-17T08:01:00.000Z |  7.658 |
```

### Fill: `EXTEND`

Missing periods at the beginning of the selection interval that cannot be interpolated are set to first raw value.

Missing periods at the end of the selection interval that cannot be interpolated are set to last raw value.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:00Z' AND datetime < '2016-09-17T08:06:00Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, INNER, EXTEND)
```

The value at 08:00:00 is set to first raw value at 08:00:18 because the prior value at 02:00:05 is not available in the `INNER` mode.

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

The default `CALENDAR` alignment defines regular timestamps according to the calendar. For example, a 30 second interval starts at 0 seconds each minute. Additionally, a 5 minute interval starts at 0 seconds every 5 minutes, beginning with the 0 minute of the current hour.

#### `CALENDAR`

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:10Z' AND datetime < '2016-09-17T08:01:40Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER, FALSE, CALENDAR)
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-09-17T08:00:30.000Z | 4.783 |
| 2016-09-17T08:01:00.000Z | 7.658 |
| 2016-09-17T08:01:30.000Z | 3.480 |
```

#### `START_TIME`

The `START_TIME` alignment defines regular timestamps according to the start time specified in the query.

```sql
SELECT datetime, value FROM metric1
  WHERE entity = 'e1'
AND datetime >= '2016-09-17T08:00:10Z' AND datetime < '2016-09-17T08:01:40Z'
  WITH INTERPOLATE(30 SECOND, LINEAR, OUTER, FALSE, START_TIME)
```

```ls
| datetime                 | value  |
|--------------------------|--------|
| 2016-09-17T08:00:10.000Z | 10.370 |
| 2016-09-17T08:00:40.000Z | 5.742  |
| 2016-09-17T08:01:10.000Z | 8.617  |
```

### `GROUP BY PERIOD` Compared to `WITH INTERPOLATE`

The `GROUP BY PERIOD()` clause calculates for all values in each period by applying an aggregation function such as average, maximum, first, last etc.

If the period does not have any values, the period is omitted from the results.

An optional `LINEAR` directive for the `GROUP BY PERIOD()` clause changes the default behavior and returns results for missing periods by applying linear interpolation between values of the neighboring periods.

* [ChartLab examples](https://apps.axibase.com/chartlab/471a2a40)

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

The `WITH INTERPOLATE` clause, on the other hand, calculates values at calendar-aligned timestamps using neighboring raw values.

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

If raw values have extra samples recorded within values in each period, such values are ignored.

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

The `WITH INTERPOLATE` transformation is performed first, with regular series subsequently processed by aggregation functions.

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

The `WITH INTERPOLATE` transformation regularizes all series returned by the query to the same timestamps, so that their values can be joined.

Series **t1**. This metric is interpolated with the `PREVIOUS` function.

```sql
SELECT t1.entity, t1.datetime, t1.value
  FROM "meminfo.memfree" t1
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

Series **t2**. This metric is interpolated with the `LINEAR` function.

```sql
SELECT t2.entity, t2.datetime, t2.value
  FROM "mpstat.cpu_busy" t2
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

JOINed series:

```sql
SELECT t1.entity AS "entity", t1.datetime AS "datetime", t1.value AS "cpu", t2.value AS "mem"
  FROM "meminfo.memfree" t1
  JOIN "mpstat.cpu_busy" t2
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

Without interpolation, a join of Series 1 and Series 2 produces an empty result because their row times are different.

### `value` Filter

The `WITH INTERPOLATE` clause modifies how values are compared in the `WHERE` clause.

If the `WITH INTERPOLATE` clause is included in the query, the value condition compares interpolated values instead of raw values.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
```

Raw values:

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-09-18T14:03:38.000Z | 4.0   |
| 2016-09-18T14:03:54.000Z | 3.0   |
| 2016-09-18T14:04:10.000Z | 7.1   |
| 2016-09-18T14:04:26.000Z | 100.0 |
```

Without the `WITH INTERPOLATE` clause, the `WHERE` clause filters raw values.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
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

If the `WITH INTERPOLATE` clause is added, the value filter is applied to the interpolated values instead of raw values.

The following queries produce the same result because `value < 100` is no longer applied to raw values. As such, the sample at 14:04:26 remains in the series for the purpose of interpolation.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-09-18T14:03:30.000Z' AND datetime <= '2016-09-18T14:04:30.000Z'
  AND entity = 'nurswgvml006'
  WITH INTERPOLATE(15 SECOND, LINEAR)
```

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
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

## Time Zone

In CALENDAR alignment and if the period specified is equal or greater than 1 DAY, the interpolated timestamps are set to 00:00 of each day based on the database time zone.
The default time zone can be customized by specifying a [time zone identifier](../../shared/timezone-list.md) or `entity.timeZone` and `metric.timeZone` columns.

* Custom Time Zone

```sql
SELECT entity, value,
  date_format(time, 'yyyy-MM-dd HH:mm z', 'UTC') AS "UTC datetime",
  date_format(time, 'yyyy-MM-dd HH:mm z', 'US/Pacific') AS "Local datetime"
FROM "mpstat.cpu_busy"
  WHERE datetime >= NOW - 2*DAY
WITH INTERPOLATE(1 DAY, LINEAR, INNER, FALSE, CALENDAR, 'US/Pacific')
```

```ls
| entity       | value | UTC datetime         | Local datetime       |
|--------------|-------|----------------------|----------------------|
| nurswgvml007 | 65.5  | 2017-08-17 07:00 UTC | 2017-08-17 00:00 PDT |
| nurswgvml007 | 38.5  | 2017-08-18 07:00 UTC | 2017-08-18 00:00 PDT |
| nurswgvml006 | 33.2  | 2017-08-17 07:00 UTC | 2017-08-17 00:00 PDT |
| nurswgvml006 | 33.3  | 2017-08-18 07:00 UTC | 2017-08-18 00:00 PDT |
```

* Entity or Metric Time Zone

```sql
SELECT entity, entity.timeZone,
  value,
  date_format(time, 'yyyy-MM-dd HH:mm z', 'UTC') AS "UTC datetime",
  date_format(time, 'yyyy-MM-dd HH:mm z', entity.timeZone) AS "Local datetime"
FROM "mpstat.cpu_busy"
  WHERE datetime >= NOW - 2*DAY
WITH INTERPOLATE(1 DAY, LINEAR, INNER, FALSE, CALENDAR, entity.timeZone)
```

```ls
| entity       | entity.timeZone | value | UTC datetime         | Local datetime       |
|--------------|-----------------|-------|----------------------|----------------------|
| nurswgvml007 | PST             | 65.5  | 2017-08-17 07:00 UTC | 2017-08-17 00:00 PDT |
| nurswgvml007 | PST             | 38.5  | 2017-08-18 07:00 UTC | 2017-08-18 00:00 PDT |
| nurswgvml006 | US/Mountain     | 31.1  | 2017-08-17 06:00 UTC | 2017-08-17 00:00 MDT |
| nurswgvml006 | US/Mountain     | 3.0   | 2017-08-18 06:00 UTC | 2017-08-18 00:00 MDT |
| nurswgvml010 | null            | 0.4   | 2017-08-17 00:00 UTC | 2017-08-17 00:00 GMT |
| nurswgvml010 | null            | 22.5  | 2017-08-18 00:00 UTC | 2017-08-18 00:00 GMT |
```

## Multiple Intervals

If the `WHERE` condition includes multiple selection intervals, the interpolation is performed for each interval separately.
The values between those intervals are **NOT** interpolated.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND (datetime BETWEEN '2016-09-18T14:00:00Z' AND '2016-09-18T14:01:00Z'
    OR datetime BETWEEN '2016-09-18T14:04:00Z' AND '2016-09-18T14:05:00Z')
  WITH INTERPOLATE(15 SECOND)
```

```ls
| datetime             | value |
|----------------------|-------|
| 2016-09-18T14:00:00Z | 40.0  | [14:00-14:01] interval START
| 2016-09-18T14:00:15Z | 93.5  |
| 2016-09-18T14:00:30Z | 63.4  |
| 2016-09-18T14:00:45Z | 14.8  |
| 2016-09-18T14:01:00Z | 12.0  | [14:00-14:01] interval END
... no values interpolated between the two intervals ...
| 2016-09-18T14:04:00Z | 4.6   | [14:04-14:05] interval START
| 2016-09-18T14:04:15Z | 36.2  |
| 2016-09-18T14:04:30Z | 100.0 |
| 2016-09-18T14:04:45Z | 82.4  |
| 2016-09-18T14:05:00Z | 5.8   | [14:04-14:05] interval END
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
