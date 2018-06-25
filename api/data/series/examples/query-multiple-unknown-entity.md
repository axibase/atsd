# Series Query: Multiple Queries - Unknown Entity

## Description

Retrieve data for multiple series queries with different metrics, entities, and timespans.

Each query can return multiple series. The order of series in the response is arbitrary.

To associate series with queries, specify the `requestId` parameter.

Errors, other than those related to syntax and security, are reported separately for each query.

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
        "endDate":   "2016-02-22T13:31:00Z",
        "entity": "nurswgvml007",
        "metric": "cpu_busy",
        "requestId": "q1"
    },
    {
        "startDate": "now - 1 * MINUTE",
        "endDate":   "now",
        "entity": "UNKNOWN",
        "metric": "memfree",
        "requestId": "q2"
    }
]
```

## Response

### Payload

```json
[
  {
    "requestId": "q2",
    "entity": "unknown",
    "metric": "memfree",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "warning": "com.axibase.tsd.service.DictionaryNotFoundException: ENTITY not found for name: 'unknown'",
    "data": []
  },
  {
    "requestId": "q1",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:08.000Z",
        "v": 4
      },
      {
        "d": "2016-02-22T13:30:24.000Z",
        "v": 3.03
      },
      {
        "d": "2016-02-22T13:30:40.000Z",
        "v": 6.06
      },
      {
        "d": "2016-02-22T13:30:56.000Z",
        "v": 4
      }
    ]
  }
]
```
