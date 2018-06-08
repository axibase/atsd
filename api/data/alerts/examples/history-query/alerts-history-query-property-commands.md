# History-Alerts for Property Commands

## Description

## Request

### URI

```elm
POST /api/v1/alerts/history/query
```

### Payload

```json
[
  {
    "metric": "property",
    "entity": "*",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now",
    "limit": 3
  }
]
```

## Response

### Payload