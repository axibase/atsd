# Rate Processor

## Overview 

Computes difference between consecutive samples per unit of time (rate period). 

Used to compute rate of change when the underlying metric measures a continuously incrementing counter.

## Parameters

| **Name** | **Type**    | **Description**  |
|:---|:---|:---|
| period | object | Rate period. Supports NANOSECOND time unit. |
| counter | boolean | If true, negative differences between consecutive samples are ignored. Default: true |
| order         | number           | Change the order in which `group`, `rate`, and `aggregate` are executed, the higher the value of `order` the later in the sequence will it be executed. Default: 0. |

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

- If rate period is not specified, the function computes difference between values of two susequent series samples. So if samples are `(previousTimestamp, previousValue)` and `(timestamp, value)`, then result would be `(timestamp, value - previousValue)`.


- If rate period is specified, the function computes rate of change for the specified time period: 

`(value - previousValue) * ratePeriod / (timestamp - previousTimestamp)`.

```java
  ratePeriod = rate.count * rate.unit (in milliseconds)
  if (value > previousValue) {
    resultValue = (value - previousValue) / (timestamp - previousTime) * ratePeriod;
    aggregator.addValue(timestamp, resultValue);
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
            "metric": "m-nano"
            ,"rate" : {
               "period": {"count": 1, "unit": "NANOSECOND"}
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
          {
              "d": "2015-09-03T12:00:00.002Z",
              "v": 0.7
          },
          {
              "d": "2015-09-03T12:00:00.003Z",
              "v": 0.1
          },
          {
              "d": "2015-09-03T12:00:00.004Z",
              "v": 0.4
          }
      ]
  }
]
```
