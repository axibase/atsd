# Series Query: Time Zone Formats

## Description

Query detailed data for the specified time range, identified with `startDate` and `endDate`.

Time zone offset can be specified with Z (UTC time), or with the `±hh:mm` format.

```ls
2016-02-22T08:30:08.000-05:00 === 2016-02-22T13:30:08.000Z
2016-02-22T16:30:08.500+03:00 === 2016-02-22T13:30:08.500Z
```

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "2016-02-22T08:30:08.000-05:00",
        "endDate":   "2016-02-22T16:30:08.500+03:00",
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
