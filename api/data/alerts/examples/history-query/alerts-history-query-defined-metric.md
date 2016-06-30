# History-Alerts for Defined Metric

## Description

## Request

### URI
```elm
POST https://atsd_host:8443/api/v1/alerts/history/query
```
### Payload

```json
[
  {
    "metric": "disk_used_percent",
    "endDate": "2016-06-25T18:00:00Z",
    "interval": {
      "count": 1,
      "unit": "DAY"
    },
    "limit": 2
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-06-25T15:34:48.000Z",
    "entity": "nurswgvml011",
    "metric": "disk_used_percent",
    "tags": "file_system=/dev/sda1;mount_point=/",
    "type": "OPEN",
    "value": 61.1551,
    "alert": "Open alert for nurswgvml011, disk_used_percent, {file_system=/dev/sda1, mount_point=/}. Value: 61.155",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "ruleExpression": "value > 60",
    "ruleFilter": "tags.mount_point not like '*u113452*'",
    "window": "length(1)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-25T15:33:52.218Z",
    "receivedDate": "2016-06-25T15:33:52.218Z"
  },
  {
    "date": "2016-06-25T15:34:30.000Z",
    "entity": "nurswgvml009",
    "metric": "disk_used_percent",
    "tags": "file_system=/dev/sdb1;mount_point=/opt",
    "type": "OPEN",
    "value": 69.0772,
    "alert": "Open alert for nurswgvml009, disk_used_percent, {file_system=/dev/sdb1, mount_point=/opt}. Value: 69.077",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "ruleExpression": "value > 60",
    "ruleFilter": "tags.mount_point not like '*u113452*'",
    "window": "length(1)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-25T15:35:27.965Z",
    "receivedDate": "2016-06-25T15:35:27.965Z"
  }
]
```

