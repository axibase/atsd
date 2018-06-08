# Multiple Metrics for Specified Entity

## Description

Select alerts for multiple metrics for a given entity.

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
      "disk_used_percent",
      "nmon.cpu_total.busy%"
    ],
    "entity": "nurswgvml007",
    "startDate": "2016-06-27T04:00:00Z",
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
    "repeatCount": 271,
    "textValue": "65.844",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:01.131Z",
    "lastEventDate": "2016-06-29T08:26:51.295Z",
    "acknowledged": false,
    "openValue": 65.8802,
    "value": 65.8436,
    "id": 3
  },
  {
    "entity": "nurswgvml007",
    "tags": {},
    "repeatCount": 1,
    "textValue": "9.8",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:25:15.384Z",
    "lastEventDate": "2016-06-29T08:26:15.397Z",
    "acknowledged": false,
    "openValue": 35.7,
    "value": 9.8,
    "id": 81
  }
]
```