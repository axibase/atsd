# Series Query: Filter Entities by Name with Wildcard

## Description

Query data for multiple entities whose names match the specified expression.

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
        "entity": "*urswgvml0*",
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
    "entity": "nurswgvml006",
    "metric": "mpstat.cpu_busy",
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
    "entity": "nurswgvml010",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:01.000Z",
        "v": 36.45
      },
      {
        "d": "2016-02-22T13:30:17.000Z",
        "v": 13.13
      },
      {
        "d": "2016-02-22T13:30:33.000Z",
        "v": 1.26
      },
      {
        "d": "2016-02-22T13:30:49.000Z",
        "v": 0.25
      }
    ]
  },
  {
    "entity": "nurswgvml011",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:06.000Z",
        "v": 1.98
      },
      {
        "d": "2016-02-22T13:30:22.000Z",
        "v": 1
      },
      {
        "d": "2016-02-22T13:30:38.000Z",
        "v": 2.97
      },
      {
        "d": "2016-02-22T13:30:54.000Z",
        "v": 47.47
      }
    ]
  }
]
```
