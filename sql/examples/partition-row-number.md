# Partition - Row Number

## Overview

The `ROW_NUMBER` function returns the sequential number of a row within a partition of a result set, starting at 1 for the first row in each partition.

Partition is a subset of all rows in the result set grouped by columns specified in the `ROW_NUMBER` function. Each row in the result set may belong to only one partition.

Assuming that the below result set was partitioned by entity and then ordered by time within each partition, the row numbers would be as follows:

```ls
|--------------|----------------------|-------| ROW_NUMBER
| nurswgvml006 | 2016-06-18T12:00:05Z | 66.0  |     1
| nurswgvml006 | 2016-06-18T12:00:21Z | 8.1   |     2
| nurswgvml007 | 2016-06-18T12:00:03Z | 18.2  |     1
| nurswgvml007 | 2016-06-18T12:00:19Z | 67.7  |     2
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   |     1
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 |     1
| nurswgvml011 | 2016-06-18T12:00:26Z | 4.0   |     2
| nurswgvml011 | 2016-06-18T12:00:29Z | 0.0   |     3
```

## Syntax

```sql
ROW_NUMBER({partitioning columns} ORDER BY {ordering columns [direction]})
```

* {partitioning columns} is one or multiple columns for combining the rows
* {ordering columns [direction]} can be any in the `FROM` clause with optional ASC|DESC direction.

Examples:

* `ROW_NUMBER(entity ORDER BY datetime)`
* `ROW_NUMBER(entity, tags ORDER BY datetime DESC)`
* `ROW_NUMBER(value ORDER BY value)`
* `ROW_NUMBER(entity, tags ORDER BY datetime DESC, avg(value))`

 The returned number can be used to filter rows within each partition.

 * `WITH ROW_NUMBER(entity ORDER BY datetime) <= 1`

## `ROW_NUMBER` column

The `ROW_NUMBER()` column, without arguments, is available in the `SELECT` expression and `ORDER BY` clause.

```sql
SELECT datetime, entity, value, row_number()
  FROM "mpstat.cpu_busy"
WHERE datetime >= current_hour
  AND entity = 'nurswgvml007'
  WITH ROW_NUMBER(entity ORDER BY value DESC) <= 3
  ORDER BY row_number() desc
```

## Data

The input data for the specified interval contains 11 rows: 2 rows for 5 entities, and 1 entity with 1 row.

### Query

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T12:00:30Z'
  ORDER BY entity, datetime
```

### Results

```ls
| entity       | datetime             | value |
|--------------|----------------------|-------|
| nurswgvml006 | 2016-06-18T12:00:05Z | 66.0  | +
| nurswgvml006 | 2016-06-18T12:00:21Z | 8.1   |
| nurswgvml007 | 2016-06-18T12:00:03Z | 18.2  | +
| nurswgvml007 | 2016-06-18T12:00:19Z | 67.7  |
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   | +
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 | +
| nurswgvml011 | 2016-06-18T12:00:26Z | 4.0   |
| nurswgvml102 | 2016-06-18T12:00:02Z | 0.0   | +
| nurswgvml102 | 2016-06-18T12:00:18Z | 0.0   |
| nurswgvml502 | 2016-06-18T12:00:01Z | 13.7  | +
| nurswgvml502 | 2016-06-18T12:00:17Z | 0.5   |
```

### Query

```sql
SELECT entity, datetime, value, row_number() AS RN
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T12:00:30Z'
  WITH ROW_NUMBER(entity ORDER BY datetime) <= 100
  ORDER BY entity, datetime
```

### Results

```ls
| entity       | datetime             | value | RN |
|--------------|----------------------|-------|----|
| nurswgvml006 | 2016-06-18T12:00:05Z | 66.0  | 1  |
| nurswgvml006 | 2016-06-18T12:00:21Z | 8.1   | 2  |
| nurswgvml007 | 2016-06-18T12:00:03Z | 18.2  | 1  |
| nurswgvml007 | 2016-06-18T12:00:19Z | 67.7  | 2  |
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   | 1  |
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 | 1  |
| nurswgvml011 | 2016-06-18T12:00:26Z | 4.0   | 2  |
| nurswgvml102 | 2016-06-18T12:00:02Z | 0.0   | 1  |
| nurswgvml102 | 2016-06-18T12:00:18Z | 0.0   | 2  |
| nurswgvml502 | 2016-06-18T12:00:01Z | 13.7  | 1  |
| nurswgvml502 | 2016-06-18T12:00:17Z | 0.5   | 2  |
```

## First Record in Each Partition

### Query

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T12:00:30Z'
  WITH ROW_NUMBER(entity ORDER BY datetime) <= 1
  ORDER BY entity, datetime
```

### Results

```ls
| entity       | datetime             | value |
|--------------|----------------------|-------|
| nurswgvml006 | 2016-06-18T12:00:05Z | 66.0  |
| nurswgvml007 | 2016-06-18T12:00:03Z | 18.2  |
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   |
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 |
| nurswgvml102 | 2016-06-18T12:00:02Z | 0.0   |
| nurswgvml502 | 2016-06-18T12:00:01Z | 13.7  |
```

## Last Record in Each Partition

Reverse ordering is accomplished with the `ORDER BY datetime DESC` condition in the `ROW_NUMBER` function.

### Query

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T12:00:30Z'
  WITH ROW_NUMBER(entity ORDER BY datetime DESC) <= 1
  ORDER BY entity, datetime
```

### Results

```ls
| entity       | datetime             | value |
|--------------|----------------------|-------|
| nurswgvml006 | 2016-06-18T12:00:21Z | 8.1   |
| nurswgvml007 | 2016-06-18T12:00:19Z | 67.7  |
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   |
| nurswgvml011 | 2016-06-18T12:00:26Z | 4.0   |
| nurswgvml102 | 2016-06-18T12:00:18Z | 0.0   |
| nurswgvml502 | 2016-06-18T12:00:17Z | 0.5   |
```

## Maximum Value in Each Partition

The maximum value for each partition can be queried with the `ORDER BY value desc` condition in the `ROW_NUMBER` function.

### Query

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T12:00:30Z'
  WITH ROW_NUMBER(entity ORDER BY value DESC) <= 1
  ORDER BY entity, time
```

### Results

```ls
| entity       | datetime             | value |
|--------------|----------------------|-------|
| nurswgvml006 | 2016-06-18T12:00:05Z | 66.0  |
| nurswgvml007 | 2016-06-18T12:00:19Z | 67.7  |
| nurswgvml010 | 2016-06-18T12:00:14Z | 0.5   |
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 |
| nurswgvml102 | 2016-06-18T12:00:02Z | 0.0   |
| nurswgvml502 | 2016-06-18T12:00:01Z | 13.7  |
```

## Two Maximum Values in Each Partition with Row Number Display

### Query

```sql
SELECT entity, datetime, value, row_number()
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00Z' AND datetime < '2016-06-18T13:00:00Z'
  WITH ROW_NUMBER(entity ORDER BY value DESC) <= 2
  ORDER BY entity, datetime
```

### Results

```ls
| entity       | datetime             | value | row_number() |
|--------------|----------------------|-------|--------------|
| nurswgvml006 | 2016-06-18T12:06:45Z | 100.0 | 1            |
| nurswgvml006 | 2016-06-18T12:24:21Z | 100.0 | 2            |
| nurswgvml007 | 2016-06-18T12:04:03Z | 100.0 | 1            |
| nurswgvml007 | 2016-06-18T12:24:37Z | 100.0 | 2            |
| nurswgvml010 | 2016-06-18T12:30:06Z | 26.8  | 2            |
| nurswgvml010 | 2016-06-18T12:43:10Z | 32.0  | 1            |
| nurswgvml011 | 2016-06-18T12:00:10Z | 100.0 | 1            |
| nurswgvml011 | 2016-06-18T12:38:35Z | 100.0 | 2            |
| nurswgvml102 | 2016-06-18T12:01:38Z | 4.9   | 1            |
| nurswgvml102 | 2016-06-18T12:06:42Z | 4.0   | 2            |
| nurswgvml502 | 2016-06-18T12:07:46Z | 21.5  | 2            |
| nurswgvml502 | 2016-06-18T12:24:18Z | 43.9  | 1            |
```
