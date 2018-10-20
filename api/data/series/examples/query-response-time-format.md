# Series Query: Return Data in Milliseconds

## Description

Query detailed data for the specified time range and return data in Unix time with millisecond precision.

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
        "metric": "mpstat.cpu_busy",
        "timeFormat": "milliseconds"
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
        "t": 1456147808000,
        "v": 4
      },
      {
        "t": 1456147824000,
        "v": 3.03
      },
      {
        "t": 1456147840000,
        "v": 6.06
      },
      {
        "t": 1456147856000,
        "v": 4
      },
      {
        "t": 1456147872000,
        "v": 5.05
      },
      {
        "t": 1456147888000,
        "v": 6.06
      },
      {
        "t": 1456147904000,
        "v": 4.04
      },
      {
        "t": 1456147920000,
        "v": 30
      },
      {
        "t": 1456147936000,
        "v": 3.96
      },
      {
        "t": 1456147952000,
        "v": 6
      },
      {
        "t": 1456147968000,
        "v": 2.04
      },
      {
        "t": 1456147984000,
        "v": 45.65
      },
      {
        "t": 1456148000000,
        "v": 4.95
      },
      {
        "t": 1456148016000,
        "v": 7
      },
      {
        "t": 1456148032000,
        "v": 3
      },
      {
        "t": 1456148048000,
        "v": 2
      },
      {
        "t": 1456148064000,
        "v": 3.03
      },
      {
        "t": 1456148080000,
        "v": 6
      },
      {
        "t": 1456148096000,
        "v": 4.04
      }
    ]
  }
]
```
