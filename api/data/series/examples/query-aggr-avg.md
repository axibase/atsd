# Series Query: Calculate Average Value per Period

## Description

Assign detailed values to repeating periods and compute averages of all values in the given period.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:15:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 1, "unit": "MINUTE"},
                  "type": "AVG"}
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "AVG",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 7.4775
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 8.593333333333334
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 12.845
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 13.1675
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.746666666666666
      }
    ]
  }
]
```
