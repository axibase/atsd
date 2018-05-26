# Metrics: Alerts for Entity

## Description

Select alerts for all metrics for a given entity.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "metrics": [],
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
    "repeatCount": 264,
    "textValue": "65.849",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:02.979Z",
    "lastEventDate": "2016-06-29T08:25:09.856Z",
    "acknowledged": false,
    "openValue": 65.8734,
    "value": 65.8489,
    "id": 4
  },
  {
    "entity": "nurswgvml006",
    "tags": {},
    "repeatCount": 0,
    "textValue": "15.5",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:24:25.016Z",
    "lastEventDate": "2016-06-29T08:24:25.016Z",
    "acknowledged": false,
    "openValue": 15.5,
    "value": 15.5,
    "id": 79
  }
]
```