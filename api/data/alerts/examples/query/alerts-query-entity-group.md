# Alerts Query: Entity Group

## Description

Select alerts for the specified entity group and rule.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entityGroup": "nur-collectors",
    "rules": ["disk_low_alert"],
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
    "entity": "nurswgvml006",
    "tags": {
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "repeatCount": 458,
    "textValue": "65.889",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:02.979Z",
    "lastEventDate": "2016-06-29T09:13:43.268Z",
    "acknowledged": false,
    "openValue": 65.8734,
    "value": 65.8887,
    "id": 4
  },
  {
    "entity": "nurswgvml007",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "repeatCount": 458,
    "textValue": "65.992",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:01.131Z",
    "lastEventDate": "2016-06-29T09:13:38.489Z",
    "acknowledged": false,
    "openValue": 65.8802,
    "value": 65.992,
    "id": 3
  },
  {
    "entity": "nurswgvml009",
    "tags": {
      "file_system": "/dev/sdb1",
      "mount_point": "/opt"
    },
    "repeatCount": 455,
    "textValue": "69.206",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:20:37.275Z",
    "lastEventDate": "2016-06-29T09:13:37.887Z",
    "acknowledged": false,
    "openValue": 69.2107,
    "value": 69.2056,
    "id": 15
  },
  {
    "entity": "nurswgvml010",
    "tags": {
      "file_system": "/dev/sdb1",
      "mount_point": "/app"
    },
    "repeatCount": 457,
    "textValue": "74.835",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:06.286Z",
    "lastEventDate": "2016-06-29T09:13:34.191Z",
    "acknowledged": false,
    "openValue": 74.8396,
    "value": 74.8349,
    "id": 7
  },
  {
    "entity": "nurswgvml011",
    "tags": {
      "file_system": "/dev/sda1",
      "mount_point": "/"
    },
    "repeatCount": 445,
    "textValue": "61.191",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:18:57.296Z",
    "lastEventDate": "2016-06-29T09:13:32.161Z",
    "acknowledged": false,
    "openValue": 61.1332,
    "value": 61.1909,
    "id": 1
  },
  {
    "entity": "nurswgvml502",
    "tags": {
      "file_system": "/dev/sda1",
      "mount_point": "/"
    },
    "repeatCount": 458,
    "textValue": "62.706",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:06.178Z",
    "lastEventDate": "2016-06-29T09:13:43.295Z",
    "acknowledged": false,
    "openValue": 62.7048,
    "value": 62.7064,
    "id": 6
  }
]
```