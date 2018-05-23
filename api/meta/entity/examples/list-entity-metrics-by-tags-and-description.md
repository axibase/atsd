# List Entity Metrics by Tags and Description

List metrics for entity `nurswgvml007` with not empty tags and description.

## Request

### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?expression=description%20!%3D%20%27%27%20AND%20!tags.isEmpty()
```

### Expression

```javascript
description != '' AND !tags.isEmpty()
```

## Response

```json
[
  {
    "name": "active",
    "enabled": true,
    "dataType": "FLOAT",
    "description": "this metric measures active memory in Linux systems",
    "persistent": true,
    "tags": {
      "unit": "bytes"
    },
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2018-05-23T15:31:52.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```