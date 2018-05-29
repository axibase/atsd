# Alerts Query: Filter Entities by Name with Wildcard

## Description

Select alerts for entities matching name pattern.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entity": "*urswgvml0*",
    "startDate": "2016-06-28T04:00:00Z",
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
    "repeatCount": 0,
    "textValue": "65.782",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:40.018Z",
    "lastEventDate": "2016-06-29T09:35:40.018Z",
    "acknowledged": false,
    "openValue": 65.7822,
    "value": 65.7822,
    "id": 3
  },
  {
    "tags": {
      "file_system": "/dev/sda1",
      "mount_point": "/"
    },
    "entity": "nurswgvml010",
    "repeatCount": 0,
    "textValue": "60.637",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:38.527Z",
    "lastEventDate": "2016-06-29T09:35:38.527Z",
    "acknowledged": false,
    "openValue": 60.6373,
    "value": 60.6373,
    "id": 1
  },
  {
    "tags": {
      "file_system": "/dev/sdb1",
      "mount_point": "/app"
    },
    "entity": "nurswgvml010",
    "repeatCount": 0,
    "textValue": "74.838",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:39.449Z",
    "lastEventDate": "2016-06-29T09:35:39.449Z",
    "acknowledged": false,
    "openValue": 74.8378,
    "value": 74.8378,
    "id": 2
  }
]
```