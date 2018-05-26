# List Entity Metrics by Min and Max Value

List metrics for entity `nurswgvml007` with `minValue > -10` or `maxValue < 80`

## Request

### URI

```elm
GET /api/v1/entities/nurswgvml007/metrics?expression=minValue%20%3E%20-10%20OR%20maxValue%20%3C%2080
```

### Expression

```javascript
minValue > -10 OR maxValue < 80
```

## Response

```json
[
  {
    "name": "cpu_busy",
    "enabled": true,
    "dataType": "DECIMAL",
    "label": "CPU Busy %",
    "persistent": true,
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "minValue": 0,
    "maxValue": 100,
    "invalidAction": "TRANSFORM",
    "lastInsertDate": "2018-05-23T16:24:35.000Z",
    "versioned": false,
    "interpolate": "LINEAR",
    "timeZone": "US/Eastern"
  },
  {
    "name": "disk_used_percent",
    "enabled": true,
    "dataType": "DECIMAL",
    "label": "Disk Used, %",
    "persistent": true,
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "seriesRetentionDays": 60,
    "minValue": 0,
    "maxValue": 100,
    "invalidAction": "TRANSFORM",
    "lastInsertDate": "2018-05-23T16:24:36.000Z",
    "filter": "!likeAny(tags.mount_point, collection('ignore-collector-mount-points'))",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```