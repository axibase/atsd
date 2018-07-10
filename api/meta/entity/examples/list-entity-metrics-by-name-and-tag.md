# List Entity Metrics by Name and Tag

List metrics starting with `nmon` and with tag `table` starting with `CPU` for entity `nurswgvml007`.

## Request

### URI

```elm
GET /api/v1/entities/nurswgvml007/metrics?tags=table&limit=2&expression=name%20LIKE%20%27nmon*%27%20and%20tags.table%20LIKE%20%27*CPU*%27
```

### Expression

```javascript
name LIKE 'nmon*' AND tags.table LIKE '*CPU*'
```

## Response

```json
[
  {
    "name": "nmon.cpu.busy%",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "tags": {
      "table": "CPU Detail"
    },
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2018-05-23T11:52:22.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  },
  {
    "name": "nmon.cpu.idle%",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "tags": {
      "table": "CPU Detail"
    },
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2018-05-23T11:52:22.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```