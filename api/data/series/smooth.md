# Time Series Smoothing

## Overview

Smoothing leaves out noise from time series. This transformation averages values of the series grouped into a rolling window.

### Basic Example

```json
"smooth": {
  "type": "AVG",
  "interval": {"count": 1, "unit": "HOUR"}
}
```

This example performs moving average smoothing with 1-hour sliding window.

## Parameters

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `type` | string | [**Required**] [Smoothing function.](#smoothing-functions) Available functions: `AVG`, `WAVG`, `WTAVG`, `EMA`. |
| `count` | number | [**Required if the `interval` is not specified**] Number of series samples within regular window. |
| `interval` | object | [**Required if the `count` is not specified**] Sliding window duration specified as count and time unit. |
| `minimalCount` | number | Threshold which triggers calculation of the smoothing function for a window. View the [processing](#processing) section for details. <br> Default: `0` if the `interval` parameter is specified, and equals to value of the `count` otherwise. |
| `range` | double | [Required for the `EMA`] Regulates the smoothing function flatness. |
| `order` | integer | Controls the order of smoothing in the sequence of other series [transformations](./query.md#transformations).<br>Default: `0`.|

> Specify exactly one of the `count` and `interval` parameters.

## Processing

The samples in the input series are processed sequentially in ascending time order.
A set of consecutive samples is maintained during processing. This set is called **sliding window** or **window** for short. Initially the window is empty. For each series sample the following steps are executed in order:

* Decide if the window has enough samples to calculate smoothing function. [Time based](#time-based-window) and [count based](#count-based-window) windows make this decision differently.
* Set `v` equal either to the value of smoothing function over the window, or to the `NaN` (not a number) depends on decision made on previous step.
* Write out the sample `(t, v)` to the output series, where `t` is timestamp of the latest sample in the window.
* Add the current sample to the window.
* If window is overflown, then remove necessary number of oldest samples from the window. Again [time based](#time-based-window) and [count based](#count-based-window) windows have their own sense of overflow.

After all series samples are processed write one more sample into resulting series. The sample timestamp is the last timestamp of the last window. If number of samples in the window exceeds `minimalCount`, then value is average over the window. Othrevise value is `NaN`.

## Time based window

The `interval` setting specifies time based window.
Denote:

* `u` - first sample in the window.
* `v` - last sample in the window.
* `w` - first sample after the window.
* `n` - number of samples in the window.

Smoothing function is calculated for the window if `w - u > interval && n > minimalCount`.
The window is overflown if `v - u > interval`.

## Count based window

The `count` parameter determines this type of window.
If number of samples in the window exceeds `minimalCount` then smoothing function is calculated for the window. If the number of samples is more than `count` then the window considered as overflown.

## Smoothing functions

### AVG: Average

Mean of values within window: sum of values divided by number of values.

### WAVG: Weighted Average

Weighted average of values within window. Weight of the i-th value is proportional to `i`, and sum of weights equals to 1.

```js
(1 * v1 + 2 * v2 + ... + n * vn) / (1 + 2 + ... + n)
```

### WTAVG: Weighted Time Average

Let window contains samples `(t1, v1), (t2, v2), ..., (tn, vn)`,
where `ti` is timestamp of i-th sample measured in milliseconds,
and `vi` is the sample's value.
Define `wi = ti - t1 + 1000`.
We add the puzzling `1000` summand only to make `w1` not zero.
The smoothing function value for this window equals to

```js
(w1 * v1 + w2 * v2 + ... + wn * vn) / (w1 + w2 + ... + wn)
```

> Time Weighted Average (TWA) sounds better.

### EMA: Exponential Moving Average

Let `(t1, v1), (t2, v2), ..., (tn, vn)` are all series samples whose timestamps don't
exceed `tn`.
Rolling window is not used for this type of smoothing.
The smoothed value at time 'tn' is weighted average `w1 * v1 + w2 * v2 + ... + wn * vn`, where weights are positive and sum up to 1.
The biggest weight is the last one:

<code>
wn = 1 - exp<sup>-(t<sub>n</sub> - t<sub>n-1</sub>)/r</sup>
</code>,
where `r` is value specified in the `range` parameter.
So the less `range` the more weight `wn` of the latest series value.
