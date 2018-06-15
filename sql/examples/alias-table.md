# Table Alias

A table alias is typically used in `JOIN` queries to provide a convenient way of referencing columns in a specific table as part of a `SELECT` expression.

Similar to column aliases, a table alias can be unquoted or enclosed in quotes or double-quotes.

An unquoted `alias` must start with a letter `[a-zA-Z]`, followed a by letter, digit, or underscore.

## Query

```sql
SELECT t1.datetime, t1.entity, t1.value AS cpu_sys, t2.value AS cpu_usr
  FROM "mpstat.cpu_system" t1
  JOIN "mpstat.cpu_user" t2
WHERE t1.datetime > now - 1*MINUTE
  ORDER BY datetime
```

## Results

```ls
| datetime                 | t1.entity    | cpu_sys | cpu_usr |
|--------------------------|--------------|---------|---------|
| 2016-07-15T09:12:01.000Z | nurswgvml009 | 1.0     | 2.0     |
| 2016-07-15T09:12:02.000Z | nurswgvml006 | 2.0     | 3.0     |
| 2016-07-15T09:12:05.000Z | nurswgvml011 | 0.0     | 1.0     |
| 2016-07-15T09:12:07.000Z | nurswgvml502 | 0.5     | 0.0     |
```

## All Table Columns Query

If multiple tables are joined in the query, the `SELECT` expression can include all columns for a particular table using `{table-alias}.*` syntax.

```sql
SELECT t1.*, t2.value AS cpu_usr
  FROM "mpstat.cpu_system" t1
  JOIN "mpstat.cpu_user" t2
WHERE t1.datetime > now - 1*MINUTE
  ORDER BY datetime
```

## Results

```ls
| t1.entity    | t1.datetime              | t1.value | cpu_usr |
|--------------|--------------------------|----------|---------|
| nurswgvml102 | 2016-07-15T09:21:15.000Z | 0.0      | 2.0     |
| nurswgvml007 | 2016-07-15T09:21:18.000Z | 2.0      | 3.0     |
| nurswgvml010 | 2016-07-15T09:21:18.000Z | 0.2      | 0.0     |
| nurswgvml006 | 2016-07-15T09:21:22.000Z | 2.0      | 4.0     |
```
