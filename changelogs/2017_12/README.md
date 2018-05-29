# Weekly Change Log: March 20 - March 26, 2017

## ATSD

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 4037 | sql | Bug | Ignore deleted entities with pending delete action from results. |
| [3915](#issue-3915) | api-rest | Feature | Add support for `tagExpression` parameter in [series query](../../api/data/series/query.md#series-filter-fields) method to filter returned series by tag value condition (multiple tags, negation). |
| 4005 | sql | Bug | Fix ArrayIndexOutOfBoundsException error in external serializer. |
| 4008 | sql | Feature | Implement a custom serializer for external sorting. |
| 3924 | UI | Feature | Add syntax highlighting to configuration files in the [Configuration Files Editor](../../administration/editing-configuration-files.md). |
| 3852 | sql | Feature | Add support for [column alias](../../sql/examples/alias-column.md) for columns created with [`CASE`](../../sql#case) expression. |
| 4034 | sql | Bug | Incorrect filtering of rows with multiple [`LIKE` expressions](../../sql#like-expression) combined with OR operator. |
| 4030 | sql | Bug | Add support for metric [`LIKE` expression](../../sql#like-expression) in `FROM atsd_series` queries. |
| [4029](#issue-4029) | UI | Feature | Consolidate diagnostic tool links on the **Settings: Diagnostics** page. |
| 4027 | sql | Bug | Metric tags and fields are set to `null` in [`JOIN`](../../sql#joins) queries.|
| 4003 | csv | Bug | Enforce 1GB limit on CSV files uploaded using [csv-upload](../../api/data/ext/csv-upload.md) method.|
| 4028 | sql | Bug | Fix `ORDER BY tag.name` if some series don't have values for the tag used in sorting. |
| 4002 | sql | Feature | Implement `GROUP BY` for the `text` column |
| 3945 | sql | Bug | Remove rows with non-existing tags in [`JOIN`](../../sql#joins) queries. |
| [3882](#issue-3882) | sql | Feature | Add support for metric fields in SQL queries. |
| 3855 | sql | Bug | Fix `GROUP BY` operation on entity.label field. |
| 4013 | sql | Bug | Allow `tags.*` expression in the `SELECT` clause if `GROUP BY` clause contains `tags` column.  |
| 4014 | sql | Bug | `BETWEEN` condition cannot be combined with other conditions in the `WHERE` clause. |

### Collector

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 3989 | json | Bug | Unescape HTML-escaped values in textarea with syntax highlight. |
| [3682](#issue-3682) | pi | Feature | Implement the PI job to copy incremental PI tag values using the JDBC driver. |
| [3996](#issue-3996) | socrata | Feature | Display top-10 rows in tabular format in Test mode. |
| 4026 | core | Bug | Add support for specific dates in ISO 8601 format in [calendar](../../shared/calendar.md#specific-time) expressions. |
| 4019 | docker | Bug | Do not interrupt the job if there are no free ATSD connections in pool. |
| 4025 | core | Bug | Remove `m:{name}=NaN` field in `series` command if text value is specified. |

### Issue 3915

[Documentation](../../api/data/series/query.md)

URI

```elm
POST /api/v1/series/query
```

Payload

```json
[{
  "startDate": "2017-02-13T08:00:00Z",
  "endDate":   "2017-02-13T09:00:00Z",
  "entity": "nurswgvml007",
  "metric": "disk_used",
  "tagExpression": "tags.file_system NOT LIKE '*your-backup*'",
  "limit": 1
}]

```

Response

```json
[{"entity":"nurswgvml007","metric":"disk_used","tags":{"file_system":"/dev/mapper/vg_nurswgvml007-lv_root","mount_point":"/"},"type":"HISTORY","aggregate":{"type":"DETAIL"},"data":[{"d":"2017-02-13T08:59:53.000Z","v":9242420.0}]}]
```

### Issue 4029

![](./Images/Figure1.png)

### Issue 3882

[List of predefined columns](../../sql/README.md#predefined-columns)

### Collector

### Issue 3682

![](./Images/Figure2.png)

### Issue 3996

![](./Images/Figure3.png)
