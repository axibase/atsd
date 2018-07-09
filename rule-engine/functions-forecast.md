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

Returns time in Unix milliseconds when the [forecast value](../forecasting/README.md) is outside of the threshold range for the first time during time interval `i`. The forecast exceeds the threshold when the value is below `min` or the value is above `max`. Thresholds `min` and `max` must be set to `null` if inactive.

The function returns `null` if forecast values are within the specified threshold boundaries during time interval `i` or if no forecast is found in the database.

The interval `i` is specified as count and [unit](../api/data/series/time-unit.md), for example `1 WEEK`.

### Examples

Current Time: `2018-07-07 15:00:00` (`1530975600000`)

| **Date** | **Time**  | **Value** |
|---|---|---|
| `2018-07-08 15:00:00` | `1530975600000` | `81` |
| `2018-07-10 15:00:00` | `1531148400000` | `79` |
| `2018-07-12 15:00:00` | `1531321200000` | `90` |
| `2018-07-14 15:00:00` | `1531494000000` | `91` |
| `2018-07-16 15:00:00` | `1531666800000` | `95` |

```javascript
  thresholdTime(null, null, '7 DAY') // returns null: both boundaries are not set
  thresholdTime(null, 90, '7 DAY') // returns 1531494000000: strict inequality relation is used, value > 90
  thresholdTime(null, 93, '7 DAY') // returns null: no value greater than 93 found inside 7 day interval
  thresholdTime(70, null, '7 DAY') // returns null: no value less than 70 found
  thresholdTime(80, null, '7 DAY') // returns 1531148400000: value(79) < 80 on 2018-07-10 15:00:00
  thresholdTime(80, 80, '7 DAY') // returns 1530975600000: value(81) is not equal to 80
  thresholdTime(70, 90, '7 DAY') // returns 1531494000000: value(91) is greater than 90 (upper bound)
```