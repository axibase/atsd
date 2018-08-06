# Interpolation

## Overview

Interpolation transforms an input time series to a regularized series by calculating values at evenly spaced intervals using a linear or step function.

The interpolation process performed by the database is outlined below:

1. Load samples for the selection interval specified with `startDate` and `endDate` parameters.
2. If `OUTER` boundary mode is enabled, load one value before and one value after the selection interval to interpolate leading and trailing values.
3. Create evenly spaced timestamps within the selection interval. Timestamps can be aligned to a calendar or start/end time of the selection interval.
4. For each timestamp, calculate the value from the two nearest neighbor samples using `linear` or `step` interpolation function.
5. If `fill` parameter is enabled, add missing leading and trailing values.

## Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| [`period`](#period) | object | **[Required]** Repeated time interval. |
| [`function`](#function) | string | **[Required]** `PREVIOUS`, `LINEAR`, or `AUTO`. |
| [`extend`](#extend) | string | Enables values outside of the selection interval. |
| [`fill`](#fill) | string | Creates missing leading and trailing values. |

### `period`

[Period](period.md) is a repeating time interval used to create evenly spaced timestamps.

**Examples**:

* `{ "count": 1, "unit": "HOUR" }`
* `{ "count": 15, "unit": "MINUTE", "align": "START_TIME" }`
* `{ "count": 1, "unit": "DAY", "align": "CALENDAR", "timezone": "US/Pacific" }`

### `function`

| **Name** | **Description**   |
|:---|:---|
| `LINEAR`  | Calculates value by adding the difference between neighboring detailed values proportional to their time difference. |
| `PREVIOUS`  | Sets value equal to previous value. |
| `AUTO`  | Applies the interpolation function specified in the metric [interpolate](../../meta/metric/list.md#fields) field.<br>Default: `LINEAR`.  |

> Detailed values with timestamps that are equal to interpolated timestamps are included in the response unmodified.
> `LINEAR` function returns an interpolated value only if both a preceding and following value are present.
> `PREVIOUS` function requires the presence of a preceding value. The last detailed value is used to calculate a final interpolated value in the response.

### `extend`

| **Name** | **Description**   |
|:---|:---|
| `false`  | **[Default]** Data outside of the selection interval is not loaded by the database. |
| `true`  | One value before and one value after the selection interval is loaded by the database to interpolate leading and trailing values. |

Examples:

* `{ "extend": true }`

### `fill`

The purpose of the `fill` parameter is to eliminate gaps at the beginning and the end of the selection interval. If `boundary` is `OUTER` and there are values on both sides of the selection interval, `fill` parameter is not applied.

| **Name** | **Description**   |
|:---|:---|
| `false`  | **[Default]** Do not add missing values. |
| `true`  | Add missing leading values by setting them to the first available detailed value.<br>Add missing trailing values by setting them to the last available detailed value.|
| `{n}`  | Add missing leading and trailing values by setting them to the specified number `{n}`.<br>The number `{n}` can be any decimal number as well as `NaN` string (Not a Number). |

Examples:

* `{ "fill": false }`
* `{ "fill": true }`
* `{ "fill": 0 }`
* `{ "fill": "NaN" }`

## Examples

**Dataset**:

```ls
series e:nurswgvml007 m:cpu_busy=5.8 d:2016-02-19T13:00:00Z
series e:nurswgvml007 m:cpu_busy=4.6  d:2016-02-19T13:10:00Z
series e:nurswgvml007 m:cpu_busy=7.9  d:2016-02-19T13:20:00Z
series e:nurswgvml007 m:cpu_busy=4.9  d:2016-02-19T13:30:00Z
series e:nurswgvml007 m:cpu_busy=100.00  d:2016-02-19T13:50:00Z
series e:nurswgvml007 m:cpu_busy=21.0  d:2016-02-19T14:00:00Z
```

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:20 | 7.9   |
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:40 | ...   | -- Sample at 13:40 is missing.
| 2016-02-19 13:50 | 100.0 |
| 2016-02-19 14:00 | 21.0  |
```

### Fill Gap with `LINEAR` Function

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "interpolate": {"type": "LINEAR"},
  "period": {"count": 10, "unit": "MINUTE"}
},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

With default `INNER` mode, values outside of the selection interval are ignored.

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:40 | 52.0  |
| 2016-02-19 13:50 | 100.0 |
| 2016-02-19 14:00 | 21.0  |
```

![](./images/linear-interpolation-example.png)

[![](./images/button.png)](https://apps.axibase.com/chartlab/7cb52024)

### `LINEAR` Function: `5 Minute` Period

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "interpolate": {"type": "LINEAR"},
  "period": {"count": 5, "unit": "MINUTE"}
},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:35 | 23.9  |
| 2016-02-19 13:40 | 43.0  |
| 2016-02-19 13:45 | 62.0  |
| 2016-02-19 13:50 | 81.0  |
| 2016-02-19 13:55 | 100.0 |
| 2016-02-19 14:00 | 35.0  |
```

![](./images/linear-interpolation-example3.png)

[![](./images/button.png)](https://apps.axibase.com/chartlab/22b6439b)

### Fill Gaps with `PREVIOUS` Function

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "interpolate": {"type": "PREVIOUS"},
  "period": {"count": 10, "unit": "MINUTE"}
},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

With default `INNER` mode, values outside of the selection interval are ignored.

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:40 | 4.9   |
| 2016-02-19 13:50 | 100.0 |
| 2016-02-19 14:00 | 21.0  |
```

![](./images/previous-interpolation-example.png)

[![](./images/button.png)](https://apps.axibase.com/chartlab/199a8278)

### `LINEAR` Interpolation with `OUTER` Boundary

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "interpolate": {"type": "LINEAR", "extend": true},
  "period": {"count": 10, "unit": "MINUTE"}
},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

With `OUTER` mode, values outside of the selection interval are used to interpolate leading and trailing values.

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:40 | 52.0  |
| 2016-02-19 13:50 | 100.0 |
| 2016-02-19 14:00 | 21.0  |
```

### `LINEAR` Interpolation with `START_TIME` Alignment

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "interpolate": {"type": "LINEAR", "extend": true},
  "period": {"count": 10, "unit": "MINUTE", "align": "START_TIME"}
},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 4.9   |
| 2016-02-19 13:40 | 53.0  |
| 2016-02-19 13:50 | 100.0 |
| 2016-02-19 14:00 | 22.0  |
```

### `LINEAR` Interpolation, Leading/Trailing Values Filled

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "period": {"count": 10, "unit": "MINUTE"}
},
"interpolate": {"function": "LINEAR", "fill": true, "period": {"count": 10, "unit": "MINUTE"}},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:30 | 3.3   |
| 2016-02-19 13:40 | 35.0  |
| 2016-02-19 13:50 | 69.2  |
| 2016-02-19 14:00 | 100.0 |
```

### `LINEAR` Interpolation, Leading/Trailing Values Filled with `NaN`

```json
[{
"entity": "nurswgvml007",
"metric": "cpu_busy",
"aggregate": {
  "types": ["AVG"],
  "period": {"count": 10, "unit": "MINUTE"}
},
"interpolate": {"function": "LINEAR", "fill": "NaN", "period": {"count": 10, "unit": "MINUTE"}},
"startDate": "2016-02-19T13:00:00.000Z",
"endDate": "2016-02-19T14:20:00.000Z",
"timeFormat": "iso"
}]
```

**Response**:

```ls
| datetime         | value |
|------------------|-------|
| 2016-02-19 13:00 | nul   |
| 2016-02-19 13:10 | 5.5   |
| 2016-02-19 13:20 | 4.3   |
| 2016-02-19 13:30 | 3.3   |
| 2016-02-19 13:40 | 35.0  |
| 2016-02-19 13:50 | 69.2  |
| 2016-02-19 14:00 | 100.0 |
```

### Interpolation Portal

![](./images/interpolation-portal.png)

[![](./images/button.png)](https://apps.axibase.com/chartlab/d8c03f11/3/#)