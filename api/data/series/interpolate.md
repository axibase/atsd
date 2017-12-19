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

**Dataset**

```
series e:nurswgvml007 m:cpu_busy=-1 d:2016-12-31T23:30:00Z
series e:nurswgvml007 m:cpu_busy=0  d:2017-01-01T00:30:00Z
series e:nurswgvml007 m:cpu_busy=2  d:2017-01-01T02:30:00Z
series e:nurswgvml007 m:cpu_busy=3  d:2017-01-01T03:30:00Z
```

```ls
| datetime         | value | 
|------------------|-------| 
| 2016-12-31 23:30 | -1    | 
| 2017-01-01 00:30 | 0     | 
| 2017-01-01 01:30 | ...   | -- Sample at 01:30 is missing.
| 2017-01-01 02:30 | 2     | 
| 2017-01-01 03:30 | 3     | 
```

### Fill Gaps with LINEAR Function

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
    "function": "LINEAR",
    "period": {"count": 1, "unit": "HOUR"}
  }
}]
```

**Response**

In the default `INNER` mode the values outside of the selection interval are ignored.

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 01:00 | 0.5   | 
| 2017-01-01 02:00 | 1.5   | 
| 2017-01-01 03:00 | 2.5   | 
```

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[
	{"d":"2017-01-01T01:00:00Z","v":0.5},
	{"d":"2017-01-01T02:00:00Z","v":1.5},
	{"d":"2017-01-01T03:00:00Z","v":2.5}
]}]
```

### 30 Minutes Period LINEAR Interpolation

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 30, "unit": "MINUTE"}
    }
}]
```

**Response**

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:30 | 0.0   | 
| 2017-01-01 01:00 | 0.5   | 
| 2017-01-01 01:30 | 1.0   | 
| 2017-01-01 02:00 | 1.5   |
| 2017-01-01 02:30 | 2.0   | 
| 2017-01-01 03:00 | 2.5   | 
| 2017-01-01 03:30 | 3.0   | 
```

### Fill Gaps using PREVIOUS Function

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
    "interpolate" : {
        "function": "PREVIOUS",
        "period": {"count": 1, "unit": "HOUR"}
    }
}]
```

**Response**

In the default `INNER` mode the values outside of the selection interval are ignored.

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 01:00 | 0.0   | 
| 2017-01-01 02:00 | 0.0   | 
| 2017-01-01 03:00 | 2.0   | 
```

### LINEAR Interpolation with OUTER Boundary

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR"},
        "boundary": "OUTER"
    }
}]
```

**Response**

In the `OUTER` mode the values outside of the selection interval are used to interpolate leading and trailing values.

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:00 | -0.5  | 
| 2017-01-01 01:00 | 0.5   | 
| 2017-01-01 02:00 | 1.5   | 
| 2017-01-01 03:00 | 2.5   | 
```

### LINEAR Interpolation with START_TIME Align

```json
[{
  "startDate": "2017-01-01T00:15:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR", "align": "START_TIME"}
    }
}]
```

**Response**

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 01:15 | 0.75  | 
| 2017-01-01 02:15 | 1.75  | 
| 2017-01-01 03:15 | 2.75  | 
```

### LINEAR Interpolation with END_TIME Align

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T04:45:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR", "align": "END_TIME"}
    }
}]
```

**Response**

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:45 | 0.25  | 
| 2017-01-01 01:45 | 1.25  | 
| 2017-01-01 02:45 | 2.25  | 
```

### LINEAR Interpolation with FIRST_VALUE_TIME Align

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

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:30 | 0.0   | 
| 2017-01-01 01:30 | 1.0   | 
| 2017-01-01 02:30 | 2.0   | 
| 2017-01-01 03:30 | 3.0   | 
```

### LINEAR Interpolation with Missing Values Filling

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
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

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:00 | 0.0   | 
| 2017-01-01 01:00 | 0.5   | 
| 2017-01-01 02:00 | 1.5   | 
| 2017-01-01 03:00 | 2.5   | 
| 2017-01-01 04:00 | 3.0   | 
```

### LINEAR Interpolation with Missing Values Filling with NaN

```json
[{
  "startDate": "2017-01-01T00:00:00Z",
  "endDate":   "2017-01-01T05:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 1, "unit": "HOUR"},
        "fill": "NaN"
    }
}]
```

**Response**

```ls
| datetime         | value | 
|------------------|-------| 
| 2017-01-01 00:00 | null  | 
| 2017-01-01 01:00 | 0.5   | 
| 2017-01-01 02:00 | 1.5   | 
| 2017-01-01 03:00 | 2.5   | 
| 2017-01-01 04:00 | null  | 
```
