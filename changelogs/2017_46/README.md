Weekly Change Log: November 13, 2017 - November 19, 2017
==================================================

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| [4718](#issue-4718) | data-api | Feature | Add support for additional [percentile functions](../../api/data/aggregation.md) in the [series query](../../api/data/series/query.md) method:<br>PERCENTILE_25 = 25% percentile<br>PERCENTILE_10 = 10% percentile<br>PERCENTILE_5 =  5% percentile<br>PERCENTILE_1 = 1% percentile<br>PERCENTILE_05 = 0.5% percentile<br>PERCENTILE_01 = 0.1% percentile |
| [4714](#issue-4714) | data-api | Bug | Fix error when the [series query](../../api/data/series/query.md) request includes two queries with aggregations using different periods. |
| 4709 | portal | Support | Upgrade the built-in portals to the latest syntax by removing Freemarker functions where possible. |
| [4708](#issue-4708) | sql | Bug | `LIMIT` clause not applied correctly with `ORDER BY datetime DESC`. |
| [4707](#issue-4707) |UI| Feature | Multiple user interface enhancements. |
| [4706](#issue-4706) | install | Feature | Add support for JVM environment variables in the ATSD [Docker image](https://github.com/axibase/dockers#environment-variables). |
| [4588](#issue-4588) | sql | Feature | Allow referencing the entity column in the `atsd_series` metric filter. |

## Axibase Collector

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4720 | docker | Bug | Increase Docker API request timeout from 3 to 10 seconds to eliminate errors when the container properties are requested with `size` flag.  |
| 4696 | core | Bug | Update the built-in ATSD JDBC driver url definition according the [url schema](https://github.com/axibase/atsd-jdbc#jdbc-url).  |
| 4677 | docker | Bug | Delete stale records for deleted containers from the embedded database. |

## Charts

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4699 | core | Bug | Prevent duplicate series from being displayed when creating derived series from wildcard series.  |
| [4611](#issue-4611) | bar | Feature | Add support for `multiple-column` setting to group wildcard series by unique entity and tags. |

---

### Issue 4718

```json
[
  {
    "startDate": "2017-11-17T14:00:00Z",
    "endDate":   "2017-11-17T15:00:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {
      "period": { "count": 5, "unit": "MINUTE"},
      "types": ["MEDIAN", "PERCENTILE_5", "PERCENTILE_95"]
    }
  }
]
```

### Issue 4714

```json
[
  {
    "startDate": "2017-11-17T14:00:00Z",
    "endDate":   "2017-11-17T15:00:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {
      "period": { "count": 15, "unit": "MINUTE"},
      "type": "MAX"
    }
  },
  {
    "startDate": "2017-11-17T14:00:00Z",
    "endDate":   "2017-11-17T15:00:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {
      "period": { "count": 1, "unit": "MINUTE"},
      "type": "MAX"
    }
  }  
]
```

### Issue 4708

The query with `ORDER BY datetime DESC LIMIT n` was returning only 1 record instead of `n`.

```sql
SELECT datetime, value, tags.city, tags.state,
  FROM "cdc.pneumonia_and_influenza_cases"
WHERE tags.city = 'Boston'
  ORDER BY datetime DESC
LIMIT 10
```

### Issue 4707

* Add group action to **Settings > Users** page to Enable/Disable multiple users at once.
* Implement a consistent style to highlight fields with tooltips.
* Auto-size sub-menu panels in the top menu.

### Issue 4706

New environmental variables:

| **Name** | **Required** | **Description** |
|:---|:---|:---|
|`JAVA_OPTS` | No | Additional arguments to be passed to ATSD JVM process. |
|`HADOOP_OPTS` | No | Additional arguments to be passed to Hadoop/HDFS JVM processes. |
|`HBASE_OPTS` | No | Additional arguments to be passed to HBase JVM processes. |

### Issue 4588

The metric filter in `atsd_series` queries can now accept entity column as part of the filter:

```sql
SELECT metric, entity, tags, date_format(MAX(time)) as "max_time"
  FROM atsd_series
WHERE datetime >= NOW - 14*DAY -- condition to select series with last insert date within the last 14 days
  AND ( metric = 'disk_used' AND entity IN ('nurswgvml006', 'nurswgvml007', 'nurswgvml010', 'nurswgvml502')
     OR metric = 'cpu_user'  AND entity IN ('nurswgvml010', 'nurswgvml502')
     OR metric = 'cpu_busy'  AND entity = 'nurswgvml006'
      )
GROUP BY metric, entity, tags
  HAVING MAX(time) < NOW - 24 * HOUR -- condition to exclude series that have recent data
```


---

### Issue 4611

The `multiple-column` setting is applicable to wildcard configurations in bar widgets.

If the settings is set to `true`, series with the same entity and tags are added to the same column.

This applies to derived series which will be placed into the same column along with the underlying series.

```ls
[widget]
  type = bar
  group = label-format
  hide-empty-columns = true
  column-label-format = tags.mount_point

 [tags]
    mount_point = *
    file_system = *

  [column]
    multiple-column = true
  [series]
    label = Used
    alias = used
    metric = disk_used
    color = green
  [series]
    label = Size
    alias = size
    metric = disk_size
    color = orange
    display = false
  [series]
    label = Free
    value = value("size") - value("used")
    color = grey
```

Examples:

* https://apps.axibase.com/chartlab/6e37edc8/2/
* https://apps.axibase.com/chartlab/1b8d6e3f/1/
