# Series Query: Threshold with Working Hours Filter

## Description

To calculate threshold violation statistics, apply the working hours filter.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "previous_day",
    "endDate":   "current_day",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {
      "types": [
        "THRESHOLD_COUNT",
        "THRESHOLD_DURATION",
        "THRESHOLD_PERCENT"
      ],
      "period": {
        "count": 1,
        "unit": "HOUR"
      },
      "workingMinutes": {
        "start": 540,
        "end": 1080
      },
      "threshold": {
        "max": 90
      }
    }
  }
]
```

## Response

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"THRESHOLD_COUNT",
    "period":{"count":1,"unit":"HOUR","align":"CALENDAR"},
    "threshold":{"max":90.0},"workingMinutes":{"start":540,"end":1080}},
"data":[
    {"d":"2016-06-27T09:00:00.000Z","v":3},
    {"d":"2016-06-27T10:00:00.000Z","v":1},
    {"d":"2016-06-27T11:00:00.000Z","v":1},
    {"d":"2016-06-27T12:00:00.000Z","v":3},
    {"d":"2016-06-27T13:00:00.000Z","v":1},
    {"d":"2016-06-27T14:00:00.000Z","v":6},
    {"d":"2016-06-27T15:00:00.000Z","v":5},
    {"d":"2016-06-27T16:00:00.000Z","v":5},
    {"d":"2016-06-27T17:00:00.000Z","v":1}
]},
{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"THRESHOLD_DURATION",
    "period":{"count":1,"unit":"HOUR","align":"CALENDAR"},
    "threshold":{"max":90.0},"workingMinutes":{"start":540,"end":1080}},
"data":[
    {"d":"2016-06-27T09:00:00.000Z","v":11438},
    {"d":"2016-06-27T10:00:00.000Z","v":6911},
    {"d":"2016-06-27T11:00:00.000Z","v":9100},
    {"d":"2016-06-27T12:00:00.000Z","v":99547},
    {"d":"2016-06-27T13:00:00.000Z","v":36210},
    {"d":"2016-06-27T14:00:00.000Z","v":158877},
    {"d":"2016-06-27T15:00:00.000Z","v":56667},
    {"d":"2016-06-27T16:00:00.000Z","v":123805},
    {"d":"2016-06-27T17:00:00.000Z","v":3334}
]},
{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"THRESHOLD_PERCENT",
    "period":{"count":1,"unit":"HOUR","align":"CALENDAR"},
    "threshold":{"max":90.0},"workingMinutes":{"start":540,"end":1080}},
"data":[
    {"d":"2016-06-27T09:00:00.000Z","v":99.68227777777778},
    {"d":"2016-06-27T10:00:00.000Z","v":99.80802777777778},
    {"d":"2016-06-27T11:00:00.000Z","v":99.74722222222222},
    {"d":"2016-06-27T12:00:00.000Z","v":97.23480555555555},
    {"d":"2016-06-27T13:00:00.000Z","v":98.99416666666667},
    {"d":"2016-06-27T14:00:00.000Z","v":95.58675},
    {"d":"2016-06-27T15:00:00.000Z","v":98.42591666666667},
    {"d":"2016-06-27T16:00:00.000Z","v":96.56097222222222},
    {"d":"2016-06-27T17:00:00.000Z","v":99.90738888888889}
]}]
```
