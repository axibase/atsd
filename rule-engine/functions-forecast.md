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

### Examples

| **Forecast Time** | **Forecast Time in Unix Milliseconds**  | **Forecast Value** |
|---|---|---|
| `now + 1 * day` | `1530975600000` | `81` |
| `now + 3 * day` | `1531148400000` | `79` |
| `now + 5 * day` | `1531321200000` | `90` |
| `now + 7 * day` | `1531494000000` | `91` |
| `now + 9 * day` | `1531666800000` | `95` |

```javascript
  thresholdTime(null, null, '7 DAY') // returns null
  thresholdTime(null, 90, '7 DAY') // returns 1531494000000
  thresholdTime(null, 93, '7 DAY') // returns null
  thresholdTime(70, null, '7 DAY') // returns null
  thresholdTime(80, null, '7 DAY') // returns 1530975600000
  thresholdTime(80, 80, '7 DAY') // returns 1530975600000
  thresholdTime(70, 90, '7 DAY') // returns 1531494000000
```