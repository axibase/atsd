# Series Query: Multiple Entities Including Entities without Data

## Description

Query data for multiple defined entities.

The response contains multiple separate series for each entity, including entity `e-1` without data in the specified timespan.

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
        "entities": ["nurswgvml007", "nurswgvml006", "e-1"],
        "metric": "mpstat.cpu_busy"
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml006",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:11.000Z",
        "v": 2
      },
      {
        "d": "2016-02-22T13:30:27.000Z",
        "v": 2.97
      },
      {
        "d": "2016-02-22T13:30:43.000Z",
        "v": 7.07
      },
      {
        "d": "2016-02-22T13:30:59.000Z",
        "v": 55.79
      }
    ]
  },
  {
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
    "entity": "e-1",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": []
  }
]
```
