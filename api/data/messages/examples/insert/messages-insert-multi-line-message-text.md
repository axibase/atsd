# Multi-line Message Text

## Description

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
    "message": "NURSWGVML007 ssh: error: connect_to port 8881: failed \n NURSWGVML007 ssh: error: connect_to port 8882: failed.",
    "source": "atsd",
    "date": "2016-06-14T09:12:00Z"
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
    "message": "NURSWGVML007 ssh: error: connect_to port 8881: failed \n NURSWGVML007 ssh: error: connect_to port 8882: failed.",
    "date": "2016-06-14T09:12:00.000Z"
  }
]
```
