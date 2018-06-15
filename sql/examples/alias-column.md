# Column Alias

Column aliases can be unquoted or enclosed in quotes or double-quotes.

An unquoted `alias` must start with a letter `[a-zA-Z]`, followed by a letter, digit, or underscore.

## Query

```sql
SELECT datetime, value, entity "server", metric AS "measurement"
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime BETWEEN now - 5 * minute AND now
```

## Results

```ls
| datetime                 | value | server       | measurement |
|--------------------------|-------|--------------|-------------|
| 2016-07-15T09:20:34.000Z | 3.0   | nurswgvml006 | cpu_busy    |
| 2016-07-15T09:20:50.000Z | 7.1   | nurswgvml006 | cpu_busy    |
| 2016-07-15T09:21:06.000Z | 7.1   | nurswgvml006 | cpu_busy    |
| 2016-07-15T09:21:22.000Z | 6.0   | nurswgvml006 | cpu_busy    |
```
