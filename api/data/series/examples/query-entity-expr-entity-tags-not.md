# Series Query: Select Series with Empty Entity Tag

## Description

If the tag is not available for the given entity, the value is set to empty string `''`.

This can be used to search for entities without the specified tag or to check for the presence of the tag.

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
    "endDate": "2016-02-22T13:31:00Z",
    "entityExpression": "tags.app = ''",
    "metric": "mpstat.cpu_busy"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml502",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {"d":"2016-02-22T13:30:01.000Z","v":1.02},
      {"d":"2016-02-22T13:30:17.000Z","v":1.51},
      {"d":"2016-02-22T13:30:33.000Z","v":2.5},
      {"d":"2016-02-22T13:30:49.000Z","v":4.48}
    ]
  }
]
```
