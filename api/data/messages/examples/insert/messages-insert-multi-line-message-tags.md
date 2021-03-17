# Multi-line Message Tags

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
    "message": "NURSWGVML007 ssh: error: connect_to port 8881: failed.",
    "tags": {"path": "/path1 \n /path2", "name": "sda1 \n sda2"},
    "source": "atsd"
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
    "tags": {
      "name": "sda1 \n sda2",
      "path": "/path1 \n /path2"
    },
    "message": "NURSWGVML007 ssh: error: connect_to port 8881: failed.",
    "date": "2016-06-15T08:58:32.730Z"
  }
]
```
