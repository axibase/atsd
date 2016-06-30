# Alerts History-Query: Entity Group

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
    "entityGroup": "nur-collectors",
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
    "date": "2016-06-30T08:48:17.000Z",
    "entity": "nurswgvml009",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 6.4,
    "alert": "Cancel alert for nurswgvml009, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180028,
    "alertOpenDate": "2016-06-30T08:45:17.606Z",
    "receivedDate": "2016-06-30T08:48:17.634Z"
  },
  {
    "date": "2016-06-30T08:48:16.000Z",
    "entity": "nurswgvml007",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 8.2,
    "alert": "Cancel alert for nurswgvml007, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 2,
    "alertDuration": 180117,
    "alertOpenDate": "2016-06-30T08:45:16.811Z",
    "receivedDate": "2016-06-30T08:48:16.928Z"
  },
  {
    "date": "2016-06-30T08:48:14.000Z",
    "entity": "nurswgvml006",
    "metric": "nmon.cpu_total.busy%",
    "type": "CANCEL",
    "value": 4.1,
    "alert": "Cancel alert for nurswgvml006, nmon.cpu_total.busy%, {}",
    "severity": "UNDEFINED",
    "rule": "nmon_cpu_alert",
    "ruleExpression": "max() > 10",
    "window": "length(3)",
    "repeatCount": 3,
    "alertDuration": 240080,
    "alertOpenDate": "2016-06-30T08:44:14.172Z",
    "receivedDate": "2016-06-30T08:48:14.252Z"
  }
]
```

