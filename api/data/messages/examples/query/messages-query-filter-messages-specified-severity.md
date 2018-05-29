# Filter Messages for Specified Severity

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
    "entity": "nurswgvml007",
    "severity": "CRITICAL",
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
    "type": "default",
    "source": "default",
    "severity": "CRITICAL",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-20T06:40:07.094Z"
  }
]
```
