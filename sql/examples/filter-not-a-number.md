# Filter Not-a-Number

Not a number value is returned as a `NaN` string, across all formats: HTML, JSON, CSV.

Aggregate functions ignore `NaN` values, except for the `count` function which counts `NaN` as any other value.

## Query

```sql
SELECT *
 FROM "m-n-1"
WHERE datetime between '2016-07-15T15:40:00.000Z' AND '2016-07-15T15:41:00.000Z'
```

## Results

```ls
| entity | datetime                 | value |
|--------|--------------------------|-------|
| e-1    | 2016-07-15T15:40:20.000Z | 10    |
| e-1    | 2016-07-15T15:40:40.000Z | NaN   |
| e-1    | 2016-07-15T15:40:50.000Z | 24.5  |
```

### `sql.csv`

```txt
entity,datetime,value
e-1,2016-07-15T15:40:20.000Z,10
e-1,2016-07-15T15:40:40.000Z,NaN
e-1,2016-07-15T15:40:50.000Z,24.5
```

## Exclude `NaN`

```sql
SELECT avg(value), min(value), count(value)
 FROM "m-n-1"
WHERE datetime between '2016-07-15T15:40:00.000Z' AND '2016-07-15T15:41:00.000Z'
 AND value IS NOT NULL
```

## Results

```ls
| avg(value) | min(value) | count(value) |
|------------|------------|--------------|
| 17.25      | 10         | 2            |
```

## Aggregate Query

```sql
SELECT avg(value), min(value), count(value)
 FROM "m-n-1"
WHERE datetime between '2016-07-15T15:40:00.000Z' AND '2016-07-15T15:41:00.000Z'
```

## Results

```ls
| avg(value) | min(value) | count(value) |
|------------|------------|--------------|
| 17.25      | 10         | 3            |
```
