# Multiple Entities for Specified Rule

## Description

Select alerts for multiple entities and a given rule.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entities": [
      "nurswgvml007",
      "nurswgvml006"
    ],
    "rules": [
      "disk_low_alert"
    ],
    "startDate": "2016-06-20T04:00:00Z",
    "endDate": "2016-06-25T05:00:00Z"
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
    "repeatCount": 1001,
    "textValue": "65.147",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-24T10:28:38.496Z",
    "lastEventDate": "2016-06-24T14:39:28.304Z",
    "acknowledged": false,
    "openValue": 65.059,
    "value": 65.1474,
    "id": 2
  },
  {
    "entity": "nurswgvml007",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "repeatCount": 1002,
    "textValue": "65.561",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-24T10:28:48.387Z",
    "lastEventDate": "2016-06-24T14:39:29.841Z",
    "acknowledged": false,
    "openValue": 65.5204,
    "value": 65.5608,
    "id": 5
  }
]
```