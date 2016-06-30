# Alerts Query: Entity Expression with Entity Tags

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
    "entityExpression": "tags.app = 'ATSD'",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload
```json

```

