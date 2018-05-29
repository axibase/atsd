# Alerts for Last Hour

## Description

Select all alerts that were open during the last hour.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "startDate": "now - 1 * HOUR",
    "endDate": "now"
  }
]
```

## Response

### Payload

```json
[
  {
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "entity": "nurswgvml007",
    "repeatCount": 127,
    "textValue": "65.926",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:40.018Z",
    "lastEventDate": "2016-06-29T10:07:26.637Z",
    "acknowledged": false,
    "openValue": 65.7822,
    "value": 65.9261,
    "id": 3
  },
  {
    "tags": {},
    "entity": "nurswgvml007",
    "repeatCount": 2,
    "textValue": "5.8",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T10:05:16.792Z",
    "lastEventDate": "2016-06-29T10:07:16.812Z",
    "acknowledged": false,
    "openValue": 15,
    "value": 5.8,
    "id": 41
  }
]
```