# Filter Alerts for Severities

## Description

Select alerts that match one of the specified severities.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "metrics": [
      "nmon.cpu_total.busy%",
      "message",
      "disk_used_percent",
      "property"
    ],
    "entity": "nurswgvml007",
    "severities": [
      "FATAL",
      "CRITICAL",
      "WARN"
    ],
    "startDate": "2016-06-20T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "repeatCount": 5268,
    "textValue": "65.967",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-27T15:59:40.257Z",
    "lastEventDate": "2016-06-28T13:59:27.870Z",
    "acknowledged": false,
    "openValue": 65.7791,
    "value": 65.9666,
    "id": 7
  }
]
```