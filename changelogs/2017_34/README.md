Weekly Change Log: August 21, 2017 - August 28, 2017
==================================================
### ATSD
| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4512 | core | Bug | Unsupported compression algorithm name normalized among new installation software |
| 4493 | core | Bug | Reporter error repaired |
| 4459 | UI | Bug | Replacement tables re-formatted |
| 4451 | UI | Bug | Button order standardized throughout database interface |
| 4444 | sql | Bug | Double datatype enabled for negative integers |
| [4133](#issue-4133) | sql | Feature | Support for the Oracle-native method of [Inline Views](https://github.com/axibase/atsd/tree/master/api/sql#inline-views) added. |
| 4111 | UI | Bug | Unexpected error message on export page for some special tag keys |
| 3948 | api-rest | Bug | Bug repaired which incorrectly handled OPTIONS requests containing a [wildcard symbol](https://github.com/axibase/atsd/tree/master/api/sql#match-expressions) | 

### Issue 4133

* Inline Views allow nested sub-queries to be operated on by the parent query.

* Sub-query values must use reserved column names such as "datetime" and "value."

* Unlimited sub-queries supported.

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
