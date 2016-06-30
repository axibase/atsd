# Alerts History-Query: Entity Array

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
    "entities": [
      "nurswgvml007",
      "nurswgvml006",
      "nurswgvml009"
    ],
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
    "date": "2016-06-30T08:08:16.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 12.5,
    "alert": "Open alert for nurswgvml007, nmon.cpu_total.busy%, {}. Value: 12.5",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-30T08:08:16.320Z",
    "receivedDate": "2016-06-30T08:08:16.320Z"
  },
  {
    "date": "2016-06-30T08:08:13.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 4.5,
    "alert": "Cancel alert for nurswgvml006, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 12,
    "alertDuration": 780195,
    "alertOpenDate": "2016-06-30T07:55:13.518Z",
    "receivedDate": "2016-06-30T08:08:13.713Z"
  },
  {
    "date": "2016-06-30T08:07:16.000Z",
    "entity": "nurswgvml009",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 3.1,
    "alert": "Cancel alert for nurswgvml009, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180037,
    "alertOpenDate": "2016-06-30T08:04:16.954Z",
    "receivedDate": "2016-06-30T08:07:16.991Z"
  }
]
```

