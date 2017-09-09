# Datetime Format

A `datetime` column returns time in ISO format.

## Query

```sql
SELECT datetime, time, value
  FROM "mpstat.cpu_busy" 
WHERE entity = 'nurswgvml007'
  AND datetime BETWEEN '2016-04-09T14:00:00Z' AND '2016-04-09T14:05:00Z'
```

## Results

```ls
| datetime             | time          | value |
|----------------------|---------------|------:|
| 2016-04-09T14:00:01Z | 1428588001000 | 3.8   |
| 2016-04-09T14:00:18Z | 1428588018000 | 14.0  |
| 2016-04-09T14:00:34Z | 1428588034000 | 16.83 |
| 2016-04-09T14:00:50Z | 1428588050000 | 10.2  |
| 2016-04-09T14:01:06Z | 1428588066000 | 4.04  |
| 2016-04-09T14:01:22Z | 1428588082000 | 9.0   |
| 2016-04-09T14:01:38Z | 1428588098000 | 2.0   |
| 2016-04-09T14:01:54Z | 1428588114000 | 8.0   |
| 2016-04-09T14:02:10Z | 1428588130000 | 10.23 |
| 2016-04-09T14:02:26Z | 1428588146000 | 14.0  |
| 2016-04-09T14:02:42Z | 1428588162000 | 20.2  |
```

## `date_format` Function

The `date_format` function can print out the `time` column as well as any numeric column containing Epoch milliseconds, formatted with the user-defined format and time zone.

```sql
SELECT time, 
  date_format(time), 
  date_format(time, 'yyyy-MM-dd''T''HH:mm:ss''Z'''),
  date_format(time, 'yyyy-MM-dd HH:mm:ss'),
  date_format(time, 'yyyy-MM-dd HH:mm:ss', 'PST'),
  date_format(time, 'yyyy-MM-dd HH:mm:ss', 'GMT-08:00'),
  date_format(time, 'yyyy-MM-dd HH:mm:ss ZZ', 'PST'),
  date_format(time, 'yyyy-MM-dd HH:mm:ss ZZ', 'PST')
FROM "mpstat.cpu_busy"
  WHERE datetime > now - 5 * minute
  LIMIT 1
```

```ls
| time          | date_format(time)        | date_format(time,'yyyy-MM-dd''T''HH:mm:ss''Z''') | date_format(time,'yyyy-MM-dd HH:mm:ss') | date_format(time,'yyyy-MM-dd HH:mm:ss','PST') | date_format(time,'yyyy-MM-dd HH:mm:ss','GMT-08:00') | date_format(time,'yyyy-MM-dd HH:mm:ss ZZ','PST') | date_format(time,'yyyy-MM-dd HH:mm:ss ZZ','PST') | 
|---------------|--------------------------|--------------------------------------------|-----------------------------------------|-----------------------------------------------|-----------------------------------------------------|--------------------------------------------------|--------------------------------------------------| 
| 1468581897000 | 2016-07-15T11:24:57.000Z | 2016-07-15T11:24:57+0000                   | 2016-07-15 11:24:57                     | 2016-07-15 04:24:57                           | 2016-07-15 03:24:57                                 | 2016-07-15 04:24:57 -07:00                       | 2016-07-15 04:24:57 -07:00                       | 
```

```ls
| format                                                         | date_format value          | 
|----------------------------------------------------------------|----------------------------| 
| time                                                           | 1468411675000              | 
| date_format(time)                                              | 2016-07-13T12:07:55.000Z   | 
| date_format(time,'yyyy-MM-dd''T''HH:mm:ss.SSS''Z'','UTC')      | 2016-07-13T12:07:55.000Z   | 
| date_format(time,'yyyy-MM-dd HH:mm:ss')                        | 2016-07-13 12:07:55        | 
| date_format(time,'yyyy-MM-dd HH:mm:ss','PST')                  | 2016-07-13 05:07:55        | 
| date_format(time,'yyyy-MM-dd HH:mm:ss','GMT-08:00')            | 2016-07-13 04:07:55        | 
| date_format(time,'yyyy-MM-dd HH:mm:ssZ','PST')                 | 2016-07-13 05:07:55-0700    | 
| date_format(time,'yyyy-MM-dd HH:mm:ssZZ','PST')                | 2016-07-13 05:07:55-07:00   | 
```

## `AUTO` timezone

The `AUTO` timezone parameter applies the time zone specified for the entity and metric.

The entity time zone overrides the metric time zone.

If the time zone is undefined for both entity and metric, the local server time zone is used instead.

Metrics:

```ls
mpstat.cpu_busy   = EDT
mpstat.cpu_system = AEDT (Australia/Sydney)
mpstat.cpu_user   = undefined
```

Entities:

```ls
     nurswgvml006 = CDT
     nurswgvml007 = PDT
     nurswgvml009 = UTC	 
     nurswgvml010 = undefined
```

Server Time:

```
UTC
```

### Query

Metric and entity timezone can be included in the `SELECT` expression using `metric.timezone` and `entity.timezone` columns.

```sql
SELECT t1.entity, t1.value AS "busy", t2.value AS "sys", t3.value AS "usr", 
  t1.metric.timezone AS "busy.tz", t2.metric.timezone AS "sys.tz", t3.metric.timezone AS "usr.tz",
  t1.entity.timezone AS "entity.tz",
  t1.datetime AS "datetime"
  ,date_format(t1.time, 'yyyy-MM-dd HH:mm:ss z', AUTO) AS "busy.auto_time"
  ,date_format(t2.time, 'yyyy-MM-dd HH:mm:ss z', AUTO) AS "sys.auto_time"
  ,date_format(t3.time, 'yyyy-MM-dd HH:mm:ss z', AUTO) AS "usr.auto_time"
  FROM "mpstat.cpu_busy" t1
  JOIN "mpstat.cpu_system" t2
  JOIN "mpstat.cpu_user" t3
WHERE t1.entity LIKE 'nurswgvml0%'
AND t1.datetime >= '2016-10-10T10:00:00.000Z' and t1.datetime < '2016-10-10T10:01:00.000Z'
  WITH INTERPOLATE(60 SECOND, AUTO, OUTER)
  ORDER BY t1.datetime
```

### Query Results

```ls
| t1.entity    | busy | sys | usr  | busy.tz | sys.tz | usr.tz | entity.tz | datetime                 | busy.auto_time          | sys.auto_time            | usr.auto_time                 | 
|--------------|------|-----|------|---------|--------|--------|-----------|--------------------------|-------------------------|--------------------------|-------------------------------| 
| nurswgvml006 | 32.3 | 6.4 | 24.7 | EST     | AEST   | null   | CST       | 2016-10-10T10:00:00.000Z | 2016-10-10 05:00:00 CDT | 2016-10-10 05:00:00 CDT  | 2016-10-10 05:00:00 CDT       | <- CDT
| nurswgvml007 | 31.7 | 6.1 | 23.5 | EST     | AEST   | null   | PST       | 2016-10-10T10:00:00.000Z | 2016-10-10 03:00:00 PDT | 2016-10-10 03:00:00 PDT  | 2016-10-10 03:00:00 PDT       | <- PDT
| nurswgvml009 | 57.0 | 3.0 | 6.0  | EST     | AEST   | null   | UTC       | 2016-10-10T10:00:00.000Z | 2016-10-10 10:00:00 UTC | 2016-10-10 10:00:00 UTC  | 2016-10-10 10:00:00 UTC       | <- UTC
| nurswgvml010 | 21.1 | 0.9 | 20.2 | EST     | AEST   | null   | null      | 2016-10-10T10:00:00.000Z | 2016-10-10 06:00:00 EDT | 2016-10-10 21:00:00 AEDT | 2016-10-10 10:00:00 GMT+00:00 | <- nurswgvml010 time zone is undefined, hence apply metric timezone except `cpu_user` which has no t/z.
```




