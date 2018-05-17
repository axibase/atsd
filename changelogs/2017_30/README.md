# Weekly Change Log: July 24, 2017 - July 30, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4419 | sql | Bug | IndexOutOfBoundsException fixed in queries that referred to a non-existent metric. |
| 4417 | sql | Bug | Fixed a NullPointerException if all columns were selected for a new metric without any samples. |
| [4416](#Issue-4416) | api-network | Feature | `Invalid Action (a)` string field added to the [`metric`](../../api/network/metric.md#metric-command) command
| [4403](#Issue-4403) | sql | Bug | Added syntax validation for the [`IN`](../../sql#where-clause) clause to require enclosing brackets. |
| [4377](#Issue-4377) | sql | Feature | Add support for selecting all columns in [inline views](../../sql#inline-views). |
| [4361](#Issue-4361) | sql | Feature | Add support for compressed CSV files in scheduled [SQL query export](../../sql/scheduled-sql.md) |
| [3918](#Issue-3918) | api-rest | Bug | Replace `last=true` with `limit=1` in Series [URL query](../../api/data/series/url-query.md) method. |

### Issue 4416

**[`metric`](../../api/network/metric.md#metric-command) Command Syntax**:

```css
metric m:{metric} b:{enabled} p:{data-type} l:{label} d:{description} i:{interpolate} u:{units} f:{filter} z:{timezone} v:{versioning} a:{invalid_action} min:{minimum_value} max:{maximum_value} t:{tag-1}={text} t:{tag-2}={text}
```

### Issue 4403

This query will now cause an error:

```sql
SELECT * FROM jvm_memory_used
  WHERE value IN 169328488
  AND datetime > NOW - 10*HOUR
```

The correct syntax is to use brackets:

```sql
SELECT * FROM jvm_memory_used
  WHERE value IN (169328488)
  AND datetime > NOW - 10*HOUR
```

### Issue 4377

Add support for selecting all columns with an asterisk (`*`) symbol in inline views:

```sql
SELECT TableauSQL.datetime AS datetime,
  TableauSQL.value AS value
FROM ( select * from table_size ) TableauSQL
  LIMIT 10
```

### Issue 4361

Compression for CSV report files can be selected on the **Configuration > SQL Queries** page.

![](./Images/4361.png)

### Issue 3918

 `last=true` is replaced with `limit=1` and `direction=DESC`.

```json
[{
  "startDate": "2017-02-28T19:00:00Z",
  "endDate":   "2017-02-28T20:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "limit": 1
}]
```
