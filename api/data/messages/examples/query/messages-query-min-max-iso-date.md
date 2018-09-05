# Thresholds Times for Query

## Description

Query for all dates. Select last message with `LIMIT = 1`. The database can store messages dated `1970-01-01T00:00:00.001Z` and later.

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
    "startDate": "1970-01-01T00:00:00.000Z",
    "endDate": "9999-12-31T23:59:59.999+23:59",
    "limit": 1
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "source": "com.axibase.tsd.web.csv.csvcontroller",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "qtp1110642100-167",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Start processing csv, config: nginx-status",
    "date": "2016-06-17T13:17:54.282Z"
  }
]
```
