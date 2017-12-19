# Interpolation

## Overview

The transformation creates a regularized time series with the specified period by calculating values at each timestamp from neighboring samples using linear or step functions.

## Interpolation Process

1. Create an array of evenly spaced timestamps with the specified period and aligned either to calendar or start/end time.
2. Load detailed data for the selection interval specified with `startDate` and `endDate` parameters.
3. If `OUTER` boundary mode is enabled, load one value before and one value after the selection interval in order to interpolate leading and trailing values.
4. For each timestamp, calculate the value from the two neighboring values using the specified interpolation function.
5. If `fill` is enabled, add missing leading and trailing values.

## Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| [function](#function) | string | [**Required**] `PREVIOUS`, `LINEAR`, or `AUTO`. |
| [period](#period) | object | [**Required**] Repeating time interval. |
| [boundary](#boundary) | string | Controls if loading of values outside of the selection interval. |
| [fill](#fill) | string | Creates missing leading and trailing values. |

### function

| **Name** | **Description**   |
|:---|:---|
| `LINEAR`  | Calculates the value by adding a difference between neighboring detailed values proportional to their time difference. |
| `PREVIOUS`  | Sets the value to equal the previous value. |
| `AUTO`  | Applies the interpolation function specified in the metric's [interpolate](../../meta/metric/list.md#fields) field (set to `LINEAR` by default).  |

### period

[Period](period.md) is a repeating time interval used to create evenly spaced timestamps.

Examples:

* `{ "count": 1, "unit": "HOUR" }`
* `{ "count": 15, "unit": "MINUTE", "align": "END_TIME" }`
* `{ "count": 1, "unit": "DAY", "align": "CALENDAR", "timezone": "US/Pacific" }`

### boundary

| **Name** | **Description**   |
|:---|:---|
| `INNER`  | [**Default**] Do not load data outside of the selection interval. |
| `OUTER`  | Load one value before and one value after the selection interval in order to interpolate leading and trailing values. |

Examples:

* `{ "boundary": "OUTER" }`

### fill

| **Name** | **Description**   |
|:---|:---|
| `false`  | [**Default**] Do not add missing values. |
| `true`  | Add missing leading values by setting them to the first available detailed value.<br>Add missing trailing values by setting them to the last available detailed value.|
| `{n}`  | Add missing leading and trailing values by setting them to the specified number `{n}`.<br>The number `{n}` can be any decimal number as well as "NaN" string (Not a Number). |

Examples:

* `{ "fill": false }`
* `{ "fill": true }`
* `{ "fill": 0 }`
* `{ "fill": "NaN" }`

## Examples

These series are used for examples

```
series e:nurswgvml007 m:cpu_busy=0 d:2017-01-01T00:30:00Z
series e:nurswgvml007 m:cpu_busy=2 d:2017-01-01T02:30:00Z
series e:nurswgvml007 m:cpu_busy=3 d:2017-01-01T03:30:00Z
```

### Request: Fill Gap using LINEAR Interpolation

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T04:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
    "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T01:00:00.000Z","v":0.5},
	{"d":"2017-01-01T02:00:00.000Z","v":1.5},
	{"d":"2017-01-01T03:00:00.000Z","v":2.5}
]}]
```

### Request: Fill Gap using PREVIOUS Interpolation

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T04:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
    "interpolate" : {
        "function": "PREVIOUS",
        "period": {"count": 1, "unit": "HOUR"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T01:00:00.000Z","v":0.0},
	{"d":"2017-01-01T02:00:00.000Z","v":0.0},
	{"d":"2017-01-01T03:00:00.000Z","v":2.0}
]}]
```

### Request: 30 Minutes Period LINEAR Interpolation

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T04:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 30, "unit": "MINUTE"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:30:00.000Z","v":0.0},
	{"d":"2017-01-01T01:00:00.000Z","v":0.5},
	{"d":"2017-01-01T01:30:00.000Z","v":1.0},
	{"d":"2017-01-01T02:00:00.000Z","v":1.5},
	{"d":"2017-01-01T02:30:00.000Z","v":2.0},
	{"d":"2017-01-01T03:00:00.000Z","v":2.5},
	{"d":"2017-01-01T03:30:00.000Z","v":3.0}
]}]
```

### Request: LINEAR Interpolation with START_TIME Align

```json
[{
  "startDate": "2017-01-01T00:30:00Z",
  "endDate":   "2017-01-01T04:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR", "align": "START_TIME"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:30:00.000Z","v":0.0},
	{"d":"2017-01-01T01:30:00.000Z","v":1.0},
	{"d":"2017-01-01T02:30:00.000Z","v":2.0},
	{"d":"2017-01-01T03:30:00.000Z","v":3.0}
]}]
```

### Request: PREVIOUS Interpolation with END_TIME Align

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T04:45:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "PREVIOUS",
        "period": {"count": 1, "unit": "HOUR", "align": "END_TIME"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:45:00.000Z","v":0.0},
	{"d":"2017-01-01T01:45:00.000Z","v":0.0},
	{"d":"2017-01-01T02:45:00.000Z","v":2.0},
	{"d":"2017-01-01T03:45:00.000Z","v":3.0}
]}]
```

### Request: LINEAR Interpolation with FIRST_VALUE_TIME Align

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR", "align": "FIRST_VALUE_TIME"}
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:30:00.000Z","v":0.0},
	{"d":"2017-01-01T01:30:00.000Z","v":1.0},
	{"d":"2017-01-01T02:30:00.000Z","v":2.0},
	{"d":"2017-01-01T03:30:00.000Z","v":3.0}
]}]
```

### Request: LINEAR Interpolation with Missing Values Filling

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T06:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR"},
        "fill": true
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:00:00.000Z","v":0.0},
	{"d":"2017-01-01T01:00:00.000Z","v":0.5},
	{"d":"2017-01-01T02:00:00.000Z","v":1.5},
	{"d":"2017-01-01T03:00:00.000Z","v":2.5},
	{"d":"2017-01-01T04:00:00.000Z","v":3.0},
	{"d":"2017-01-01T05:00:00.000Z","v":3.0}
]}]
```

### Request: LINEAR Interpolation with Missing Values Filling with -1

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T06:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR"},
        "fill": "-1"
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T00:00:00.000Z","v":-1.0},
	{"d":"2017-01-01T01:00:00.000Z","v":0.5},
	{"d":"2017-01-01T02:00:00.000Z","v":1.5},
	{"d":"2017-01-01T03:00:00.000Z","v":2.5},
	{"d":"2017-01-01T04:00:00.000Z","v":-1.0},
	{"d":"2017-01-01T05:00:00.000Z","v":-1.0}
]}]
```

### Request: PREVIOUS Interpolation with OUTER Boundary

```json
[{
  "startDate": "2017-01-01T01:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "PREVIOUS",
        "period": {"count": 1, "unit": "HOUR"},
        "boundary": "OUTER"
    }
}]
```

**Response**

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T01:00:00.000Z","v":0.0},
	{"d":"2017-01-01T02:00:00.000Z","v":0.0},
	{"d":"2017-01-01T03:00:00.000Z","v":2.0},
	{"d":"2017-01-01T04:00:00.000Z","v":3.0}
]}]
```
