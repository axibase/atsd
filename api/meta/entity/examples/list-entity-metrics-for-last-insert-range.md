# List Entity Metrics for Last Insert Date Range

List metrics for entity `nurswgvml007` with `lastInsertDate` within the specified range. To exclude metrics without `lastInsertDate`, set `minInsertDate` to `1970-01-01T00:00:00Z`.

## Request

### URI

```elm
GET /api/v1/entities/nurswgvml007/metrics?minInsertDate=2012-01-01T00:00:00Z&maxInsertDate=2018-10-30T00:00:00Z
```

## Response

```json
[
  {
    "name": "ntp.current_source",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": false,
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2018-10-09T17:12:31.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```