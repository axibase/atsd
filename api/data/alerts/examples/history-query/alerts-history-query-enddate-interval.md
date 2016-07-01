# Alerts History-Query: End Date and Interval

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
    "endDate":   "2016-07-01T08:00:00Z",
    "interval": {"unit": "HOUR", "count": 5},
    "limit": 2
  }
]
```

## Response

### Payload
```json
[
  {
    "date": "2016-07-01T07:59:19.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "OPEN",
    "value": 11.7,
    "alert": "Open alert for nurswgvml007, nmon.cpu_total.busy%, {}. Value: 11.7",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 0,
    "alertDuration": 0,
    "alertOpenDate": "2016-07-01T07:59:20.022Z",
    "receivedDate": "2016-07-01T07:59:20.022Z"
  },
  {
    "date": "2016-07-01T07:58:19.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 5.2,
    "alert": "Cancel alert for nurswgvml007, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180032,
    "alertOpenDate": "2016-07-01T07:55:19.980Z",
    "receivedDate": "2016-07-01T07:58:20.012Z"
  }
]
```



