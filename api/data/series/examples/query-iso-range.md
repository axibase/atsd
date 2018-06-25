# Series Query: Time Range in ISO Format

## Description

Query detailed (raw) data for the specified time range, identified with `startDate` and `endDate`.

`startDate` is inclusive and `endDate` is exclusive, meaning that samples timestamped exactly at `startDate` is included in the response. Samples timestamped exactly at `endDate` is **not** included in the response.

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
      },
      {
        "d": "2016-02-22T13:31:12.000Z",
        "v": 5.05
      },
      {
        "d": "2016-02-22T13:31:28.000Z",
        "v": 6.06
      },
      {
        "d": "2016-02-22T13:31:44.000Z",
        "v": 4.04
      },
      {
        "d": "2016-02-22T13:32:00.000Z",
        "v": 30
      },
      {
        "d": "2016-02-22T13:32:16.000Z",
        "v": 3.96
      },
      {
        "d": "2016-02-22T13:32:32.000Z",
        "v": 6
      },
      {
        "d": "2016-02-22T13:32:48.000Z",
        "v": 2.04
      },
      {
        "d": "2016-02-22T13:33:04.000Z",
        "v": 45.65
      },
      {
        "d": "2016-02-22T13:33:20.000Z",
        "v": 4.95
      },
      {
        "d": "2016-02-22T13:33:36.000Z",
        "v": 7
      },
      {
        "d": "2016-02-22T13:33:52.000Z",
        "v": 3
      },
      {
        "d": "2016-02-22T13:34:08.000Z",
        "v": 2
      },
      {
        "d": "2016-02-22T13:34:24.000Z",
        "v": 3.03
      },
      {
        "d": "2016-02-22T13:34:40.000Z",
        "v": 6
      },
      {
        "d": "2016-02-22T13:34:56.000Z",
        "v": 4.04
      }
    ]
  }
]
```
