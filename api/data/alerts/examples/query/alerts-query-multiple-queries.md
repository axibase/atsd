# Alerts Query: Multiple Queries

## Description

## Request

### URI
```elm
POST https://atsd_host:8443/api/v1/alerts/query
```
### Payload

```json
[
  {
    "startDate": "2016-06-30T00:00:00Z",
    "endDate": "now",
    "entity": "nurswgvml007",
    "rules": [
      "nmon_cpu_alert"
    ]
  },
  {
    "startDate": "2016-07-01T00:00:00Z",
    "endDate": "now",
    "entity": "atsd",
    "rules": [
      "alert-app"
    ]
  }
]
```

## Response

### Payload
```json
[
  {
    "tags": {},
    "entity": "nurswgvml007",
    "repeatCount": 85,
    "textValue": "44.8",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-07-01T07:59:20.022Z",
    "lastEventDate": "2016-07-01T09:24:21.530Z",
    "acknowledged": false,
    "openValue": 11.7,
    "value": 44.8,
    "id": 534
  },
  {
    "tags": {},
    "entity": "atsd",
    "repeatCount": 2,
    "textValue": "Job completed. Start time: 2016-07-01T02:00:00Z. End time: 2016-07-01T02:00:34Z. Duration seconds: 34.1. Row count: 5392. Entity count: 1. File count: 1. ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-app",
    "openDate": "2016-07-01T02:00:00.013Z",
    "lastEventDate": "2016-07-01T02:00:40.506Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": "Job completed. Start time: 2016-07-01T02:00:00Z. End time: 2016-07-01T02:00:34Z. Duration seconds: 34.1. Row count: 5392. Entity count: 1. File count: 1. ",
    "id": 336
  }
]
```

