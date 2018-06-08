# Metrics: All Value

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
    "metric": "*",
    "entity": "nurswgvml006",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now",
    "limit": 3
  }
]
```

## Response

### Payload