# History-Alerts for Last Day

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
    "startDate": "now - 1 * DAY",
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
    "date": "2016-07-01T08:19:07.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 6.5,
    "alert": "Cancel alert for nurswgvml006, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 18,
    "alertDuration": 1140305,
    "alertOpenDate": "2016-07-01T08:00:07.482Z",
    "receivedDate": "2016-07-01T08:19:07.787Z"
  },
  {
    "date": "2016-07-01T08:17:09.000Z",
    "entity": "nurswgvml212",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 12,
    "alert": "Open alert for nurswgvml212, nmon.cpu_total.busy%, {}. Value: 12",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-07-01T08:17:09.692Z",
    "receivedDate": "2016-07-01T08:17:09.692Z"
  }
]
```



