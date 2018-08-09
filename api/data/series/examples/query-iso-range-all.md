# Series Query: All Data Range

## Description

Query all detailed data for the series using [ISO format](../../../../shared/date-format.md#supported-formats).

The database accepts data timestamped at or after Unix time which is **1970-01-01T00:00:00.000 UTC**.

Maximum timestamp that can be stored by the database is **2106-02-07T07:28:14.999Z**.

Since the ISO parser is limited to **4** digits in the year segment, the maximum allowable year specified in ISO format is **9999**.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "1970-01-01T00:00:00.000Z",
        "endDate":   "9999-12-31T23:59:59.999Z",
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy",
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
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-06-09T07:04:56.434Z",
        "v": 224
      }
    ]
  }
]
```
