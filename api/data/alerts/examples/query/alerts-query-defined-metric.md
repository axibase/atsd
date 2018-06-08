# Alerts for Defined Metric

## Description

Select alerts for the specified metric.

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
      "disk_used_percent"
    ],
    "entity": "nurswgvml00*",
    "startDate": "2016-06-29T04:00:00Z",
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
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "entity": "nurswgvml006",
    "repeatCount": 749,
    "textValue": "65.986",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:45.607Z",
    "lastEventDate": "2016-06-29T12:43:14.929Z",
    "acknowledged": false,
    "openValue": 65.9242,
    "value": 65.9856,
    "id": 6
  },
  {
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "entity": "nurswgvml007",
    "repeatCount": 750,
    "textValue": "65.821",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:35:40.018Z",
    "lastEventDate": "2016-06-29T12:43:21.311Z",
    "acknowledged": false,
    "openValue": 65.7822,
    "value": 65.8212,
    "id": 3
  },
  {
    "tags": {
      "file_system": "/dev/sdb1",
      "mount_point": "/opt"
    },
    "entity": "nurswgvml009",
    "repeatCount": 747,
    "textValue": "69.216",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:37:31.223Z",
    "lastEventDate": "2016-06-29T12:43:26.890Z",
    "acknowledged": true,
    "openValue": 69.2101,
    "value": 69.2157,
    "id": 17
  },
  {
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml009-lv_root",
      "mount_point": "/"
    },
    "entity": "nurswgvml009",
    "repeatCount": 747,
    "textValue": "72.245",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:37:31.211Z",
    "lastEventDate": "2016-06-29T12:43:26.889Z",
    "acknowledged": false,
    "openValue": 72.2479,
    "value": 72.2445,
    "id": 16
  }
]
```