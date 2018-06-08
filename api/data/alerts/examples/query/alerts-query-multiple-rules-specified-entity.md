# Multiple Rules for Specified Entity

## Description

Select alerts for multiple rules for a given entity.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "rules": [
      "disk_low_alert",
      "nmon_cpu_alert"
    ],
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
    "repeatCount": 336,
    "textValue": "65.871",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:02.979Z",
    "lastEventDate": "2016-06-29T08:43:10.715Z",
    "acknowledged": false,
    "openValue": 65.8734,
    "value": 65.8711,
    "id": 4
  },
  {
    "entity": "nurswgvml006",
    "tags": {},
    "repeatCount": 2,
    "textValue": "4.2",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:40:25.229Z",
    "lastEventDate": "2016-06-29T08:42:25.281Z",
    "acknowledged": false,
    "openValue": 10.8,
    "value": 4.2,
    "id": 100
  }
]
```