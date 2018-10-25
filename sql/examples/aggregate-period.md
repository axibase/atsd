# Aggregate per Period

Split selection into periods and calculate statistics per period with aggregation functions.

## Default Period

```sql
SELECT datetime, avg(value), max(value), last(value), count(*)
 FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
 AND datetime >= current_day
 GROUP BY PERIOD(1 HOUR)
```

```ls
| datetime             | avg(value) | max(value) | last(value) | count(*) |
|----------------------|------------|------------|-------------|----------|
| 2016-07-15T00:00:00Z | 11.564     | 100.000    | 27.000      | 225.000  |
| 2016-07-15T01:00:00Z | 15.485     | 100.000    | 27.780      | 225.000  |
| 2016-07-15T02:00:00Z | 17.268     | 100.000    | 36.360      | 224.000  |
| 2016-07-15T03:00:00Z | 15.001     | 100.000    | 6.000       | 224.000  |
| 2016-07-15T04:00:00Z | 12.744     | 100.000    | 15.000      | 225.000  |
| 2016-07-15T05:00:00Z |  9.135     |  97.980    | 7.070       | 225.000  |
| 2016-07-15T06:00:00Z | 10.301     | 100.000    | 92.930      | 225.000  |
| 2016-07-15T07:00:00Z | 10.345     | 100.000    | 6.000       | 225.000  |
| 2016-07-15T08:00:00Z | 11.958     | 100.000    | 38.950      | 225.000  |
| 2016-07-15T09:00:00Z | 11.566     | 100.000    | 6.060       | 224.000  |
| 2016-07-15T10:00:00Z | 16.180     | 100.000    | 99.000      | 222.000  |
| 2016-07-15T11:00:00Z | 11.921     | 100.000    | 7.070       | 225.000  |
| 2016-07-15T12:00:00Z | 10.906     | 100.000    | 8.000       | 225.000  |
| 2016-07-15T13:00:00Z | 12.709     | 100.000    | 45.260      | 224.000  |
| 2016-07-15T14:00:00Z | 14.204     | 100.000    | 7.000       | 213.000  |
```

## Period Start and End Time

Display the period start and end time using the `date_format` function.

```sql
SELECT datetime AS period_start, date_format(time+60*60000) AS period_end, avg(value)
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
  AND datetime >= current_day
GROUP BY PERIOD(1 HOUR)
```

```ls
| period_start         | period_end           | avg(value) |
|----------------------|----------------------|------------|
| 2016-08-25T00:00:00Z | 2016-08-25T01:00:00Z | 7.7        |
| 2016-08-25T01:00:00Z | 2016-08-25T02:00:00Z | 8.2        |
| 2016-08-25T02:00:00Z | 2016-08-25T03:00:00Z | 6.7        |
```

## Period Aligned to Custom Time Zone

The server time zone is "Europe/Berlin".

* Default time zone. The day periods are aligned to 0:00 server time zone which is 2 hours ahead of UTC.

```sql
SELECT datetime, date_format(time, 'yyyy-MM-ddTHH:mm:ssZZ') AS local_datetime,
  MIN(value), MAX(value), COUNT(value), FIRST(value), LAST(value)
FROM m1
  GROUP BY PERIOD(1 DAY)
```

```ls
| datetime             | local_datetime            | min(value) | max(value) | count(value) | first(value) | last(value) |
|----------------------|---------------------------|------------|------------|--------------|--------------|-------------|
| 2017-04-13T22:00:00Z | 2017-04-14T00:00:00+02:00 | 21         | 21         | 1            | 21           | 21          |
| 2017-04-14T22:00:00Z | 2017-04-15T00:00:00+02:00 | 0          | 23         | 6            | 22           | 3           |
```

* User-defined time zone. The day periods are aligned to 0:00 UTC time.

```sql
SELECT datetime, date_format(time, 'yyyy-MM-ddTHH:mm:ssZZ') AS local_datetime,
  MIN(value), MAX(value), COUNT(value), FIRST(value), LAST(value)
FROM m1
  GROUP BY PERIOD(1 DAY, 'UTC')
```

```ls
| datetime             | local_datetime            | min(value) | max(value) | count(value) | first(value) | last(value) |
|----------------------|---------------------------|------------|------------|--------------|--------------|-------------|
| 2017-04-14T00:00:00Z | 2017-04-14T02:00:00+02:00 | 21         | 23         | 3            | 21           | 23          |
| 2017-04-15T00:00:00Z | 2017-04-15T02:00:00+02:00 | 0          | 3          | 4            | 0            | 3           |
```

* Data

```ls
series e:e1 d:2017-04-14T21:00:00Z m:m1=21
series e:e1 d:2017-04-14T22:00:00Z m:m1=22
series e:e1 d:2017-04-14T23:00:00Z m:m1=23
series e:e1 d:2017-04-15T00:00:00Z m:m1=0
series e:e1 d:2017-04-15T01:00:00Z m:m1=1
series e:e1 d:2017-04-15T02:00:00Z m:m1=2
series e:e1 d:2017-04-15T03:00:00Z m:m1=3
```

## Period Aligned to Custom Time Zone

```sql
SELECT datetime, date_format(time, 'yyyy-MM-dd HH:mm:ss z', 'US/Pacific') AS local_datetime,
  MIN(value), MAX(value), COUNT(value), FIRST(value), LAST(value)
FROM tmz1
  GROUP BY PERIOD(1 DAY, 'US/Pacific')
```

```ls
| datetime            | local_datetime          | min(value) | max(value) | count(value) | first(value) | last(value) |
|---------------------|-------------------------|------------|------------|--------------|--------------|-------------|
| 2017-04-14 07:00:00 | 2017-04-14 00:00:00 PDT | 0.0        | 23.0       | 7            | 21.0         | 3.0         |
```

* Data

```ls
series e:e1 d:2017-04-14T21:00:00Z m:tmz1=21
series e:e1 d:2017-04-14T22:00:00Z m:tmz1=22
series e:e1 d:2017-04-14T23:00:00Z m:tmz1=23
series e:e1 d:2017-04-15T00:00:00Z m:tmz1=0
series e:e1 d:2017-04-15T01:00:00Z m:tmz1=1
series e:e1 d:2017-04-15T02:00:00Z m:tmz1=2
series e:e1 d:2017-04-15T03:00:00Z m:tmz1=3
```

## Period Aligned to Entity Time Zone

```sql
SELECT entity, entity.timeZone,
  AVG(value),
  date_format(time, 'yyyy-MM-dd HH:mm z', 'UTC') AS "Period Start: UTC datetime",
  date_format(time, 'yyyy-MM-dd HH:mm z', entity.timeZone) AS "Period Start: Local datetime"
FROM "mpstat.cpu_busy"
  WHERE datetime >= ENDTIME(PREVIOUS_DAY, entity.timeZone)
    AND datetime < ENDTIME(CURRENT_DAY, entity.timeZone)
GROUP BY entity, PERIOD(1 DAY, entity.timeZone)
```

```ls
| entity       | entity.timeZone | avg(value) | Period Start: UTC datetime | Period Start: Local datetime |
|--------------|-----------------|------------|----------------------------|------------------------------|
| nurswgvml007 | PST             | 12.3       | 2017-08-17 07:00 UTC       | 2017-08-17 00:00 PDT         |
| nurswgvml006 | US/Mountain     | 9.2        | 2017-08-17 06:00 UTC       | 2017-08-17 00:00 MDT         |
| nurswgvml010 | null            | 5.8        | 2017-08-17 00:00 UTC       | 2017-08-17 00:00 GMT         |
```