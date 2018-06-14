# Diurnal Queries

The date_format function can be used in the `WHERE`, `GROUP BY`, and `HAVING` clauses to filter and group dates by month name, day name, or hour number.

* `MMM` - short, 3-letter, month name, for example, Jan
* `MMMMM` - full month name, for example January
* `EEE` - short, 3-letter, weekday name, for example Sat
* `EEEEE` - full weekday name, for example Saturday
* `u` - weekday number, starting with 1 for Monday
* `HH` - hour of the day, 2 digit, 00 to 23.

For additional patterns, refer to Java [`SimpleDateFormat`](https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html).

## Example: Filter by calendar

In this example we calculate the totals for the month of January over a 7 year period in order to determine a range of pneumonia deaths recorded in East-North-Central US. To retain only samples recorded in January, we use the `date_format(time, 'MMM') = 'Jan'` condition.

```sql
SELECT date_format(time, 'yyyy MMM') AS "date",
  LOOKUP('us-region', tags.region) AS "region",
  sum(value) AS "pneumonia_influenza_deaths"
FROM "cdc.pneumonia_and_influenza_deaths"
  WHERE entity = 'mr8w-325u' AND tags.region = '3'
  AND datetime >= '2010-01-01T00:00:00Z'
  AND date_format(time, 'MMM') = 'Jan'
GROUP BY tags.region, period(1 MONTH)
  ORDER BY 3 DESC
```

### Results

```ls
| date     | region             | pneumonia_influenza_deaths |
|----------|--------------------|----------------------------|
| 2015 Jan | East-North-Central | 1203                       |
| 2013 Jan | East-North-Central | 898                        |
| 2016 Jan | East-North-Central | 732                        |
| 2011 Jan | East-North-Central | 730                        |
| 2014 Jan | East-North-Central | 722                        |
| 2010 Jan | East-North-Central | 691                        |
| 2012 Jan | East-North-Central | 641                        |
```

## Example: Daily Averages

To calculate averages or totals by day of the week, use `date_format(time, 'EEE')` or `date_format(time, 'u')` functions.
The `EEE` pattern returns short day name for each sample: `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`, whereas `u` pattern returns day number starting with `1` for Monday.

```sql
SELECT date_format(time, 'u') AS day_of_week, avg(value) AS average
FROM "mpstat.cpu_busy"
  WHERE datetime >= previous_week
GROUP BY date_format(time, 'u')
  ORDER BY date_format(time, 'u')
```

```sql
SELECT substr(date_format(time, 'u-EEE'), 3) AS day_of_week, avg(value) AS average
FROM "mpstat.cpu_busy"
  WHERE datetime >= previous_week
GROUP BY date_format(time, 'u-EEE')
  ORDER BY date_format(time, 'u-EEE')
```

```ls
| day_of_week | average |
|-------------|---------|
| Mon         | 5.73    |
| Tue         | 7.05    |
| Wed         | 7.36    |
| Thu         | 7.50    |
| Fri         | 8.48    |
| Sat         | 6.08    |
| Sun         | 5.97    |
```

## Example: Diurnal Seasonality

By grouping samples by hour of the day (regardless which day it is) you can create diurnal charts which show changes in activity throughout the day.

```sql
SELECT date_format(time, 'HH') AS "hour_in_day",
  avg(value)
FROM "mpstat.cpu_busy"
  WHERE datetime >= current_month
GROUP BY date_format(time, 'HH')
  ORDER BY 1
```

### Results

```ls
| hour_in_day | avg(value) |
|-------------|------------|
| 0           | 5.0        |
| 1           | 22.2       |
| 2           | 6.3        |
| 3           | 9.3        |
| 4           | 5.3        |
| 5           | 4.7        |
| 6           | 5.4        |
| 7           | 6.2        |
| 8           | 6.7        |
| 9           | 7.1        |
| 10          | 6.9        |
| 11          | 6.8        |
| 12          | 6.0        |
| 13          | 5.9        |
| 14          | 6.1        |
| 15          | 6.8        |
| 16          | 6.5        |
| 17          | 5.8        |
| 18          | 5.3        |
| 19          | 5.9        |
| 20          | 6.2        |
| 21          | 4.5        |
| 22          | 8.0        |
| 23          | 5.6        |
```

## Example: Weekly Diurnal Seasonality

The weekly diurnal charts take day of week into account and can be used, for example, to calculate both weekly seasonality, as well as weekly highs and lows using different columns in the ORDER clause.

```sql
SELECT concat(date_format(time, 'EEEEE, HH'), ':00') AS "day, hour",
  avg(value)
FROM "mpstat.cpu_busy"
  WHERE datetime >= current_week
  AND date_format(time, 'HH') >= '09' AND date_format(time, 'HH') < '18'
GROUP BY date_format(time, 'EEEEE HH')
  ORDER BY 2 DESC
```

### Results

```ls
| day, hour        | avg(value) |
|------------------|------------|
| Wednesday, 14:00 | 18.70      |
| Tuesday, 14:00   | 12.99      |
| Wednesday, 09:00 | 12.53      |
| Wednesday, 16:00 | 12.29      |
| Tuesday, 13:00   | 11.50      |
| Wednesday, 15:00 | 10.71      |
| Monday, 16:00    | 10.12      |
| Thursday, 09:00  | 9.63       |
```

## Example: Numeric Comparison

The above example relies on the lexicographical comparison of 2-digit hours strings.
The following alternative utilizes the `CAST` function to convert the `date_format` output to numbers in order to filter parts of the day.

```sql
SELECT date_format(time, 'EEE HH') AS "hour_in_day",
  percentile(75, value)
FROM "mpstat.cpu_busy"
  WHERE datetime >= previous_week
  AND CAST(date_format(time, 'H') AS number) >= 9 AND CAST(date_format(time, 'H') AS number) < 18
GROUP BY date_format(time, 'EEE HH')
  ORDER BY 2 DESC
```

```ls
| hour_in_day | percentile(75,value) |
|-------------|----------------------|
| Tue 09      | 41.8                 |
| Tue 10      | 41.2                 |
| Mon 12      | 40.7                 |
| Mon 16      | 40.5                 |
| Mon 13      | 40.4                 |
```
