# Discarded Duplicate Text Messages

## Description

One of the messages will be discarded since all of the key fields (entity, type, source, time) are equal.

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
    "message": "ssh: error: connect_to localhost port 7777: failed.",
    "severity": "MAJOR"
},{
    "entity": "nurswgvml007",
    "type": "application",
    "source": "atsd",
    "date": "2016-06-14T14:52:00Z",
    "message": "connect to localhost port 8888: failed.",
    "severity": "INFO"
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
    "severity": "MAJOR",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-14T14:52:00.000Z"
  }
]
```
