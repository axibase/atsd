# History-Alerts for Defined Rule

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
    "rule": "nmon_cpu_alert",
    "startDate": "2016-06-27T18:00:00Z",
    "interval": {
      "count": 1,
      "unit": "DAY"
    },
    "limit": 3
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-06-28T17:59:29.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 14.3,
    "alert": "Open alert for nurswgvml007, nmon.cpu_total.busy%, {}. Value: 14.3",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-28T17:59:30.030Z",
    "receivedDate": "2016-06-28T17:59:30.030Z"
  },
  {
    "date": "2016-06-28T17:59:16.000Z",
    "entity": "nurswgvml212",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 11.4,
    "alert": "Open alert for nurswgvml212, nmon.cpu_total.busy%, {}. Value: 11.4",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-06-28T17:59:17.025Z",
    "receivedDate": "2016-06-28T17:59:17.025Z"
  },
  {
    "date": "2016-06-28T17:59:06.000Z",
    "entity": "nurswgvml201",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 5.6,
    "alert": "Cancel alert for nurswgvml201, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180020,
    "alertOpenDate": "2016-06-28T17:56:06.776Z",
    "receivedDate": "2016-06-28T17:59:06.796Z"
  }
]
```

