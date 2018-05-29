# Series Query: Time Range with Millisecond Precision

## Description

Query detailed data for the specified time range, identified with `startDate` and `endDate`.

The dates can be specified with second or millisecond precision.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "2016-02-22T13:30:08.000Z",
        "endDate":   "2016-02-22T13:31:08.500Z",
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy"
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:08.212Z",
        "v": 4
      }
    ]
  }
]
```
