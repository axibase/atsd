# Date Extract Functions

## EXTRACT


```sql
SELECT datetime, 
  EXTRACT(year FROM datetime) AS 'year',
  EXTRACT(quarter FROM datetime) AS 'quarter',
  EXTRACT(month FROM datetime) AS 'month',
  EXTRACT(day FROM datetime) AS 'day',
  EXTRACT(hour FROM datetime) AS 'hour',
  EXTRACT(minute FROM datetime) AS 'minute',
  EXTRACT(second FROM datetime) AS 'second',
  EXTRACT(day FROM now - 1*DAY) AS 'prev_day',
  EXTRACT(month FROM now + 1*MONTH) AS 'next_month'
FROM mpstat.cpu_busy 
  WHERE datetime > current_hour
```

```ls
| datetime             | year | quarter | month | day | hour | minute | second | prev_day | next_month | 
|----------------------|------|---------|-------|-----|------|--------|--------|----------|------------| 
| 2017-07-29T21:00:12Z | 2017 | 3       | 7     | 29  | 9    | 0      | 12     | 28       | 8          | 
```

## EXTRACT in grouping

```sql
SELECT EXTRACT(day FROM datetime) AS 'day',
  AVG(value)
FROM mpstat.cpu_busy 
  WHERE datetime > current_month
GROUP BY 'day'
  ORDER BY AVG(value) DESC
```

```ls
| day | avg(value) | 
|-----|------------| 
| 21  | 11.1       | 
| 24  | 9.6        | 
| 25  | 9.3        | 
```

## EXTRACT alternatives

The `extract` function is analogous to YEAR(), QUARTER(), MONTH(), etc. functions listed below.

```sql
SELECT datetime, 
  YEAR(datetime) AS 'year',
  QUARTER(datetime) AS 'quarter',
  MONTH(datetime) AS 'month',
  DAY(datetime) AS 'day',
  HOUR(datetime) AS 'hour',
  MINUTE(datetime) AS 'minute',
  SECOND(datetime) AS 'second',
  date_format(time, 'yyyy-MMM-dd, EEE') as 'date',
  DAYOFWEEK(datetime) AS 'dow'
FROM mpstat.cpu_busy 
  WHERE datetime > current_hour
```

## EXTRACT with BETWEEN and IN (range)

```ls
| datetime             | year | quarter | month | day | hour | minute | second | date             | dow | 
|----------------------|------|---------|-------|-----|------|--------|--------|------------------|-----| 
| 2017-07-29T21:00:12Z | 2017 | 3       | 7     | 29  | 9    | 0      | 12     | 2017-Jul-29, Sat | 7   | 
```

```sql
SELECT HOUR(datetime) AS 'hour',
  AVG(value)
FROM mpstat.cpu_busy 
  WHERE datetime > previous_day 
  AND HOUR(datetime) BETWEEN 5 and 9
GROUP BY 'hour'
```

```ls
| hour | avg(value) | 
|------|------------| 
| 5    | 6.0        | 
| 6    | 6.4        | 
| 7    | 5.6        | 
| 8    | 6.2        | 
| 9    | 6.3        | 
```