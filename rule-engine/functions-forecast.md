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

Forecast value for the entity, metric, and tags in the current window.

## `forecast(string n)`

```javascript
  forecast(string n) double
```

Named forecast value for the entity, metric, and tags in the current window, for example `forecast('ltm')` .

## `forecast_stdev`

```javascript
  forecast_stdev() double
```

Forecast standard deviation.

## `forecast_deviation`

```javascript
  forecast_deviation(double n) double
```

Difference between a number `n` (such as the last value) and the forecast value (returned by `forecast()` function), divided by the forecast standard deviation.

The formula is:

```javascript
  (n - forecast())/forecast_stdev()
```

## `thresholdTime`

```javascript
  thresholdTime(number minThreshold, number maxThreshold, string interval) long
```

Time when the forecast value exceeds either minimum or maximum threshold for a given time interval, or `null` if all available forecast values are inside threshold boundaries.
`minThreshold` and `maxThreshold` must be set to `null` if not used.
`interval` must contain interval count and unit, for example `1 WEEK`.