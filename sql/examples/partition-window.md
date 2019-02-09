# Partition - Windows

## Query - Unbound Window

```sql
SELECT datetime, value, AVG(value), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime BETWEEN '2018-06-18T12:00:00Z' AND '2018-06-18T13:00:00Z' EXCL
  AND entity = 'nurswgvml007'
  WITH ROW_NUMBER(entity ORDER BY time) > 0
ORDER BY entity, datetime
```

### Results

```ls
| datetime            | value | avg(value) | count(value) |
|---------------------|-------|------------|--------------|
| 2018-06-18 12:00:13 |  12.2 |       12.2 |            1 |
| 2018-06-18 12:00:29 |   7.1 |        9.7 |            2 |
| 2018-06-18 12:00:45 |   8.0 |        9.1 |            3 |
| 2018-06-18 12:01:01 |   7.9 |        8.8 |            4 |
| 2018-06-18 12:01:17 |  27.3 |       12.5 |            5 |
| 2018-06-18 12:01:33 |   8.1 |       11.8 |            6 |
| 2018-06-18 12:01:49 |   8.1 |       11.2 |            7 |
| 2018-06-18 12:02:05 |   6.1 |       10.6 |            8 |
| 2018-06-18 12:02:21 |   9.2 |       10.4 |            9 |
| 2018-06-18 12:02:37 |  16.0 |       11.0 |           10 |
| 2018-06-18 12:02:53 |  10.0 |       10.9 |           11 |
| 2018-06-18 12:03:09 |   7.1 |       10.6 |           12 |
| 2018-06-18 12:03:25 |   3.0 |       10.0 |           13 |
| 2018-06-18 12:03:41 |  36.3 |       11.9 |           14 |
| 2018-06-18 12:03:57 |   3.1 |       11.3 |           15 |
...
```

## Query - Sliding Window

```sql
SELECT datetime, value, AVG(value), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime BETWEEN '2018-06-18T12:00:00Z' AND '2018-06-18T13:00:00Z' EXCL
  AND entity = 'nurswgvml007'
  WITH ROW_NUMBER(entity ORDER BY time) BETWEEN 5 PRECEDING AND CURRENT ROW
ORDER BY entity, datetime
```

### Results

```ls
| datetime            | value | avg(value) | count(value) |
|---------------------|-------|------------|--------------|
| 2018-06-18 12:00:13 |  12.2 |       12.2 |            1 |
| 2018-06-18 12:00:29 |   7.1 |        9.7 |            2 |
| 2018-06-18 12:00:45 |   8.0 |        9.1 |            3 |
| 2018-06-18 12:01:01 |   7.9 |        8.8 |            4 |
| 2018-06-18 12:01:17 |  27.3 |       12.5 |            5 |
| 2018-06-18 12:01:33 |   8.1 |       11.7 |            5 |
| 2018-06-18 12:01:49 |   8.1 |       11.9 |            5 |
| 2018-06-18 12:02:05 |   6.1 |       11.5 |            5 |
| 2018-06-18 12:02:21 |   9.2 |       11.7 |            5 |
| 2018-06-18 12:02:37 |  16.0 |        9.5 |            5 |
```