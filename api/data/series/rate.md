# Rate Processor

## Overview

Computes the difference between consecutive samples per unit of time (rate period).

Used to compute rate of change when the underlying metric measures a continuously incrementing counter.

## Parameters

| **Name** | **Type**    | **Description**  |
|:---|:---|:---|
| `period` | object | Rate period. Supports NANOSECOND time unit. |
| `counter` | boolean | If `true`, negative differences between consecutive samples are ignored.<br>Default: `true`. |
| `order`         | integer           | Controls the processing sequence of the `group`, `rate` and `aggregate` stages. The stage with the smallest order is executed first. If the stages have the same order, the default order is: `group`, `rate`, `aggregate`. Default: `0`.  |

## Request

```json
[
  {
    "startDate": "2015-03-05T10:00:00Z",
    "endDate": "2015-03-05T12:00:00Z",
    "entity": "nurswgvml007",
    "metric": "net.tx_bytes",
    "tags": {
        "name": [
            "*"
        ]
    },
    "rate": {
        "period": {"count": 1, "unit": "MINUTE"},
        "counter": true
    }
  }
]
```

## Rate Period

* If rate period is not specified, the function returns the difference between consecutive values. If samples are `(time0, value0)` and `(time1, value1)` the result is `value1 - value0`.

* If rate period is specified, the function calculates the rate of change for each sample:

`(value1 - value0) / (time1 - time0) * ratePeriod`.

```javascript
ratePeriod = rate.count * rate.unit (in milliseconds)
if (value1 > value0) {
  resultValue = (value1 - value0) / (time1 - time0) * ratePeriod;
  aggregator.addValue(time1, resultValue);
}
```

## NANOSECOND Period Example

### Request

```json
[
  {
    "startDate": "2015-09-03T12:00:00Z",
    "endDate": "2015-09-03T12:05:00Z",
    "timeFormat": "iso",
    "entity": "e-nano",
    "metric": "m-nano",
    "rate": {
      "period": {
        "count": 1,
        "unit": "NANOSECOND"
      }
    }
  }
]
```

### Response

```json
[
  {
    "entity": "e-nano",
    "metric": "m-nano",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "rate": {
      "period": {
        "count": 1,
        "unit": "NANOSECOND"
      },
      "counter": true
    },
    "data": [
      {"d":"2015-09-03T12:00:00.002Z","v":0.7},
      {"d":"2015-09-03T12:00:00.003Z","v":0.1},
      {"d":"2015-09-03T12:00:00.004Z","v":0.4}
    ]
  }
]
```
