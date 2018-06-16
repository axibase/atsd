# Weekly Change Log: October 22, 2017 - October 29, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4671 | sql | Bug | Query with `ORDER BY datetime DESC` returns no rows. |
| 4669 |UI| Bug | Portal editor layout is broken in Firefox. |
| 4666 | api-rest | Bug | [Search API](../../api/meta/misc/search.md) method. Ensure `LastInsertDate` and `CreatedDate` millisecond precision. |
| 4664 | message | Bug | Tag filter is not applied if the tag is specified more than once. |
| [4663](#issue-4663) | installation | Feature | Adjust HBase and ATSD max heap size allocation based on available server memory. |
| 4662 | api-rest | Bug | Series query response contains escape symbol in the entity name. |
| [4656](#issue-4656) | api-rest | Feature | Implement series query with limit in DESC order. |
| 4644 | api-rest | Bug | Unicode patterns are not escaped in entity expression in series query. |
| 4640 | api-rest | Bug | Incorrect escaping in the entity filter. |
| 4635 | api-rest | Bug | Series query limit with ascending order. |
| [4631](#issue-4631) | sql | Bug | Filter not applied to `metric.name` field in the `WHERE` clause. |
| 4555 | sql | Bug | `NOT BETWEEN` operator error. |

## Axibase Collector

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4651 | docker | Bug | Host availability rule enhancements. |
| 4637 | docker | Bug | Freeze experienced on one of the containers with collector. |

---

### Issue 4663

* If RAM exceeds 4 GB, set Java max heap to 1 GB for HDFS, 1 GB for HBase, and 2 GB for ATSD.
* If RAM exceeds 8 GB, set Java max heap to 2 GB for HDFS, 4 GB for HBase, and 4 GB for ATSD.

### Issue 4656

```json
[{
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "limit":2,
  "direction": "DESC",
  "exactMatch":true
}]
```

### Issue 4631

```sql
SELECT datetime, value
  FROM "cache.size"
WHERE metric.name = 'cache.size'
  LIMIT 10
```
