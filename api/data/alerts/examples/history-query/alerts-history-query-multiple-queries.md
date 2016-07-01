# Alerts History-Query: Multiple Queries

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
    "startDate": "2016-07-01T11:05:00Z",
    "endDate": "now",
    "entity": "nurswgvml007",
    "rule": "nmon_cpu_alert"
  },
  {
    "startDate": "2016-07-01T05:00:00Z",
    "endDate": "now",
    "entity": "nurswgvml006",
    "rule": "disk_low_alert"
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-07-01T11:10:25.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 12.9,
    "alert": "Open alert for nurswgvml007, nmon.cpu_total.busy%, {}. Value: 12.9",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-07-01T11:10:25.415Z",
    "receivedDate": "2016-07-01T11:10:25.415Z"
  },
  {
    "date": "2016-07-01T11:08:25.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 9.5,
    "alert": "Cancel alert for nurswgvml007, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 3,
    "alertDuration": 240043,
    "alertOpenDate": "2016-07-01T11:04:25.318Z",
    "receivedDate": "2016-07-01T11:08:25.361Z"
  },
  {
    "date": "2016-07-01T10:44:36.000Z",
    "entity": "nurswgvml006",
    "metric": "disk_used_percent",
    "tags": "file_system=/dev/sdc1;mount_point=/media/datadrive",
    "type": "OPEN",
    "value": 66.7578,
    "alert": "Open alert for nurswgvml006, disk_used_percent, {file_system=/dev/sdc1, mount_point=/media/datadrive}. Value: 66.758",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "ruleExpression": "value > 60",
    "ruleFilter": "tags.mount_point not like '*u113452*'",
    "window": "length(1)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-07-01T10:44:37.495Z",
    "receivedDate": "2016-07-01T10:44:37.495Z"
  }
]
```

