# Rules: Alerts for Entity

## Description

Select alerts for the specified entity.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "rules": [],
    "entity": "nurswgvml006",
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
    "entity": "nurswgvml006",
    "tags": {
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "repeatCount": 354,
    "textValue": "65.903",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:02.979Z",
    "lastEventDate": "2016-06-29T08:47:40.962Z",
    "acknowledged": false,
    "openValue": 65.8734,
    "value": 65.9027,
    "id": 4
  },
  {
    "entity": "nurswgvml006",
    "tags": {},
    "repeatCount": 2,
    "textValue": "4",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:45:25.314Z",
    "lastEventDate": "2016-06-29T08:47:25.337Z",
    "acknowledged": false,
    "openValue": 11.8,
    "value": 4,
    "id": 105
  }
]
```