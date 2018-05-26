# Filter Alerts for Minimum Severity

## Description

Select alerts with severity equal or greater than specified (CRITICAL).

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
      "property",
      "disk_used_percent"
    ],
    "entity": "nurswgvml007",
    "minSeverity": "CRITICAL",
    "startDate": "2016-06-23T04:00:00Z",
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
    "repeatCount": 5236,
    "textValue": "66.133",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-27T15:59:40.257Z",
    "lastEventDate": "2016-06-28T13:51:27.196Z",
    "acknowledged": false,
    "openValue": 65.7791,
    "value": 66.1326,
    "id": 7
  }
]
```
