# Statistical Functions

## Overview

The univariate statistical functions listed below perform calculations on an array of numeric values stored in a window.

:::warning Warning
The functions cannot be invoked in [filter](filters.md#filter-expression) expressions.
:::

Functions such as [`countIf`](#countif), [`avgIf`](#avgif), and [`sumIf`](#sumif) perform calculations on a **subset** of matching values in the current window based on a boolean condition.

## Reference

* [`avg`](#avg)
* [`mean`](#mean)
* [`sum`](#sum)
* [`min`](#min)
* [`max`](#max)
* [`wavg`](#wavg)
* [`wtavg`](#wtavg)
* [`ema`](#ema)
* [`count`](#count)
* [`countNaN`](#countnan)
* [`percentile`](#percentile)
* [`median`](#median)
* [`variance`](#variance)
* [`stdev`](#stdev)
* [`intercept`](#intercept)
* [`median_abs_dev`](#median_abs_dev)
* [`first`](#first)
* [`last`](#last)
* [`diff`](#diff)
* [`delta`](#delta)
* [`new_maximum`](#new_maximum)
* [`new_minimum`](#new_minimum)
* [`threshold_time`](#threshold_time)
* [`threshold_linear_time`](#threshold_linear_time)
* [`rate_per_second`](#rate_per_second)
* [`rate_per_minute`](#rate_per_minute)
* [`rate_per_hour`](#rate_per_hour)
* [`slope`](#slope)
* [`slope_per_second`](#slope_per_second)
* [`slope_per_minute`](#slope_per_minute)
* [`slope_per_hour`](#slope_per_hour)
* [`countIf`](#countif)
* [`avgIf`](#avgif)
* [`sumIf`](#sumif)

### `avg`

```javascript
avg() double
```

Calculates average value. For example, `avg()` for a `5-minute` time-based window returns the average value for all samples received within this period of time.

### `mean`

```javascript
mean() double
```

Calculates average value. Same as `avg()`.

### `sum`

```javascript
sum() double
```

Sums all included values.

### `min`

```javascript
min() double
```

Returns minimum value.

### `max`

```javascript
max() double
```

Returns maximum value.

### `wavg`

```javascript
wavg() double
```

Calculates weighted average. Weight is the sample index which starts from `0` for the first sample. The function assigns more weight to more recent samples, based on the sample order.

### `wtavg`

```javascript
wtavg() double
```

Calculates weighted **time** average where sample weight is calculated according to the following formula:

```javascript
w = (command_time.millis - time_first())/(time_last() - time_first() + 1)
```

Times are rounded to Unix seconds.

The function assigns more weight to more recent samples, based on the difference between sample time and window start.

### `ema`

```javascript
ema([double factor]) double
```

Calculates [exponential moving average](../api/data/series/smooth.md#exponential-moving-average) from values present in the window. The optional smoothing `factor` must be within the `(0, 1)` range. the default `factor` is `0.25`.

The function assigns more weight to more recent samples.

### `count`

```javascript
count() long
```

Returns the number of samples in the window, excluding samples with `NaN` value.

### `countNaN`

```javascript
countNaN() long
```

Returns the number of `NaN` samples in the window.

### `percentile`

```csharp
percentile(double n) double
```

Calculates `n`-th percentile according to the `R6` method as described in the NIST Engineering Handbook, Section 2.6.2, which uses `N+1` as the array size (`N` is the number of samples in the period) and performs linear interpolation between consecutive values. `n` must be a fractional number within the `[0, 100]` range.

### `median`

```javascript
median() double
```

Returns 50% percentile (median). Same as `percentile(50)`.

### `variance`

```javascript
variance() double
```

Calculates variance.

#### `stdev`

```javascript
stdev() double
```

Alias: `std_dev`.

Returns standard deviation calculated as an unbiased estimator of variance for the `n - 1` sample.

![](../api/data/series/images/st_dev_sample.svg)

### `intercept`

```javascript
intercept() double
```

Calculates linear regression intercept.

### `median_abs_dev`

```javascript
median_abs_dev() double
```

Returns median absolute deviation, a [`robust`](http://www.stats.ox.ac.uk/~ripley/StatMethods/Robust.pdf) (resistant to outliers) estimate of the variance calculated according to the following formula:

```csharp
median(abs(value - median(value)))
```

Examples:

```javascript
median_abs_dev('5 minute')
median_abs_dev(10)
```

### `first`

```javascript
first() double
```

Returns first series value. Same as `first(0)`.

### `first(int index)`

```csharp
first(int index) double
```

Returns `n`-th value from start. First value has index of `0`.

### `last`

```javascript
last() double
```

Returns last value. Same as `last(0)`.

### `last(int index)`

```csharp
last(int index) double
```

Returns `n`-th value from last value. Last value has index of `0`.

### `diff`

```javascript
diff() double
```

Calculates difference between `last` and `first` values. Same as `last() - first()`.

### `diff(int i)`

```csharp
diff(int i) double
```

Calculates difference between `last(integer i)` and `first(integer i)` values. Same as `last(integer i)-first(integer i)`.

### `diff(string interval)`

```csharp
diff(string interval) double
```

Calculates difference between the last value and value at `currentTime - interval`.

`interval` specified as `count unit`, for example `5 minute`.

### `delta`

```javascript
delta() double
```

Calculates difference between `last` and `first` values. Same as `diff()`.

### `new_maximum`

```javascript
new_maximum() bool
```

Returns `true` if last value is greater than any previous value.

### `new_minimum`

```javascript
new_minimum() bool
```

Returns `true` if last value is smaller than any previous value.

### `threshold_time`

```csharp
threshold_time(double t) double
```

Forecasts the number of minutes until the sample value reaches the specified threshold `t` based on extrapolation of the difference between the last and first value.

### `threshold_linear_time`

```csharp
threshold_linear_time(double threshold) double
```

Forecasts the number of minutes until the sample value reaches the specified `threshold` based on linear extrapolation.

### `rate_per_second`

```javascript
rate_per_second() double
```

Calculates the difference between last and first value per second. Same as `diff()/(time_last()-time_first())`. Time measured in Unix seconds.

### `rate_per_minute`

```javascript
rate_per_minute() double
```

Calculates the difference between last and first value per minute. Same as `rate_per_second()*60`.

### `rate_per_hour`

```javascript
rate_per_hour() double
```

Calculates the hourly difference between last and first value input. Same as `rate_per_second()*3600`.

### `slope`

```javascript
slope() double
```

Calculates linear regression slope.

### `slope_per_second`

```javascript
slope_per_second() double
```

Calculates linear regression slope.

### `slope_per_minute`

```javascript
slope_per_minute() double
```

Calculates `slope_per_second()/60`.

### `slope_per_hour`

```javascript
slope_per_hour() double
```

Calculates `slope_per_second()/3600`.

### `countIf`

```csharp
countIf(string condition [, string interval | int n]) long
```

Counts elements matching the specified `condition` within `interval` or within the last `n` samples.

Examples:

```javascript
/* For values [0, 15, 5, 40] the function returns 2. */
countIf('value > 10')
```

```javascript
/* Count of values exceeding 5 within the last 10 samples. */
countIf('value > 5', 10)
```

### `avgIf`

```csharp
avgIf(string condition [, string interval | int n]) double
```

Calculates average of elements matching the specified `condition` within `interval` or within the last `n` samples.

### `sumIf`

```csharp
sumIf(string condition [, string interval | int n]) double
```

Sums elements matching the specified `condition` within `interval` or within the last `n` samples.

## Interval Selection

By default, statistical functions calculate results based on all samples stored in a window. The range of samples can be adjusted by passing an optional argument - specified as sample count `n` or `interval` - in which case the function calculates the result based on the most recent samples.

```csharp
avg([string interval | int n]) double
```

* `avg(5)`: Average value for the last 5 samples.
* `avg('1 HOUR')`: Average value for the last 1 hour.
* `max('2 minute')`: Maximum value for the last 2 minutes.
* `percentile(95, '1 hour')`: 95% percentile for the last hour.
* `countIf('value > 5', 10)`: Count of values exceeding 5 within the last 10 samples.

Example:

The condition evaluates to `true` if the 1-minute average is greater than the 1-hour average by more than `20` and a maximum is reached in the last 5 samples.

```javascript
avg('1 minute') - avg() > 20 && max(5) = max()
```
