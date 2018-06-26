# Series Query: Multiple Queries with Request Id

## Description

Retrieves data for multiple series queries with different metrics, entities, and timespans.

Each query can return multiple series. The order of series in the response is arbitrary.

To associate series with queries, specify the `requestId` parameter.

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
        "entity": "nurswgvml006",
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
  },
  {
    "requestId": "q2",
    "entity": "nurswgvml006",
    "metric": "memfree",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-06-27T16:05:07.000Z",
        "v": 70612
      },
      {
        "d": "2016-06-27T16:05:22.000Z",
        "v": 70992
      },
      {
        "d": "2016-06-27T16:05:37.000Z",
        "v": 67116
      },
      {
        "d": "2016-06-27T16:05:52.000Z",
        "v": 75800
      }
    ]
  }
]
```
