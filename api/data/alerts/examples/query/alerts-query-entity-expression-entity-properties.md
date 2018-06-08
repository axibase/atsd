# Alerts Query: Entity Expression with Properties

## Description

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entityExpression": "name LIKE 'nurswgvml00*' && properties('vmware.vm').power_state = 'On'",
    "startDate": "2016-06-30T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload