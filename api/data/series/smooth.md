# Time Series Smoothing

## Overview

Smoothing leaves out noise from original time series. This transformation averages values of the  input series grouped into window sliding along series.

### Basic Example

```json
"smooth": {
  "type": "AVG",
  "interval": {"count": 1, "unit": "HOUR"}
}
```

In this example the moving average smoothing of the original series is performed over 1-hour sliding window.

## Parameters

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `type` | string | [**Required**] Smoothing function. Available functions: `AVG`. |
| `count` | number | [**Required if the `interval` is not specified**] Sliding window size measured as number of series samples within the window. |
| `interval` | object | [**Required if the `count` is not specified**] Sliding window duration specified as count and time unit. |
| `minimalCount` | number | Threshold which triggers calculation of the smoothing function for a window. View the [processing](#processing) section for details. <br> Default: `0` if the `interval` parameter is specified, and equals to value of the `count` otherwise. |
| `order` | integer | Controls the order of smoothing in the sequence of other series [transformations](./query.md#transformations).<br>Default: `0`.|

> Specify exactly one of the `count` and `interval` parameters.

## Processing

The samples in the input series are processed sequentially in ascending time order.
A set of consecutive series samples is maintained during processing. This set is called **sliding window** or **window** for short. Initially the window is empty. For each series sample the following steps are executed in order:

* Decide if the window has enough samples to calculate smoothing function. [Time based](#time-based-window) and [count based](#count-based-window) windows make their decisions differently.
* Set `v` equal either to the value of smoothing function over the window, or to the `NaN` (not a number) depends on decision made on previous step.
* Write out the sample `(t, v)` to the output series, where `t` is timestamp of the latest sample in the window.
* Add the current sample to the window.
* If window is overflown, then remove necessary number of oldest samples from the window. Again [time based](#time-based-window) and [count based](#count-based-window) windows have their own sense of overflow.

When series ends one more sample is written to the resulting series. Timestamp of this sample is the last timestamp of the last window. If number of samples in the last window exceeds the `minimalCount` threshold, then sample's value is the value of the smoothing function over the window. Othrevise sample's value is `NaN`.

## Time based window

Time based window is specified by the `interval` setting.
Denote:

* `u` - the first sample in the window.
* `v` - the last sample in the window.
* `w` - the first sample after the window.
* `n` - number of samples in the window.

The smoothing function is calculated for the window if `w - u > interval && n > minimalCount`.
The window is overflown if `v - u > interval`.

## Count based window

This type of window is used if the `count` parameter is provided.
If number of samples in the window exceeds `minimalCount` then smoothing function is calculated for the window. If the number of samples is more than `count` then the window is overflown.
