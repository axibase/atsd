# Filter Alerts for Unacknowledged Status

## Description

Select unacknowledged alerts.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entity": "nurswgvml006",
    "startDate": "2016-06-28T04:00:00Z",
    "endDate": "now",
    "acknowledged": false
  }
]
```

## Response

### Payload

```json
[
  {
    "tags": {
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "entity": "nurswgvml006",
    "repeatCount": 557,
    "textValue": "65.966",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:45.607Z",
    "lastEventDate": "2016-06-29T11:55:10.317Z",
    "acknowledged": false,
    "openValue": 65.9242,
    "value": 65.9658,
    "id": 6
  },
  {
    "tags": {},
    "entity": "nurswgvml006",
    "repeatCount": 0,
    "textValue": "20.1",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T11:54:28.983Z",
    "lastEventDate": "2016-06-29T11:54:28.983Z",
    "acknowledged": false,
    "openValue": 20.1,
    "value": 20.1,
    "id": 108
  }
]
```