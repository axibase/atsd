# Multiple Id Update

## Description

## Request

### URI

```elm
POST /api/v1/alerts/update
```

### Payload

```json
[
  {"id": 1, "acknowledged": false},
  {"id": 4, "acknowledged": true},
  {"id": 5, "acknowledged": true},
  {"id": 6, "acknowledged": false},
  {"id": 10, "acknowledged": false},
  {"id": 13, "acknowledged": true},
  {"id": 14, "acknowledged": true},
  {"id": 18, "acknowledged": true}
]
```
