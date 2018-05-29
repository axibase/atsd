# Multiple Entities for Specified Type

## Description

## Request

### URI

```elm
POST /api/v1/messages/query
```

### Payload

```json
[
  {
    "entities": ["nurswgvml007","nurswgvml008"],
    "type": "application",
    "startDate": "2016-06-17T13:05:00Z",
    "endDate": "2016-06-21T13:10:00.000Z"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "application",
    "source": "default",
    "severity": "NORMAL",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-20T06:59:42.059Z"
  },
  {
    "entity": "nurswgvml008",
    "type": "application",
    "source": "default",
    "severity": "NORMAL",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8882: failed.",
    "date": "2016-06-20T06:59:42.059Z"
  }
]
```
