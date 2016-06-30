# Rules: All Value

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
    "rule": "*",
    "entity": "nurswgvml006",
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
    "date": "2016-06-30T09:40:15.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 22.6,
    "alert": "Open alert for nurswgvml006, nmon.cpu_total.busy%, {}. Value: 22.6",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-30T09:40:15.462Z",
    "receivedDate": "2016-06-30T09:40:15.462Z"
  },
  {
    "date": "2016-06-30T09:39:15.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 4.9,
    "alert": "Cancel alert for nurswgvml006, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 3,
    "alertDuration": 240056,
    "alertOpenDate": "2016-06-30T09:35:15.396Z",
    "receivedDate": "2016-06-30T09:39:15.452Z"
  },
  {
    "date": "2016-06-30T09:35:15.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 12.9,
    "alert": "Open alert for nurswgvml006, nmon.cpu_total.busy%, {}. Value: 12.9",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-30T09:35:15.396Z",
    "receivedDate": "2016-06-30T09:35:15.396Z"
  }
]
```

