# Statistical Forecast Functions

## Overview

## Reference

* [`forecast`](#forecast)
* [`forecast_stdev`](#forecast_stdev)
* [`forecast_deviation`](#forecast_deviation)
* [`thresholdTime`](#thresholdtime)

## `forecast()`

```javascript
  forecast() double
```

Returns forecast value for the entity, metric, and tags in the current window.

## `forecast(string n)`

```javascript
  forecast(string n) double
```

Returns named forecast value for the entity, metric, and tags in the current window, for example `forecast('ltm')` .

## `forecast_stdev`

```javascript
  forecast_stdev() double
```

Returns forecast standard deviation.

## `forecast_deviation`

```javascript
  forecast_deviation(double n) double
```

Returns difference between a number `n` (such as the last value) and the forecast value (returned by `forecast()` function), divided by the forecast standard deviation.

The formula is:

```javascript
  (n - forecast())/forecast_stdev()
```

## `thresholdTime`

```javascript
  thresholdTime(number min, number max, string i) long
```

Returns time in Unix milliseconds when the [forecast value](../../forecasting/README.md) is outside of the threshold range for the first time during time interval `i`. The forecast exceeds the threshold when the value is below `min` or the value is above `max`. Thresholds `min` and `max` must be set to `null` if inactive.

The function returns `null` if forecast values are within the specified threshold boundaries during time interval `i` or if no forecast is found in the database.

The interval `i` is specified as count and [unit](../../api/data/series/time-unit.md), for example `1 WEEK`.
