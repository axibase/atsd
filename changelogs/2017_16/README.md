# Weekly Change Log: April 17 - April 23, 2017

## ATSD

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|---------------------------------------------------------------------|
| 4102 | jdbc | Feature | Add support for BOOLEAN data type in ATSD JDBC driver. |
| 4101 | sql | Bug | Enforce 1970-01-01 UTC as the minimal interval start for [PERIOD](../../sql#period) function. |
| [4100](#issue-4100) | sql | Feature | Add support for custom time zones in [PERIOD](../../sql#period) aggregation.  |
| 4051 | rule engine | Feature | Rename `date` function to [date_parse](../../rule-engine/functions-time.md#the-date_parse-function). |

## Collector

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|---------------------------------------------------------------------|
| [4094](#issue-4094) | docker | Feature | Upgrade supported Remote API versions from 1.21 to 1.28.  |
| 4044 | docker | Bug | Handle HTTP request timeouts for Unix socket. |

### Issue 4100

```sql
SELECT datetime,
  date_format(time, "yyyy-MM-dd HH:mm:ss", "Europe/Vienna") AS local_datetime,
  MIN(value), MAX(value)
FROM m1
  GROUP BY PERIOD(1 DAY, "Europe/Vienna")
```

### Issue 4094

![](./Images/Figure1.png)
