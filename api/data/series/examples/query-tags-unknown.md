# Series Query: Unknown Tag Returns Warning

## Description

Query data for series that have the specified tag, whereas the tag does not exist in the database.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "2016-02-22T13:30:00Z",
        "endDate":   "2016-02-22T13:35:00Z",
        "entity": "nurswgvml007",
        "metric": "df.disk_used_percent",
        "tags": {"unknown": "/dev*"}
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "df.disk_used_percent",
    "tags": {
      "unknown": "/dev*"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "warning": "com.axibase.tsd.service.DictionaryNotFoundException: TAG_KEY not found for name: 'unknown'",
    "data": []
  }
]
```
