# Alerts History-Query: Filter Rule by Name with Wildcard

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
    "rule": "*isk_used*",
    "entity": "nurswgvml009",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now",
    "limit": 3
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-06-30T12:27:20.000Z",
    "entity": "nurswgvml009",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 3.1,
    "alert": "Cancel alert for nurswgvml009, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 3,
    "alertDuration": 240037,
    "alertOpenDate": "2016-06-30T12:23:20.511Z",
    "receivedDate": "2016-06-30T12:27:20.548Z"
  },
  {
    "date": "2016-06-30T12:23:20.000Z",
    "entity": "nurswgvml009",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 16.3,
    "alert": "Open alert for nurswgvml009, nmon.cpu_total.busy%, {}. Value: 16.3",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-30T12:23:20.511Z",
    "receivedDate": "2016-06-30T12:23:20.511Z"
  },
  {
    "date": "2016-06-30T11:07:19.000Z",
    "entity": "nurswgvml009",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 3.7,
    "alert": "Cancel alert for nurswgvml009, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180065,
    "alertOpenDate": "2016-06-30T11:04:19.395Z",
    "receivedDate": "2016-06-30T11:07:19.460Z"
  }
]
```

