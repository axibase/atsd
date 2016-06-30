# Alerts History-Query: Filter Entities by Name with Wildcard

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
    "entity": "*urswgvml0*",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now",
    "limit": 5
  }
]
```

## Response

### Payload
```json

```

