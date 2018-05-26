# Series Query: Average Threshold Percentage for Multiple Entities

## Description

Calculate average threshold percentage for multiple entities.

Workflow:

1. Define maximum threshold as 95.
2. Violation occurs if value is greater than 95.
3. Consecutive samples above the threshold (repeat values) are considered to be 1 violation.
4. Calculate threshold percent for each entity grouped by 10-minute periods.
5. Interpolate to 100% if no data is available in the given period.
6. Computed average threshold percentage using `group`. `group` is configured to execute after `aggregate`.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-02-19T13:00:00.000Z",
    "endDate": "2016-02-19T14:00:00.000Z",
    "entities": ["nurswgvml006", "nurswgvml007", "nurswgvml102"],
    "metric": "cpu_busy",
    "aggregate": {
      "period": { "count": 10, "unit": "MINUTE" },
      "threshold": { "max": 95 },
      "type": "THRESHOLD_PERCENT",
      "interpolate": { "type": "VALUE", "value": 100 },
      "order": 0
    },
    "group": {
        "type": "AVG",
        "order": 1
      }
  }
]
```

## Response

```json
[{"entity":"*","metric":"cpu_busy","tags":{},
    "entities":["nurswgvml006","nurswgvml007","nurswgvml102"],"type":"HISTORY",
    "aggregate":{"type":"THRESHOLD_PERCENT","period":{"count":10,"unit":"MINUTE","align":"CALENDAR"},
    "threshold":{"max":95.0}},
    "group":{"type":"AVG","order":1},
"data":[
    {"d":"2016-02-19T13:00:00.000Z","v":88.88533333333334},
    {"d":"2016-02-19T13:10:00.000Z","v":100.0},
    {"d":"2016-02-19T13:20:00.000Z","v":99.79805555555555},
    {"d":"2016-02-19T13:30:00.000Z","v":100.0},
    {"d":"2016-02-19T13:40:00.000Z","v":100.0},
    {"d":"2016-02-19T13:50:00.000Z","v":66.66666666666667}
]}]
```
