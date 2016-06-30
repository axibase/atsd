# Alerts History-Query: Apply Limit to Results

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
    "entity": "nurswgvml007",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now",
    "limit": 2
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-06-30T15:24:23.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 10.3,
    "alert": "Open alert for nurswgvml007, nmon.cpu_total.busy%, {}. Value: 10.3",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-30T15:24:23.127Z",
    "receivedDate": "2016-06-30T15:24:23.127Z"
  },
  {
    "date": "2016-06-30T15:18:22.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 6.6,
    "alert": "Cancel alert for nurswgvml007, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180033,
    "alertOpenDate": "2016-06-30T15:15:22.985Z",
    "receivedDate": "2016-06-30T15:18:23.018Z"
  }
]
```

