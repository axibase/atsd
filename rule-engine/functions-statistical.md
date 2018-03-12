# Statistical Functions

## Overview

The univariate statistical functions listed below perform calculations on an array of numeric values stored in a window.

> The functions cannot be invoked in [filter](filters.md#filter-expression) expressions.

## Reference

* [avg](#avg)
* [mean](#mean)
* [sum](#sum)
* [min](#min)
* [max](#max)
* [wavg](#wavg)
* [wtavg](#wtavg)
* [count](#count)
* [percentile](#percentile)
* [median](#median)
* [variance](#variance)
* [stdev](#stdev)
* [intercept](#intercept)
* [first](#first)
* [last](#last)
* [diff](#diff)
* [delta](#delta)
* [new_maximum](#new_maximum)
* [new_minimum](#new_minimum)
* [threshold_time](#threshold_time)
* [threshold_linear_time](#threshold_linear_time)
* [rate_per_second](#rate_per_second)
* [rate_per_minute](#rate_per_minute)
* [rate_per_hour](#rate_per_hour)
* [slope](#slope)
* [slope_per_second](#slope_per_second)
* [slope_per_minute](#slope_per_minute)
* [slope_per_hour](#slope_per_hour)
* [countIf](#countif)
* [avgIf](#avgif)
* [sumIf](#sumif)

### `avg`

```javascript
  avg() double
```
Average value function. For example, `avg()` for a `5-minute` time-based window returns the average value for all samples received within this period of time.

### `mean`

```javascript
  mean() double
```
Average value function. Same as `avg()`. 

### `sum`

```javascript
  sum() double 
```
Sum of all included values.

### `min`

```javascript
  min() double 
```
Minimum value. 

### `max`

```javascript
  max() double 
```
Maximum value.

### `wavg`

```javascript
  wavg() double
```
Weighted average. Weight = sample index which starts from 0 for the first sample.

### `wtavg`

```javascript
  wtavg() double
```
Weighted time average. `Weight = (sample.time - first.time)/(last.time - first.time + 1)`. 

Time measured in epoch seconds.

### `count`

```javascript
  count() long
```
Value count. 

### `percentile`

```javascript
  percentile(double n) double
```
`n`-th percentile function. `n` multipled by the number of vaules is the index for the function. `n` can be a fractional number.

### `median`

```javascript
  median() double
```
50% percentile (median) function. Same as `percentile(50)`.

### `variance`

```javascript
  variance() double
```
Variance.

### `stdev`

```javascript
  stdev() double
```
Standard deviation. Aliases: `stdev`, `std_dev`.

### `intercept`

```javascript
  intercept() double
```
Linear regression intercept.

### `first`

```javascript
  first() double
```
First value. Same as `first(0)`.

### `first(integer i)`

```javascript
  first(integer i) double
```
`i`-th value from start. First value has index of 0.

### `last`

```javascript
  last() double
```
Last value. Same as `last(0)`.

### `last(integer i)`

```javascript
  last(integer i) double 
```
`i`-th value from end. Last value has index of 0.

### `diff`

```javascript
  diff() double
```
Difference between `last` and `first` values. Same as `last() - first()`.

### `diff(integer i)`

```javascript
  diff(integer i) double 
```
Difference between `last(integer i)` and `first(integer i)` values. Same as` last(integer i)-first(integer i)`.

### `diff(string i)`

```javascript
  diff(string i) double
```
Difference between the last value and value at 'currentTime - interval'. 

Interval `i` specified as 'count unit', for example '5 minute'. 

### `delta`

```javascript
  delta() double
```
Same as `diff()`.

### `new_maximum`

```javascript
  new_maximum() boolean 
```
Returns true if last value is greater than any previous value.

### `new_minimum`

```javascript
  new_minimum() boolean 
```
Returns true if last value is smaller than any previous value.

### `threshold_time`

```javascript
  threshold_time(double t) double
```
Number of minutes until the sample value reaches the specified threshold `t` based on extrapolation of the difference between the last and first value.

### `threshold_linear_time`

```javascript
  threshold_linear_time(double t) double
```
Number of minutes until the sample value reaches the specified threshold `t` based on linear extrapolation. 

### `rate_per_second`

```javascript
  rate_per_second() double
```
Difference between last and first value per second. Same as `diff()/(last.time-first.time)`. Time measured in epoch seconds.

### `rate_per_minute`

```javascript
  rate_per_minute() double
```
Difference between last and first value per minute. Same as `rate_per_second()/60`.

### `rate_per_hour`

```javascript
  rate_per_hour() double
```
Hourly difference between last and first value input. Same as `rate_per_second()/3600`. 

### `slope`

```javascript
  slope() double
```
Linear regression slope.

### `slope_per_second`

```javascript
  slope_per_second() double
```
Same as `slope()`.

### `slope_per_minute`

```javascript
  slope_per_minute() double
```
Same as `slope_per_second()/60`.

### `slope_per_hour`

```javascript
  slope_per_hour() double 
```
Same as `slope_per_second()/3600`.

## Conditional Functions

The condition is a boolean expression that can refer to `value` field and compare it as a number.

### `countIf`

```javascript
  countIf(string c [, string i | integer n]) long
```
Count of elements matching the specified condition `c` within interval `i` or within the last `n` samples.

Examples:

```javascript
  /* For values [0, 15, 5, 40] will return 2. */
  countIf('value > 10')
  
  /* Count of values exceeding 5 within the last 10 samples. */
  countIf('value > 5', 10)
```

### `avgIf`

```javascript
  avgIf(string c [, string i | integer n]) double
```
Average of elements matching the specified condition `c` within interval `i` or within the last `n` samples.

### `sumIf`

```javascript
  sumIf(string c [, string i | integer n]) double
```
Sum of elements matching the specified condition `c` within interval `i` or within the last `n` samples.

## Interval Selection

By default, statistical functions calculate results based on all samples stored in a window. The range of samples can be adjusted by passing an optional argument - specified as sample count `c` or interval `i` - in which case the function will calculate the result based on the most recent samples.

```javascript
avg([string i | integer c]) double
```

* `avg(5)` - Average value for the last 5 samples.
* `avg('1 HOUR')` - Average value for the last 1 hour.
* `max('2 minute')` - Maximum value for the last 2 minutes.
* `percentile(95, '1 hour')` - 95% percentile for the last hour.
* `countIf('value > 5', 10)` - Count of values exceeding 5 within the last 10 samples.

Example:

The condition evaluates to `true` if the 1-minute average is greater than the 1-hour average by more than `20` and a maximum was reached in the last 5 samples.

```javascript
  avg('1 minute') - avg() > 20 && max(5) = max()
```
