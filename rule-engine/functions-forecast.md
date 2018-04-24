# Statistical Forecast Functions

## Overview

## Reference

* [`forecast`](#forecast)
* [`forecast_stdev`](#forecast_stdev)
* [`forecast_deviation`](#forecast_deviation)

### `forecast()`

```javascript
  forecast() double
```

Forecast value for the entity, metric, and tags in the current window.

### `forecast(string n)`

```javascript
  forecast(string n) double
```

Named forecast value for the entity, metric, and tags in the current window, for example `forecast('ltm')` .

### `forecast_stdev`

```javascript
  forecast_stdev() double
```

Forecast standard deviation.

### `forecast_deviation`

```javascript
  forecast_deviation(double n) double
```

Difference between a number `n` (such as the last value) and the forecast value (returned by `forecast()` function), divided by the forecast standard deviation.

The formula is:

```javascript
  (n - forecast())/forecast_stdev()
```
