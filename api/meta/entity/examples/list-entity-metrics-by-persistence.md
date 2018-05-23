# List Entity Metrics by Persistence Status.

List metrics for entity `nurswgvml007` that are not stored in the database and are only processed by the rule engine.

## Request

### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?expression=persistent%3Dfalse
```

### Expression

```javascript
persistent=false
```

## Response

```json
[
  {
    "name": "ntp.current_source",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": false,
    "tags": {},
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2015-10-09T17:12:31.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```