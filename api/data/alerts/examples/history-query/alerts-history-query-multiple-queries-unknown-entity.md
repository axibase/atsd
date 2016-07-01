# Alerts History-Query: Multiple Queries - Unknown Entitys

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
    "startDate": "2016-07-01T11:05:00Z",
    "endDate": "now",
    "entity": "UNKNOWN",
    "rule": "nmon_cpu_alert"
  },
  {
    "startDate": "2016-07-01T05:00:00Z",
    "endDate": "now",
    "entity": "nurswgvml006",
    "rule": "disk_low_alert"
  }
]
```

## Response

### Payload
```json

```

