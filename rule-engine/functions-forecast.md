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
thresholdTime(number min, number max [, string i]) long
```

Returns time in Unix milliseconds when the [stored forecast value](../forecasting/README.md) is outside of the `(min, max)` range for the first time during time interval `i`.

The interval `i` is specified as count and [unit](../api/data/series/time-unit.md), for example `1 WEEK`. If the time interval `i` is not specified, the function checks all available forecast values in the future.

Thresholds `min` and `max` are ignored if set to `null`. If both `min` and `max` are specified, the following rules apply:

* If threshold `max` is equal or greater than `min`, the function returns time when the forecast value is **outside** of the specified range.
* If threshold `min` exceeds `max`, the function returns time when the forecast value is **within** the specified range.

The function returns `null` if no stored forecast is found in the database.

### Example

```javascript
/*
  Returns time, within the next 6 hours, when the forecast exceeds 90.
  Returns `null`, if all forecast values are below 90 or the violation occurs after the `6 HOUR` window.
*/
thresholdTime(null, 90, '6 HOUR')
```

### Example Table

Current time is `2018-Jul-07 15:00`, or `1530975600000` in Unix milliseconds.

Forecast Values:

| **Value** | **Date** | **Time**  | **Note** |
|---:|---|---|---|
| `70` | `2018-Jul-08 15:00` | `1530975600000` | 1 day from `now` |
| `80` | `2018-Jul-09 15:00` | `1531148400000` | 2 days from `now` |
| `90` | `2018-Jul-10 15:00` | `1531234800000` | 3 days from `now` |
| `100` | `2018-Jul-16 15:00` | `1531753200000` | 9 days from `now` |

```javascript
/*
  Returns 1531753200000 (2018-Jul-16 15:00)
  First time when the forecast 100 exceeds 'max' threshold 95
*/
thresholdTime(null, 95)
```

```javascript
/*
  Returns null. No forecast value exceeds 120.
*/
thresholdTime(null, 120)
```

```javascript
/*
  Returns null. No forecast value exceeds 95 within the next 7 days, by 2018-Jul-14 15:00.
*/
thresholdTime(null, 95, '7 DAY')
```

```javascript
/*
  Returns 1531234800000 (2018-Jul-10 15:00).
  First time when the forecast 90 exceeds 'max' threshold 80.
  Forecast 80 on 2018-Jul-09 15:00 was ignored as not exceeding the threshold.
*/
thresholdTime(null, 80, '7 DAY')
```

```javascript
/*
  Returns 1530975600000 (2018-Jul-08 15:00).
  First time when the forecast 70 is below 'min' threshold 80.
*/
thresholdTime(80, null, '7 DAY')
```

```javascript
/*
  Returns 1531753200000 (2018-Jul-16 15:00)
  Outside range check: case when 'max' threshold is greater than 'min' threshold.
  First time when the forecast 100 is either below 70 OR above 90.
*/
thresholdTime(70, 90)
```

```javascript
/*
  Returns 1531148400000 (2018-Jul-09 15:00)
  Within range check: case when 'min' threshold is greater than 'max' threshold.
  First time when the forecast 80 is BOTH above 'max' threshold 70 AND below 'min' threshold 90.
*/
thresholdTime(90, 70)
```

```javascript
/*
  Returns 1531148400000 (2018-Jul-09 15:00)
  Case when 'min' threshold equals 'max' threshold.
  First time when the forecast 80 is either below 70 (false) OR above 70 (true).
*/
thresholdTime(70, 70)
```
