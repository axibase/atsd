# Message Insert with Trimmed Message Text

## Description

Leading and trailing non-printable characters are discarded in the message field.

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
    "type": "application",
    "message": "    NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.    \n    ",
    "source": "atsd",
    "date": "2016-06-15T09:12:00Z"
  }
]
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
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-15T09:12:00.000Z"
  }
]
```
