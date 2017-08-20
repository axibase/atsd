# Inline View

Inline view is a subquery used in the `FROM` clause of some parent query. It allows the parent query to operate on the results of some subquery.

## Query

Using Inline view, identify the maximum value in each hour and then calculate the average hourly maximum for each day of the week.

```sql
SELECT datetime, AVG(value) AS "daily_average" 
  FROM -- actual table replaced with subquery
  (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
GROUP BY PERIOD(1 DAY)
```

### Results

```ls
| datetime            | daily_average | 
|---------------------|---------------| 
| 2017-08-14 00:00:00 | 96.1          | 
| 2017-08-15 00:00:00 | 96.6          | 
| 2017-08-16 00:00:00 | 98.8          | 
| 2017-08-17 00:00:00 | 95.4          | 
| 2017-08-18 00:00:00 | 98.3          | 
| 2017-08-19 00:00:00 | 96.1          | 
| 2017-08-20 00:00:00 | 93.8          | 
```

## Query

Calculate the hourly maximum for a defined time period, and then return the maximum value from that resultset.

```sql
SELECT MAX(value) FROM (
  SELECT datetime, AVG(value) AS "value" FROM (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
  GROUP BY PERIOD(1 DAY)
)
```

### Results

Unlimited nested subqueries are supported.. 

```ls
| max(value) |
|------------|
| 98.8       |
```

## Query

Group results by a subset of series tags and regularize the series in the subquery, then apply aggregation functions to the subquery results in the parent query.

```sql
SELECT datetime, tags.application, tags.transaction, 
  sum(value)/count(value) as daily_good_pct
FROM (
    SELECT datetime, tags.application, tags.transaction,
      CASE WHEN sum(value) >= 0.3 THEN 1 ELSE 0 END AS "value"
    FROM "good_requests" 
    WHERE tags.application = 'SSO'
      AND tags.transaction = 'authenticate'
      AND datetime >= '2017-03-15T00:00:00Z' AND datetime < '2017-03-15T03:00:00Z'
      WITH INTERPOLATE (5 MINUTE)
      GROUP BY datetime, tags.application, tags.transaction
) 
GROUP BY tags.application, tags.transaction, PERIOD(1 hour)
```

### Results

```ls
| datetime            | tags.application | tags.transaction | hourly_good_pct | 
|---------------------|------------------|------------------|-----------------| 
| 2017-03-15 00:00:00 | SSO              | authenticate     | 1.00            | 
| 2017-03-15 01:00:00 | SSO              | authenticate     | 0.75            | 
| 2017-03-15 02:00:00 | SSO              | authenticate     | 0.83            | 
```


