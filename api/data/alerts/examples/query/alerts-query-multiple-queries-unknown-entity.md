# Alerts Query: Multiple Queries - Unknown Entitys

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
    "entity": "UNKNOWN",
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

