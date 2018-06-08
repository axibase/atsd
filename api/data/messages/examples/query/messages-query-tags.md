# Query Specified Tags

## Description

Query messages matching particular tags.

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
    "tags": {
      "name": "sda",
      "path": "/"
    },
    "startDate": "2016-06-15T14:13:57.383Z",
    "endDate": "2016-06-17T14:13:57.383Z"
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
    "tags": {
      "name": "sda",
      "path": "/"
    },
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "date": "2016-06-16T08:56:37.432Z"
  }
]
```
