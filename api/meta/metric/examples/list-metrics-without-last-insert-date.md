# List Metrics without Last Insert Date

List metrics without `lastInsertDate`. This can occur when the data collected for the metric is subsequently deleted, for example when all entities collecting this metric are deleted, or when old data is pruned according to retention day or series retention day parameters.

To retrieve metrics without `lastInsertDate`, set `maxInsertDate` to `1970-01-01T00:00:00Z` or earlier.

## Request

### URI

```elm
GET /api/v1/metrics?maxInsertDate=1970-01-01T00:00:00Z&limit=3
```

## Response

```json
[{
   "name": "%a",
   "enabled": true,
   "dataType": "FLOAT",
   "persistent": true,
   "timePrecision": "MILLISECONDS",
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "versioned": false,
   "interpolate": "LINEAR",
   "createdDate": "2017-10-03T07:03:45.558Z"
}, {
   "name": "aws_ebs.volumeconsumedreadwriteops.average",
   "enabled": true,
   "dataType": "FLOAT",
   "persistent": true,
   "timePrecision": "MILLISECONDS",
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "versioned": false,
   "interpolate": "LINEAR"
}, {
   "name": "aws_ebs.volumeconsumedreadwriteops.maximum",
   "enabled": true,
   "dataType": "FLOAT",
   "persistent": true,
   "timePrecision": "MILLISECONDS",
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "versioned": false,
   "interpolate": "LINEAR"
}]
```
