# Aggregate Functions: FIRST and LAST 

FIRST and LAST functions return the first and last value within a set of the grouped records which are ordered by time ascendingly.

## Data

```ls
series e:e-agr-1 m:m-agr=10  d:2017-07-01T02:00:00Z
series e:e-agr-2 m:m-agr=20  d:2017-07-01T08:00:00Z <- last value within day
series e:e-agr-3 m:m-agr=30  d:2017-07-01T01:00:00Z <- first value within day

series e:e-agr-3 m:m-agr=60  d:2017-07-02T00:00:00Z <- value is non-deterministic, multiple samples recorded with the same time
series e:e-agr-1 m:m-agr=40  d:2017-07-02T00:00:00Z
series e:e-agr-2 m:m-agr=50  d:2017-07-02T00:00:00Z
series e:e-agr-4 m:m-agr=70  d:2017-07-02T00:00:00Z

series e:e-agr-1 m:m-agr=NaN d:2017-07-03T00:00:00Z <- NaN is discarded by first/last functions
series e:e-agr-2 m:m-agr=80  d:2017-07-03T15:00:00Z <- last numeric value within day
series e:e-agr-3 m:m-agr=90  d:2017-07-03T09:00:00Z <- first numeric value within day
```

## Query: GROUP BY day

```sql
SELECT datetime, count(value), count(*),
  first(value), last(value)
FROM 'm-agr'
  GROUP BY PERIOD(1 DAY)
```

* Results

```ls
| datetime             | count(value) | count(*) | first(value) | last(value) | 
|----------------------|--------------|----------|--------------|-------------| 
| 2017-07-01T00:00:00Z | 3            | 3        | 30           | 20          | 
| 2017-07-02T00:00:00Z | 4            | 4        | 40           | 70          | 
| 2017-07-03T00:00:00Z | 2            | 3        | 90           | 80          | 
```

## Query: GROUP BY entity

```sql
SELECT entity, count(value), count(*),
  first(value), last(value)
FROM 'm-agr'
  GROUP BY entity
```

* Results

```ls
| entity  | count(value) | count(*) | first(value) | last(value) | 
|---------|--------------|----------|--------------|-------------| 
| e-agr-1 | 2            | 3        | 10           | 40          | 
| e-agr-2 | 3            | 3        | 20           | 80          | 
| e-agr-3 | 3            | 3        | 30           | 90          | 
| e-agr-4 | 1            | 1        | 70           | 70          | 
```
