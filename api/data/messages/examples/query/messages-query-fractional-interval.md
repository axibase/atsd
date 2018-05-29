# The Integer Value of the Field "count" Object "interval"

## Description

Query with interval specified as fractional number.

## Request

### URI

```elm
POST /api/v1/messages/insert
```

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-17T00:00:00.001Z"
  },
  {
    "entity": "nurswgvml007",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8882: failed.",
    "date": "2016-06-17T01:00:00.001Z"
  }
]
```

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
    "startDate": "2016-06-16T00:00:00.002Z",
    "interval":{"count":1.5, "unit":"DAY"}
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
    "severity": "NORMAL",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-17T00:00:00.001Z"
  }
]
```
