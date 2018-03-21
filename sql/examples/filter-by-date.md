# Filter by Date

## Query with ISO-8601 format

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= '2016-06-18T20:00:00Z' AND datetime < '2016-06-18T21:00:00.000Z'
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-18T20:00:11.000Z | 28.0  |
| 2016-06-18T20:00:27.000Z | 6.1   |
| 2016-06-18T20:00:43.000Z | 6.1   |
```

## Query with Local format

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= '2016-06-18 20:00:00' AND datetime < '2016-06-18 21:00:00.000'
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-18T20:00:11.000Z | 28.0  |
| 2016-06-18T20:00:27.000Z | 6.1   |
| 2016-06-18T20:00:43.000Z | 6.1   |
```

## Query with Lower Limit

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= '2017-04-04T17:07:00Z'
LIMIT 5
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-04T17:07:04Z | 0.0   |
| 2017-04-04T17:07:20Z | 2.0   |
| 2017-04-04T17:07:36Z | 7.1   |
| 2017-04-04T17:07:52Z | 90.9  |
| 2017-04-04T17:08:08Z | 3.0   |
```

## Query with Milliseconds

```sql
SELECT time, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND time >= 1466100000000 AND time < 1466200000000
```

```ls
| time          | value |
|---------------|-------|
| 1466100003000 | 37.2  |
| 1466100019000 | 3.1   |
| 1466100035000 | 4.0   |
```

## Query with Endtime Syntax

Both `time` and `datetime` columns support [calendar](../../shared/calendar.md) keywords.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= PREVIOUS_HOUR
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-18T20:00:11.000Z | 28.0  |
| 2016-06-18T20:00:27.000Z | 6.1   |
| 2016-06-18T20:00:43.000Z | 6.1   |
```

## Query with Endtime Syntax

[Calendar](../../shared/calendar.md) keywords are calculated based on the current server time and the server's [time zone](../../shared/timezone-list.md).

If the server's time zone is `Europe/Berlin`, for example, the `current_day` keyword in the below query is evaluated to `2017-04-15T00:00:00+02:00` local time or `2017-04-14T22:00:00Z` UTC time.

```sql
SELECT datetime, date_format(time, 'yyyy-MM-dd''T''HH:mm:ssZZ') AS local_datetime, value
  FROM m1
WHERE datetime >= current_day
```

```ls
| datetime             | local_datetime            | value |
|----------------------|---------------------------|-------|
| 2017-04-14T22:00:00Z | 2017-04-15T00:00:00+02:00 | 22    | <- midnight in local server timezone: UTC+02:00
| 2017-04-14T23:00:00Z | 2017-04-15T01:00:00+02:00 | 23    |
| 2017-04-15T00:00:00Z | 2017-04-15T02:00:00+02:00 | 0     |
| 2017-04-15T01:00:00Z | 2017-04-15T03:00:00+02:00 | 1     |
| 2017-04-15T02:00:00Z | 2017-04-15T04:00:00+02:00 | 2     |
```

```ls
series e:e1 d:2017-04-14T21:00:00Z m:m1=21
series e:e1 d:2017-04-14T22:00:00Z m:m1=22
series e:e1 d:2017-04-14T23:00:00Z m:m1=23
series e:e1 d:2017-04-15T00:00:00Z m:m1=0
series e:e1 d:2017-04-15T01:00:00Z m:m1=1
series e:e1 d:2017-04-15T02:00:00Z m:m1=2
```

## Query with Endtime Syntax in Custom Timezone

The `endtime()` function enables specifying a user-defined [time zone](../../shared/timezone-list.md) when evaluating [calendar](../../shared/calendar.md) keywords and expressions.

The following example selects data between 0h:0m:0s of the previous day and 0h:0m:0s of the current day according to PST timezone, even though the server itself runs in UTC timezone.

```sql
SELECT value, datetime,
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'UTC') AS "UTC_datetime",
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ssz', 'US/Pacific') AS "PST_datetime"
FROM "mpstat.cpu_busy"
  WHERE entity = 'nurswgvml007'
AND datetime BETWEEN endtime(YESTERDAY, 'US/Pacific') AND endtime(CURRENT_DAY, 'US/Pacific')
  ORDER BY datetime
```

```ls
| value | datetime             | UTC_datetime           | PST_datetime           |
|-------|----------------------|------------------------|------------------------|
| 6.86  | 2017-06-16T07:00:05Z | 2017-06-16T07:00:05UTC | 2017-06-16T00:00:05PDT |
| 6.06  | 2017-06-16T07:00:21Z | 2017-06-16T07:00:21UTC | 2017-06-16T00:00:21PDT |
  ....
| 3.03  | 2017-06-17T06:59:29Z | 2017-06-17T06:59:29UTC | 2017-06-16T23:59:29PDT |
| 2.97  | 2017-06-17T06:59:45Z | 2017-06-17T06:59:45UTC | 2017-06-16T23:59:45PDT |
```

## Query using Local Time

```sql
SELECT datetime as utc_time, date_format(time, 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna') AS local_datetime, value
  FROM "mpstat.cpu_busy"
  WHERE entity = 'nurswgvml007'
    AND time >= date_parse('2017-05-01 12:00:00', 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna')
    AND  time < date_parse('2017-05-03 12:00:00', 'yyyy-MM-dd HH:mm:ss', 'Europe/Vienna')
```

```ls
| utc_time            | local_datetime      | value  |
|---------------------|---------------------|--------|
| 2017-05-01 10:00:15 | 2017-05-01 12:00:15 | 4.9500 |
| 2017-05-01 10:00:31 | 2017-05-01 12:00:31 | 3.0000 |
| 2017-05-01 10:00:47 | 2017-05-01 12:00:47 | 3.0900 |
```

## Query using `BETWEEN`

The `BETWEEN` operator is inclusive and includes samples recorded at both the start and the end of the interval.

The expression `datetime BETWEEN t1 and t2` is equivalent to `datetime >= t1 and datetime <= t2`.

To emulate a half-open `[)` interval subtract 1 millisecond from an `AND` value.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN '2016-06-18T20:00:00.000Z' AND '2016-06-18T20:59:59.999Z'
```

The above condition is equivalent to:

```sql
  datetime >= '2016-06-18T20:00:00.000Z' AND datetime < '2016-06-18T21:00:00.000Z'
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-06-18T20:00:11.000Z | 28.0  |
| 2016-06-18T20:00:27.000Z | 6.1   |
| 2016-06-18T20:00:43.000Z | 6.1   |
```

## Query using `BETWEEN` Subquery

The `BETWEEN` operator allows specifying a subquery that must return a result set containing multiple rows with 1 column.

* If the subquery returns no values, the condition evaluates to `FALSE`, and no rows are returned.
* If the subquery returns only one value, it is considered as the lower boundary of the time interval and the upper boundary is not defined.
* If there are 2 values, the second value must be greater or equal the first value.
* If there are more than 2 values, then each pair of values is processed as a separate time interval.

> The intervals in the result set can be identified with the [`INTERVAL_NUMBER()`](../README.md#interval-number) function.

```ls
series d:2017-04-03T01:00:00Z e:nurswgvml007 x:maintenance-rfc=RFC12-start
series d:2017-04-03T01:15:00Z e:nurswgvml007 x:maintenance-rfc=RFC12-stop
```

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN (SELECT datetime FROM "maintenance-rfc"
  WHERE entity = 'nurswgvml007'
ORDER BY datetime)
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2017-04-03T01:00:09.000Z | 24.0  |
| 2017-04-03T01:00:25.000Z | 55.0  |
...
| 2017-04-03T01:14:17.000Z | 4.0   |
| 2017-04-03T01:14:33.000Z | 4.1   |
| 2017-04-03T01:14:49.000Z | 63.0  |
```

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN (SELECT datetime FROM "maintenance-rfc"
  WHERE entity = 'nurswgvml007'
ORDER BY datetime)
```

```ls
| avg(value) | first(value) | last(value) | count(value) |
|------------|--------------|-------------|--------------|
| 14.1       | 24.0         | 63.0        | 56.0         |
```

### Multiple Intervals in the Subquery

```sql
-- outer query
WHERE t1.datetime BETWEEN (SELECT datetime FROM "TV6.Unit_BatchID" WHERE entity = 'br-1211' AND (text = '800' OR LAG(text)='800'))
```

```ls
| datetime             |
|----------------------|
| 2016-10-04T02:01:20Z | 1st interval start
| 2016-10-04T02:03:05Z | 1st interval end
| 2016-10-04T02:03:10Z | 2nd interval start
| 2016-10-04T02:07:05Z | 2nd interval end
```

The above subquert result is equivalent to:

```sql
WHERE t1.datetime BETWEEN '2016-10-04T02:01:20Z' AND '2016-10-04T02:03:05Z'
   OR t1.datetime BETWEEN '2016-10-04T02:03:10Z' AND '2016-10-04T02:07:05Z'
```

## Query Multiple Intervals with `OR`

The query may select multiple intervals using the `OR` operator.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND (datetime BETWEEN '2017-04-02T14:00:00Z' AND '2017-04-02T14:01:00Z'
    OR datetime BETWEEN '2017-04-04T16:00:00Z' AND '2017-04-04T16:01:00Z')
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-02T14:00:04Z | 80.8  | start
| 2017-04-02T14:00:20Z | 64.7  |
| 2017-04-02T14:00:36Z | 5.0   |
| 2017-04-02T14:00:52Z | 100.0 | end
| 2017-04-04T16:00:06Z | 54.6  | start
| 2017-04-04T16:00:22Z | 6.0   |
| 2017-04-04T16:00:38Z | 81.0  |
| 2017-04-04T16:00:54Z | 38.8  | end
```

## Query Multiple Intervals with Date Filter

The date filters splits the selection timespan into multiple separate intervals which contain consecutive samples where the date filters evaluated to true.

Each interval opens with the first sample for which the date filter returned `true`, includes subsequent samples which also evaluate to `true`, and closes before the first row that returns `false`.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime > PREVIOUS_HOUR
  AND date_format(time, 'mm:ss') BETWEEN '00:00' AND '00:30'
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-04T16:00:06Z | 54.6  |
| 2017-04-04T16:00:22Z | 6.0   |
... Current interval closes when the first sample outside of the [00:00-00:30] time range returns FALSE.
... Intermediate samples that evaluate to FALSE are not part of any interval.
| 2017-04-04T17:00:08Z | 3.0   | <- New interval starts when new sample evaluates to TRUE after previous FALSE rows.
| 2017-04-04T17:00:24Z | 3.4   | <- Subsequent TRUE rows are part of the interval.
```

## Query to Interpolate Multiple Intervals

Multiple intervals are treated separately for the purpose of interpolating and regularizing values.
In particular, the values between such intervals are not interpolated and not regularized.

```sql
SELECT datetime, value
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND (datetime BETWEEN '2017-04-02T14:00:00Z' AND '2017-04-02T14:01:00Z'
    OR datetime BETWEEN '2017-04-04T16:00:00Z' AND '2017-04-04T16:01:00Z')
  WITH INTERPOLATE(15 SECOND)
```

```ls
| datetime             | value |
|----------------------|-------|
| 2017-04-02T14:00:00Z | 63.6  |
| 2017-04-02T14:00:15Z | 69.7  |
| 2017-04-02T14:00:30Z | 27.4  |
| 2017-04-02T14:00:45Z | 58.4  |
| 2017-04-02T14:01:00Z | 55.1  |
.. No regularized samples are filled between intervals ...
| 2017-04-04T16:00:00Z | 36.8  |
| 2017-04-04T16:00:15Z | 27.3  |
| 2017-04-04T16:00:30Z | 43.5  |
| 2017-04-04T16:00:45Z | 62.5  |
| 2017-04-04T16:01:00Z | 25.4  |
```

```sql
SELECT datetime, AVG(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND (datetime BETWEEN '2017-04-02T14:00:00Z' AND '2017-04-02T14:01:00Z'
    OR datetime BETWEEN '2017-04-04T16:00:00Z' AND '2017-04-04T16:01:00Z')
  GROUP BY PERIOD(15 SECOND)
```

```ls
| datetime             | avg(value) |
|----------------------|------------|
| 2017-04-02T14:00:00Z | 80.8       |
| 2017-04-02T14:00:15Z | 64.7       |
| 2017-04-02T14:00:30Z | 5.0        |
| 2017-04-02T14:00:45Z | 100.0      |
... No intermediate periods are filled between intervals ...
| 2017-04-04T16:00:00Z | 54.6       |
| 2017-04-04T16:00:15Z | 6.0        |
| 2017-04-04T16:00:30Z | 81.0       |
| 2017-04-04T16:00:45Z | 38.8       |
```

## Query by Calendar

Use the `date_format` OR `extract` function to retrieve date parts from date for the purpose of filtering.
The following query includes only weekdays (Monday till Friday) and daytime hours (from 08:00 till 17:59).

```sql
SELECT datetime, date_format(time, 'EEE') AS "day of week", avg(value), count(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= previous_week AND datetime < current_week
  AND CAST(date_format(time, 'H') AS number) BETWEEN 8 AND 17
  AND date_format(time, 'u') < 6
GROUP BY PERIOD(1 hour)
```

```ls
| datetime             | day of week  | avg(value)  | count(value) | 
|----------------------|--------------|-------------|--------------| 
| 2018-03-12 08:00:00  | Mon          | 14.535      | 223          | 
| 2018-03-12 09:00:00  | Mon          | 12.626      | 225          | 
| 2018-03-12 10:00:00  | Mon          | 12.114      | 225          | 
| 2018-03-12 11:00:00  | Mon          | 11.314      | 225          | 
| 2018-03-12 12:00:00  | Mon          | 18.711      | 223          | 
| 2018-03-12 13:00:00  | Mon          | 19.721      | 222          | 
| 2018-03-12 14:00:00  | Mon          | 17.596      | 223          | 
| 2018-03-12 15:00:00  | Mon          | 12.728      | 225          | 
| 2018-03-12 16:00:00  | Mon          | 11.646      | 225          | 
| 2018-03-12 17:00:00  | Mon          | 35.701      | 223          | 
| 2018-03-13 08:00:00  | Tue          | 10.217      | 224          | 
| 2018-03-13 09:00:00  | Tue          | 10.033      | 225          | 
| 2018-03-13 10:00:00  | Tue          | 19.777      | 222          | 
| 2018-03-13 11:00:00  | Tue          | 14.144      | 225          | 
| 2018-03-13 12:00:00  | Tue          | 15.393      | 225          | 
| 2018-03-13 13:00:00  | Tue          | 13.518      | 225          | 
| 2018-03-13 14:00:00  | Tue          | 10.204      | 225          | 
| 2018-03-13 15:00:00  | Tue          | 13.378      | 225          | 
| 2018-03-13 16:00:00  | Tue          | 12.242      | 223          | 
| 2018-03-13 17:00:00  | Tue          | 56.667      | 224          | 
| 2018-03-14 08:00:00  | Wed          | 10.793      | 225          | 
| 2018-03-14 09:00:00  | Wed          | 11.626      | 225          | 
| 2018-03-14 10:00:00  | Wed          | 11.949      | 225          | 
| 2018-03-14 11:00:00  | Wed          | 11.437      | 224          | 
| 2018-03-14 12:00:00  | Wed          | 18.873      | 223          | 
| 2018-03-14 13:00:00  | Wed          | 12.786      | 225          | 
| 2018-03-14 14:00:00  | Wed          | 22.585      | 223          | 
| 2018-03-14 15:00:00  | Wed          | 12.881      | 225          | 
| 2018-03-14 16:00:00  | Wed          | 27.738      | 202          | 
| 2018-03-14 17:00:00  | Wed          | 55.621      | 225          | 
| 2018-03-15 08:00:00  | Thu          | 11.795      | 225          | 
| 2018-03-15 09:00:00  | Thu          | 10.648      | 225          | 
| 2018-03-15 10:00:00  | Thu          | 17.217      | 221          | 
| 2018-03-15 11:00:00  | Thu          | 11.888      | 225          | 
| 2018-03-15 12:00:00  | Thu          | 11.354      | 225          | 
| 2018-03-15 13:00:00  | Thu          | 13.089      | 225          | 
| 2018-03-15 14:00:00  | Thu          | 12.522      | 224          | 
| 2018-03-15 15:00:00  | Thu          | 10.560      | 225          | 
| 2018-03-15 16:00:00  | Thu          | 11.245      | 225          | 
| 2018-03-15 17:00:00  | Thu          | 54.934      | 225          | 
| 2018-03-16 08:00:00  | Fri          | 12.634      | 224          | 
| 2018-03-16 09:00:00  | Fri          | 12.510      | 225          | 
| 2018-03-16 10:00:00  | Fri          | 10.535      | 225          | 
| 2018-03-16 11:00:00  | Fri          | 10.474      | 225          | 
| 2018-03-16 12:00:00  | Fri          | 11.605      | 225          | 
| 2018-03-16 13:00:00  | Fri          | 15.106      | 223          | 
| 2018-03-16 14:00:00  | Fri          | 10.950      | 225          | 
| 2018-03-16 15:00:00  | Fri          | 15.914      | 223          | 
| 2018-03-16 16:00:00  | Fri          | 11.423      | 225          | 
| 2018-03-16 17:00:00  | Fri          | 52.672      | 224          | 
```
