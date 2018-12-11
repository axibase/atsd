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
| car-2   | 2018-12-01 00:00:00  | 50     | 200         | 100            | 100               |
| car-2   | 2018-12-01 01:00:00  | 100    | 50          | 120            | 120               |
| car-2   | 2018-12-01 02:00:00  | 200    | 100         | 200            | 200               |
| car-2   | 2018-12-01 03:00:00  | 400    | 200         | 50             | 50                |
| car-2   | 2018-12-01 04:00:00  | 400    | 400         | 100            | 100               |
```

## Query - LAG with Partitioning

```sql
SELECT entity, datetime, value,
  LAG(value),
  LAG(value, 3),
  LAG(value, 3, -1)
  FROM "distance"
WHERE datetime BETWEEN '2018-12-01T00:00:00Z' AND '2018-12-01T05:00:00Z' EXCL
  --AND entity = 'car-1'
  WITH ROW_NUMBER(entity, tags ORDER BY time) > 0
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
| car-2   | 2018-12-01 00:00:00  | 50     |             |                | -1                |
| car-2   | 2018-12-01 01:00:00  | 100    | 50          |                | -1                |
| car-2   | 2018-12-01 02:00:00  | 200    | 100         |                | -1                |
| car-2   | 2018-12-01 03:00:00  | 400    | 200         | 50             | 50                |
| car-2   | 2018-12-01 04:00:00  | 400    | 400         | 100            | 100               |
```