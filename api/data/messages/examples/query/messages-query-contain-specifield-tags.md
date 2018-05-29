# Query Messages that Contain the Specified Tag

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
    "type": "logger",
    "limit": 5,
    "tags": {
      "level": "*",
      "thread": "*",
      "command": "com.axibase.tsd.Server"
    },
    "startDate": "2016-06-15T14:13:57.383Z",
    "endDate": "2016-06-21T14:13:57.383Z"
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
    "source": "default",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "qtp1011680252-098",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Start processing csv, config: nginx-status",
    "date": "2016-06-20T14:13:58.383Z"
  },
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "source": "com.axibase.tsd.service.nmon.nmonparser",
    "severity": "WARNING",
    "tags": {
      "level": "WARN",
      "thread": "tcp-server-worker thread-7",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Header not found for row 'CPU06,T0005,0.0,2.9,0.0,97.1', parser default, file aix03_160620_0545.nmon",
    "date": "2016-06-20T10:10:03.922Z"
  },
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "source": "com.axibase.tsd.web.csv.csvcontroller",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "qtp997634665-205",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Start processing csv, config: nginx-status",
    "date": "2016-06-20T10:09:40.222Z"
  }
]
```
