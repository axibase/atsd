Weekly Change Log: August 21, 2017 - August 28, 2017
==================================================
### ATSD
| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4512 | core | Bug | Normalize compression algorithm names supported by `hbase.compression.type` and `hbase.compression.type.raw` settings: `none`, `gz`, `lzo`. |
| 4493 | core | Bug | Fix an issue with region bounderies with [migration reporter](https://github.com/axibase/atsd/blob/master/administration/migration/reporter.md). |
| 4459 | UI | Bug | Apply syntax highligting to **Configuration > Replacement Tables**. |
| 4451 | UI | Bug | Standartize the order of form buttons throughout the interface. |
| 4444 | sql | Bug | Fix metadata error which caused negative integers to be classified as Double columns. |
| [4133](#issue-4133) | sql | Feature | Add support for [inline views](https://github.com/axibase/atsd/tree/master/api/sql#inline-views). |
| 4111 | UI | Bug | Fix error message if unknown tags are displayed on the Export tab. |
| 3948 | api-rest | Bug | Set correct headers for `OPTIONS` requests. | 

### Issue 4133

* [Inline View](https://github.com/axibase/atsd/tree/master/api/sql#inline-views) allows a nested sub-query to be operated on by the containing query.

* Sub-query values must use reserved column names such as "datetime" and "value."

* Unlimited sub-queries are supported.

**Sample Query**

```sql
SELECT datetime, AVG(value) AS "daily_average" 
  FROM -- actual table replaced with subquery
  (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
GROUP BY PERIOD(1 DAY)
```

**Sample ResultSet**

```ls
| datetime            | daily_average | 
|---------------------|---------------| 
| 2017-08-14 00:00:00 | 96.1          | 
| 2017-08-15 00:00:00 | 96.6          | 
| 2017-08-16 00:00:00 | 98.8          | 
| 2017-08-17 00:00:00 | 95.4          | 
| 2017-08-18 00:00:00 | 98.3          | 
| 2017-08-19 00:00:00 | 96.1          | 
| 2017-08-20 00:00:00 | 93.8          | 
```
