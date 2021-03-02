# Filter Series with String Operators

The string comparison operators `<, >, <=, >=` allow you to filter tag values lexicographically.

If one of the compared values is `NULL`, the expression returns `NULL` and such rows are excluded by the `WHERE` clause.

## `NULL` filter

### Data

```ls
| entity  | datetime                 | value | tags.tag2 | > 'val2' | <= 'val2' |
|---------|--------------------------|-------|-----------|----------|-----------|
| e-sql-1 | 2016-06-19T11:00:00.000Z | 1.0   | null      | NULL     | NULL      |
| e-sql-2 | 2016-06-19T11:00:00.000Z | 2.0   | val2      | false    | true      |
| e-sql-3 | 2016-06-19T11:00:00.000Z | 3.0   | val3      | true     | false     |
| e-sql-4 | 2016-06-19T11:00:00.000Z | 4.0   | null      | NULL     | NULL      |
```

### Query: greater comparator

```sql
SELECT datetime, value, tags.tag2
  FROM "m-metric1"
WHERE datetime >= '2016-06-19T11:00:00.000Z'
  AND tags.tag2 > 'val2'
```

#### Results

```ls
| datetime                 | value | tags.tag2 |
|--------------------------|-------|-----------|
| 2016-06-19T11:00:00.000Z | 3.0   | val3      |
```

### Query: less than or equal comparator

Note that a series without a `tag2` series tag, which is the same as a `NULL` value, are not included in either result set.

```sql
SELECT datetime, value, tags.tag2
  FROM "m-metric1"
WHERE datetime >= '2016-06-19T11:00:00.000Z'
  AND tags.tag2 <= 'val2'
```

#### Results

```ls
| datetime                 | value | tags.tag2 |
|--------------------------|-------|-----------|
| 2016-06-19T11:00:00.000Z | 2.0   | val2      |
```

## Collation Filter

Strings are compared based on the Unicode value of their characters.

### Data

```ls
| tags.'tag-1' | unicode-1 |
|--------------|-----------|
| null         | null      |
| .            | U+002E    |
| 01           | U+0030    |
| 1            | U+0031    |
| 10           | U+0031    |
| 11           | U+0031    |
| 2            | U+0032    |
| 20           | U+0032    |
| 3            | U+0033    |
| 30           | U+0033    |
| A            | U+0041    |
| AB           | U+0041    |
| B            | U+0042    |
| Resumes      | U+0052    |
| Résumé       | U+0052    |
| a            | U+0061    |
| a¨b          | U+0061    |
| resume       | U+0072    |
| resumes      | U+0072    |
| résumé       | U+0072    |
| résumés      | U+0072    |
| á            | U+00E1    |
| ä            | U+00E4    |
| äa           | U+00E4    |
| äb           | U+00E4    |
| äc           | U+00E4    |
| é            | U+00E9    |
| ÿ            | U+00FF    |
| ā            | U+0101    |
| ǎ            | U+01CE    |
| α            | U+03B1    |
| а            | U+0430    |
```

### Query: >= to Filter by Character Unicode Value

```sql
SELECT tags.'tag-1', tags.'tag-unicode-1' AS "unicode-1"
  FROM "m-order"
WHERE entity = 'e-1'
  AND tags.'tag-1' >= 'ä'
ORDER BY tags.'tag-1' ASC
```

#### Results

```ls
| tags.'tag-1' | unicode-1 |
|--------------|-----------|
| ä            | U+00E4    |
| äa           | U+00E4    |
| äb           | U+00E4    |
| äc           | U+00E4    |
| é            | U+00E9    |
| ÿ            | U+00FF    |
| ā            | U+0101    |
| ǎ            | U+01CE    |
| α            | U+03B1    |
| а            | U+0430    |
```

### Query: Numbers by Character Unicode Value if One of the Values is a Character

```sql
SELECT tags.'tag-1', tags.'tag-unicode-1' AS "unicode-1"
  FROM "m-order"
WHERE entity = 'e-1'
  AND tags.'tag-1' >= '0' AND tags.'tag-1' <= '3'
ORDER BY tags.'tag-1' ASC
```

#### Results

```ls
| tags.'tag-1' | unicode-1 |
|--------------|-----------|
| 01           | U+0030    |
| 1            | U+0031    |
| 10           | U+0031    |
| 11           | U+0031    |
| 2            | U+0032    |
| 20           | U+0032    |
| 3            | U+0033    |
```

### Query: Numbers by Numeric Value if Both Values are Numeric

If all series tag values are guaranteed to be numeric or `null`, the values can be compared as numbers, however ordering of such columns is still based on an Unicode value (string collation).

#### Data

```sql
| entity | tags.'tag-1' | unicode-1 |
|--------|--------------|-----------|
| e-3    | 1            | U+0031    |
| e-3    | 10           | U+0031    |
| e-3    | 11           | U+0031    |
| e-3    | 2            | U+0032    |
| e-3    | 20           | U+0032    |
| e-3    | 3            | U+0033    |
| e-3    | 30           | U+0033    |
```

```sql
SELECT tags.'tag-1', tags.'tag-unicode-1' AS "unicode-1"
  FROM "m-order"
WHERE entity = 'e-3'
  AND tags.'tag-1' > 1 AND tags.'tag-1' <= 20
ORDER BY tags.'tag-1' ASC
```

#### Results

```ls
| tags.'tag-1' | unicode-1 |
|--------------|-----------|
| 10           | U+0031    |
| 11           | U+0031    |
| 2            | U+0032    |
| 20           | U+0032    |
| 3            | U+0033    |
```
