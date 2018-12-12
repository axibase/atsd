# Partition - Lag and Lead

## Query - Data

```sql
SELECT entity, datetime, value
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  AND entity = 'car-1'
ORDER BY entity, tags, datetime
```

### Results

```ls
| entity  | datetime             | value |
|---------|----------------------|-------|
| car-1   | 2018-12-01 00:00:00  | 0     |
| car-1   | 2018-12-01 01:00:00  | 50    |
| car-1   | 2018-12-01 02:00:00  | 100   |
| car-1   | 2018-12-01 03:00:00  | 120   |
| car-1   | 2018-12-01 04:00:00  | 200   |
```

## Query - LAG

```sql
SELECT entity, datetime, value,
  LAG(value),
  LAG(value, 3),
  LAG(value, 3, -1)
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  AND entity = 'car-1'
ORDER BY entity, tags, datetime
```

### Results

```ls
| entity  | datetime             | value  | lag(value)  | lag(value, 3)  | lag(value, 3, -1) |
|---------|----------------------|--------|-------------|----------------|-------------------|
| car-1   | 2018-12-01 00:00:00  | 0      |             |                | -1                |
| car-1   | 2018-12-01 01:00:00  | 50     | 0           |                | -1                |
| car-1   | 2018-12-01 02:00:00  | 100    | 50          |                | -1                |
| car-1   | 2018-12-01 03:00:00  | 120    | 100         | 0              | 0                 |
| car-1   | 2018-12-01 04:00:00  | 200    | 120         | 50             | 50                |
```

## Query - LEAD

```sql
SELECT entity, datetime, value,
  LAG(value),
  LAG(value, 3),
  LAG(value, 3, -1)
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  AND entity = 'car-1'
ORDER BY entity, tags, datetime
```

### Results

```ls
| entity  | datetime             | value  | lead(value)  | lead(value, 3)  | lead(value, 3, -1) |
|---------|----------------------|--------|--------------|-----------------|--------------------|
| car-1   | 2018-12-01 00:00:00  | 0      | 50           | 120             | 120                |
| car-1   | 2018-12-01 01:00:00  | 50     | 100          | 200             | 200                |
| car-1   | 2018-12-01 02:00:00  | 100    | 120          |                 | -1                 |
| car-1   | 2018-12-01 03:00:00  | 120    | 200          |                 | -1                 |
| car-1   | 2018-12-01 04:00:00  | 200    |              |                 | -1                 |
```

## Query - LAG without Partitioning

```sql
SELECT entity, datetime, value,
  LAG(value),
  LAG(value, 3),
  LAG(value, 3, -1)
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  --AND entity = 'car-1'
ORDER BY entity, tags, datetime
```

### Results

```txt
| entity  | datetime             | value  | lag(value)  | lag(value, 3)  | lag(value, 3, -1) |
|---------|----------------------|--------|-------------|----------------|-------------------|
| car-1   | 2018-12-01 00:00:00  | 0      |             |                | -1                |
| car-1   | 2018-12-01 01:00:00  | 50     | 0           |                | -1                |
| car-1   | 2018-12-01 02:00:00  | 100    | 50          |                | -1                |
| car-1   | 2018-12-01 03:00:00  | 120    | 100         | 0              | 0                 |
| car-1   | 2018-12-01 04:00:00  | 200    | 120         | 50             | 50                |
# Because the result set is not partitioned,
# LAG in row for car-2 entity is able to access previous rows even though they are for entity car-1
| car-2   | 2018-12-01 00:00:00  | 50     | 200         | 100            | 100               |
| car-2   | 2018-12-01 01:00:00  | 100    | 50          | 120            | 120               |
| car-2   | 2018-12-01 02:00:00  | 200    | 100         | 200            | 200               |
| car-2   | 2018-12-01 03:00:00  | 400    | 200         | 50             | 50                |
| car-2   | 2018-12-01 04:00:00  | 400    | 400         | 100            | 100               |
```

## Query - LAG with Partitioning

```sql
SELECT entity, datetime, value, row_number(),
  LAG(value),
  LAG(value, 3),
  LAG(value, 3, -1)
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  -- enable partitioning
  WITH ROW_NUMBER(entity, tags ORDER BY time) > 0
ORDER BY entity, tags, datetime
```

### Results

```txt
| entity  | datetime             | value  | row_number()  | lag(value)  | lag(value, 3)  | lag(value, 3, -1) |
|---------|----------------------|--------|---------------|-------------|----------------|-------------------|
| car-1   | 2018-12-01 00:00:00  | 0      | 1             |             |                | -1                |
| car-1   | 2018-12-01 01:00:00  | 50     | 2             | 0           |                | -1                |
| car-1   | 2018-12-01 02:00:00  | 100    | 3             | 50          |                | -1                |
| car-1   | 2018-12-01 03:00:00  | 120    | 4             | 100         | 0              | 0                 |
| car-1   | 2018-12-01 04:00:00  | 200    | 5             | 120         | 50             | 50                |
# Because the result set is partitioned,
# LAG in row for car-2 entity is not able to access previous rows for entity car-1
| car-2   | 2018-12-01 00:00:00  | 50     | 1             |             |                | -1                |
| car-2   | 2018-12-01 01:00:00  | 100    | 2             | 50          |                | -1                |
| car-2   | 2018-12-01 02:00:00  | 200    | 3             | 100         |                | -1                |
| car-2   | 2018-12-01 03:00:00  | 400    | 4             | 200         | 50             | 50                |
| car-2   | 2018-12-01 04:00:00  | 400    | 5             | 400         | 100            | 100               |
```

## LAG with Partitioning and `atsd_series` Table

```sql
SELECT metric, entity, datetime, value, row_number(),
  (value-LAG(value))/(time-LAG(time))*3600000 AS speed_per_interval
  FROM atsd_series
WHERE metric IN ('distance')
  AND datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  WITH ROW_NUMBER(metric, entity, tags ORDER BY metric, time) > 0
```

```txt
| metric    | entity  | datetime             | value  | row_number()  | speed_per_interval |
|-----------|---------|----------------------|--------|---------------|--------------------|
| distance  | car-1   | 2018-12-01 00:00:00  | 0      | 1             |                    |
| distance  | car-1   | 2018-12-01 01:00:00  | 50     | 2             | 50                 |
| distance  | car-1   | 2018-12-01 02:00:00  | 100    | 3             | 50                 |
| distance  | car-1   | 2018-12-01 03:00:00  | 120    | 4             | 20                 |
| distance  | car-1   | 2018-12-01 04:00:00  | 200    | 5             | 80                 |
| distance  | car-2   | 2018-12-01 00:00:00  | 50     | 1             |                    |
| distance  | car-2   | 2018-12-01 01:00:00  | 100    | 2             | 50                 |
| distance  | car-2   | 2018-12-01 02:00:00  | 200    | 3             | 100                |
| distance  | car-2   | 2018-12-01 03:00:00  | 400    | 4             | 200                |
| distance  | car-2   | 2018-12-01 04:00:00  | 400    | 5             | 0                  |
```