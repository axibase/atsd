# Message Insert with Type/Source and Tag Collision

## Description

The message tags `{"type": "hello", "source": "world"}` are discarded since they conflict with the predefined `type` and `source` fields.

## Request

### URI

```elm
POST /api/v1/messages/insert
```

### Payload

```json
[{
    "entity": "nurswgvml007",
    "type": "application",
    "source": "atsd",
    "message": "NURSWGVML007 ssh: error: connect_to port 8882: failed.",
    "tags": {"type": "hello", "source": "world"}
}]
```

## Response

### URI

```elm
POST /api/v1/messages/query
```

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "application",
    "source": "atsd",
    "severity": "NORMAL",
    "message": "NURSWGVML007 ssh: error: connect_to port 8882: failed.",
    "date": "2016-06-15T09:42:32.886Z"
  }
]
```
