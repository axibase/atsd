# Series Query: Regularize

## Description

The underlying series can be regularized by applying periodic aggregation using the `FIRST` or `LAST` function and turning on interpolation to fill the gaps created by periods without data. The technique is called "downsampling" in reference to a fewer number of returned data points.

* `FIRST` returns the first observed value in the given period.
* `LAST` returns the last observed value in the given period.

Both functions return raw (detailed) values, unlike `AVERAGE` and percentile functions, which calculate smoothed statistics.

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
    "aggregate": {
      "period": {"count": 1, "unit": "MINUTE"},
      "type": "FIRST",
      "interpolate": {"type": "LINEAR"}
    }
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
      "type": "FIRST",
      "period": {
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 12
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 3
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 5.05
      }
    ]
  }
]
```
