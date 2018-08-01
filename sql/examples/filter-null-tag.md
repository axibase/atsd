# Filter Series without Specified Tag

Select a series without the specified tag using the `tags.{name} IS NULL` condition.

## Data

```ls
| entity  | datetime                 | value | tags.tag1 | tags.tag2 | tags.tag4 |
|---------|--------------------------|-------|-----------|-----------|-----------|
| e-sql-1 | 2016-06-19T11:00:00.000Z | 1.0   | val1      | null      | null      |
| e-sql-2 | 2016-06-19T11:00:00.000Z | 2.0   | val2      | val2      | null      |
| e-sql-3 | 2016-06-19T11:00:00.000Z | 3.0   | null      | val3      | null      |
| e-sql-4 | 2016-06-19T11:00:00.000Z | 4.0   | null      | null      | val4      |
```

## Query

Select a series without `tag4` using the `IS NULL` operator:

```sql
SELECT entity, datetime, value, tags.*
  FROM "m-metric1"
WHERE datetime >= '2016-06-19T11:00:00.000Z' AND datetime < '2016-06-19T12:00:00.000Z'
  AND tags.tag4 IS NULL
```

## Results

```ls
| entity  | datetime                 | value | tags.tag1 | tags.tag2 | tags.tag4 |
|---------|--------------------------|-------|-----------|-----------|-----------|
| e-sql-1 | 2016-06-19T11:00:00.000Z | 1.0   | val1      | null      | null      |
| e-sql-2 | 2016-06-19T11:00:00.000Z | 2.0   | val2      | val2      | null      |
| e-sql-3 | 2016-06-19T11:00:00.000Z | 3.0   | null      | val3      | null      |
```

## Query

Select a series with `tag4` using the `IS NOT NULL` operator:

```sql
SELECT entity, datetime, value, tags.*
  FROM "m-metric1"
WHERE datetime >= '2016-06-19T11:00:00.000Z' AND datetime < '2016-06-19T12:00:00.000Z'
  AND tags.tag4 IS NOT NULL
```

## Results

```ls
| entity  | datetime                 | value | tags.tag1 | tags.tag2 | tags.tag4 |
|---------|--------------------------|-------|-----------|-----------|-----------|
| e-sql-4 | 2016-06-19T11:00:00.000Z | 4.0   | null      | null      | val4      |
```

## Query

Operators, except `IS NULL` and `IS NOT NULL`, return `NULL` if any operand is `NULL`.

The query returns only two rows, because `(tags.tag1 = 'a' OR tags.tag1 != 'a')` returns `NULL` for entities `e-sql-3` and `e-sql-4`.

```sql
SELECT entity, datetime, value, tags.*
  FROM "m-metric1"
WHERE datetime >= '2016-06-19T11:00:00.000Z' AND datetime < '2016-06-19T12:00:00.000Z'
  AND (tags.tag1 = 'a' OR tags.tag1 != 'a')
```

```ls
| entity  | datetime                 | value | tags.tag1 | tags.tag2 | tags.tag4 |
|---------|--------------------------|-------|-----------|-----------|-----------|
| e-sql-1 | 2016-06-19T11:00:00.000Z | 1.0   | val1      | null      | null      |
| e-sql-2 | 2016-06-19T11:00:00.000Z | 2.0   | val2      | val2      | null      |
```
