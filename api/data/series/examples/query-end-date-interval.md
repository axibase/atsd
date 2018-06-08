# Series Query: End Date and Interval

## Description

Query detailed data for the specified `endDate` and `interval`. In this case, `startDate` is computed as `endDate` minus `interval`.

```ls
2016-06-26T13:05:00Z - 5 MINUTE = 2016-06-26T13:00:00Z = startDate
```

Similarly, the time range can be specified as `startDate` and `interval` in which case `endDate` will be computed as `startDate` plus `interval`.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "endDate":   "2016-06-26T13:05:00Z",
        "interval": {"unit": "MINUTE", "count": 5},
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
        "d": "2016-06-26T13:00:01.000Z",
        "v": 17.71
      },
      {
        "d": "2016-06-26T13:00:17.000Z",
        "v": 3.06
      },
      {
        "d": "2016-06-26T13:00:33.000Z",
        "v": 10.1
      },
      {
        "d": "2016-06-26T13:00:49.000Z",
        "v": 7.14
      },
      {
        "d": "2016-06-26T13:01:05.000Z",
        "v": 3.03
      },
      {
        "d": "2016-06-26T13:01:21.000Z",
        "v": 3
      },
      {
        "d": "2016-06-26T13:01:37.000Z",
        "v": 7
      },
      {
        "d": "2016-06-26T13:01:53.000Z",
        "v": 3
      },
      {
        "d": "2016-06-26T13:02:09.000Z",
        "v": 9.18
      },
      {
        "d": "2016-06-26T13:02:25.000Z",
        "v": 4.9
      },
      {
        "d": "2016-06-26T13:02:41.000Z",
        "v": 9.18
      },
      {
        "d": "2016-06-26T13:02:57.000Z",
        "v": 8.08
      },
      {
        "d": "2016-06-26T13:03:13.000Z",
        "v": 13.13
      },
      {
        "d": "2016-06-26T13:03:29.000Z",
        "v": 3.03
      },
      {
        "d": "2016-06-26T13:03:45.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-26T13:04:01.000Z",
        "v": 5.05
      },
      {
        "d": "2016-06-26T13:04:17.000Z",
        "v": 7.07
      },
      {
        "d": "2016-06-26T13:04:33.000Z",
        "v": 12.24
      },
      {
        "d": "2016-06-26T13:04:49.000Z",
        "v": 3.03
      }
    ]
  }
]
```
