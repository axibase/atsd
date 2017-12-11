# Functions

## Overview

Function calls in expressions and placeholders are replaced during evaluation by the value of the function.

Functions can accept arguments of the following data types:

* `D` - double
* `L` - long
* `I` - integer
* `B` - boolean
* `S` - string
* `[S]` - array of strings

For example, the `percentile(D)` function accepts one argument of the `double` type, such as `percentile(50.0)`.

String literal arguments (`S`) must be enclosed in single quotes, for instance `diff('1 minute')`.

Function names are case-**sensitive**.

## Statistical Functions

Univariate statistical functions listed below perform a calculation on the array of numeric values stored in the window. For example, the `avg()` function for a `5-minute` time-based window returns an average value for all samples received within this period of time.

| **Name** | **Description** |
| :--- | :--- |
| `avg()` | Average value. |
| `mean()` | Average value. Same as `avg()`. |
| `sum()` | Sum of values. |
| `min()` | Minimum value. |
| `max()` | Maximum value. |
| `wavg()` | Weighted average. Weight = sample index which starts from 0 for the first sample. |
| `wtavg()` | Weighted time average.<br>`Weight = (sample.time - first.time)/(last.time - first.time + 1)`. <br>Time measured in epoch seconds. |
| `count()` | Count of values. |
| `percentile(D)` | N-th percentile. D can be a fractional number. |
| `median()` | 50% percentile. Same as `percentile(50)`. |
| `variance()` | Standard deviation. |
| `stdev()` | Standard deviation. Aliases: `variance`, `stdev`, `std_dev`. |
| `slope()` | Linear regression slope. |
| `intercept()` | Linear regression intercept. |
| `first()` | First value. Same as `first(0)`. |
| `first(I)` | I-th value from start. First value has index of 0. |
| `last()` | Last value. Same as `last(0)`. |
| `last(I)` | I-th value from end. Last value has index of 0. |
| `diff()` | Difference between `last` and `first` values. Same as `last() - first()`. |
| `diff(I)` | Difference between `last(I)` and `first(I)` values. Same as` last(I)-first(I)`. |
| `diff(S)` | Difference between the last value and value at 'currentTime - interval'. <br>Interval specified as 'count unit', for example '5 minute'. |
| `delta()` | Same as `diff()`. |
| `new_maximum()` | Returns true if last value is greater than any previous value. |
| `new_minimum()` | Returns true if last value is smaller than any previous value. |
| `threshold_time(D)` | Number of minutes until the sample value reaches specified threshold `D` based on extrapolation of the difference between the last and first value. |
| `threshold_linear_time(D)` | Number of minutes until the sample value reaches the specified threshold `D` based on linear extrapolation. |
| `rate_per_second()` | Difference between last and first value per second. <br>Same as `diff()/(last.time-first.time)`. Time measured in epoch seconds. |
| `rate_per_minute()` | Difference between last and first value per minute. Same as `rate_per_second()/60`. |
| `rate_per_hour()` | Difference between last and first value per hour. Same as `rate_per_second()/3600`. |
| `slope_per_second()` | Same as` slope()`. |
| `slope_per_minute()` | `slope_per_second()/60`. |
| `slope_per_hour()` | `slope_per_second()/3600`. |

### Conditional Functions

| **Name** | **Description** |
| :--- | :--- |
| <code> countIf(S condition [, S interval &#124; I count])</code> | Count of elements matching the specified condition. |
| <code> avgIf(S condition [, S interval &#124; I count])</code> | Average of elements matching the specified condition. |
| <code> sumIf(S condition [, S interval &#124; I count])</code> | Sum of elements matching the specified condition. |

The condition is a boolean expression that can refer to `value` field and compare it as a number.

Example: `countIf('value > 10')`for values `[0, 15, 5, 40]` will return `2`.

### Interval Selection

By default, the statistical functions calculate the result based on all samples stored in the window. The range of samples can be adjusted by passing an optional argument - specified as sample count (`I`) or interval (`S`) - in which case the function will calculate the result based on the most recent samples.

```javascript
avg([S interval | I count])
```

* `avg(5)` - Average value for the last 5 samples.
* `avg('1 HOUR)` - Average value for the last 1 hour.
* `max('2 minute')` - Maximum value for the last 2 minutes.
* `percentile(95, '1 hour')` - 95% percentile for the last hour.
* `countIf('value > 0', 10)` - Count of values exceeding 5 within the last 10 samples.

Example:

The condition evaluates to `true` if the 1-minute average is greater than the 1-hour average by more than `20` and a maximum was reached in the last 5 samples.

```javascript
  avg('1 minute') - avg() > 20 && max(5) = max()
```

## Statistical Forecast Functions

| **Name** | **Description** |
| :--- | :--- |
| `forecast()` | Forecast value for the entity, metric, and tags in the current window. |
| `forecast_stdev()` | Forecast standard deviation. |
| `forecast(S)` | Named forecast value for the entity, metric, and tags in the current window, for example `forecast('ltm')` |
| `forecast_deviation(D)` | Difference between a number (such as last value) and forecast, divided by forecast standard deviation.<br>Formula: `(number - forecast())/forecast_stdev()`.|

## Database Functions

| **Name** | **Description** |
| :--- | :--- |
| `db_last()` | Retrieves the last value stored in the database for the specified series. |
| `db_statistic()` | Retrieves an aggregated value from the database for the specified series. |

The database functions provide a way to retrieve values for a series which may be different from the series in the current window. The functions can be used to compare data between different series for correlation purposes.

Refer to the database function [syntax and examples](functions-db.md).

## Mathematical Functions

| **Name** | **Description** |
|:---|:---|
| `abs(D)` | Returns the absolute value of the specified number. |
| `ceil(D)` | Returns the smallest integer that is greater than or equal to the specified number. |
| `floor(D)` | Returns the largest integer that is less than or equal to the specified number. |
| `pow(D, D)`  | Number raised to the specified power (2nd argument). |
| `round(D[,I])` | Returns the number rounded to the specified decimal places. <br>The precision argument `I` is 0 if omitted.<br>`round(D, 0)` rounds the number to the nearest integer.<br>If `I` is less than 0, the number is rounded to the left of the decimal point.|
| `random()` | Returns a uniformly distributed double number, greater than or equal to `0.0` and less than `1.0`.|
| `randomNormal()` | Returns a normally distributed double number, with mean `0.0` and standard deviation `1.0`.|
| `max(D, D)` | Returns the greater of two double values.|
| `min(D, D)` | Returns the smallest of two double values.|
| `sqrt(D)` | Returns the square root of the specified number.|
| `exp(D)` | `e` (2.71828183) raised to the power of the specified number. |
| `log(D)`  | Base-`e` natural logarithm of the specified number. |

## String Functions

| **Name** | **Description** |
| :--- | :--- |
| `upper(S)` | Convert string to upper case. |
| `lower(S)` | Convert string to lower case. |
| `t.contains(S)` | Check if field 't' contains the specified string. |
| `t.startsWidth(S)` | Check if field 't' starts with the specified string. |
| `t.endsWidth(S)` | Check if field 't' ends with the specified string. |
| `coalesce([S])` | Return first non-empty string from the array of strings. See [examples](functions-coalesce.md).|
| `urlencode(S)` | Encode string into the URL format where unsafe characters are replaced with "%" followed by 2 digits. |
| `jsonencode(S)` | Escape special symbols with backslash to safely use the provided string within JSON object. |

## Formatting Functions

| **Name** | **Description** |
| :--- | :--- |
| `convert(D, S)` | Convert value to given unit, where unit is one of 'k', 'Ki', 'M', 'Mi', 'G', 'Gi'. <br>Example: `convert(20480, 'Ki')` returns to `20.0` |
| `formatNumber(D, S)` | Format given number by applying specified DecimalFormat pattern.<br>Example: `formatNumber(3.14159, '#.##')` returns to `'3.14'`

## Collection Functions

| **Name** | **Description** |
| :--- | :--- |
|`collection(S)` | Return a list of items for a named collection listed on **Data > Named Collections** page.<br>Example: `collection('ip_white_list')`|
| `likeAny(S, List)` | Returns true if the text is contained in the named collection. The collection may include expressions with wildcards.<br>Example: `likeAny(tags.request_ip, collection('ip_white_list'))`|
| `matchList(S, S)` | Same as `likeAny` except the second argument specifies collection by name.<br>Example: `matchList(tags.request_ip, 'ip_white_list')`|
| `IN` | Returns true if collection contains the specified string. <br>`tags.location IN ('NUR', 'SVL')`|
| `contains(S)` | Returns true if collection contains the specified string. <br>`properties['command'].toString().contains('java')`|
| `isEmpty()` | Returns true if collection has no elements. <br>`entity.tags.isEmpty()`|
| `size()` | Returns number of elements in the collection. <br>`entity.tags.size() > 1`|
| `matches(S pattern, [S])` | Returns true if one of the collection elements matches the specified pattern. <br>`matches('*atsd*', property_values('docker.container::image'))`|
| `lookup(S replacementTable, S key)` | Returns value for the specified key in the given replacement table.|

## Time Functions

| **Name** | **Description** |
| :--- | :--- |
| `window_length_time()` | Length of the time-based window in seconds, as configured. |
| `window_length_count()` | Length of the count-based window, as configured. |
| `windowStartTime()` | Time when the first command was received by the window, in UNIX milliseconds. |
| `milliseconds(S datetime [,S format [,S timezone]])` | Convert the datetime string into UNIX time in milliseconds according to the specified format string and timezone (or offset from UTC). Available timezones and their standard offsets are listed in [time zones](../api/network/timezone-list.md). If the timezone (or offset from UTC) is specified in the datetime string, and it differs from the timezone (offset) provided as the third argument, then the function will throw an exception. If the format is omitted, the datetime argument must be specified in ISO8601 format `yyyy-MM-ddTHH:mm:ss.SSSZ`. If the timezone is omitted, the server timezone is used. |
| `seconds(S datetime [,S format [,S timezone]])` | Same arguments as the `milliseconds` function except the result is returned in UNIX time seconds. |
| `date_parse(S datetime [,S format [,S timezone]])` | Same arguments as the `milliseconds` function except the result is returned as [Joda-time](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) DateTime object. |
| `date_format(L timestamp, S pattern, S timezone)` | Convert timestamp to a formatted time string according to the format pattern and the timezone. Timestamp is an epoch timestamp in milliseconds. The format string syntax is described in the [datetime format](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html). List of available [time zones](../api/network/timezone-list.md). |
| `formatInterval(L interval)` | Convert millisecond interval to a formatted interval printing non-zero years, days, hours, minutes, and seconds. |
| `formatIntervalShort(L interval)` | Convert millisecond interval to a formatted interval printing one or two greatest subsequent non-zero period type, where period type is one of: years, days, hours, minutes, and seconds. |
| `elapsedTime(L timestamp)` | Calculate number of milliseconds since `timestamp` to current instant |

Refer to the time functions [examples](functions-time.md).

## Property Functions

| **Name** | **Description** |
| :--- | :--- |
| `property_values(S search)` | Returns a list of property tag values for the current entity given the property [search string](../property-search-syntax.md). |
| `property_values(S entity, S search)` |  Same as `property_values`(string search) but for an explicitly specified entity.  |
| `property(S search)` |  Returns the first value in a collection of strings returned by the `property_values()` function. The function returns an empty string if no property records are found.  |
| `property_compare_except([S key])` | Compares previous and current property tags and returns a difference map containing the list of changed tag values.   |
| `property_compare_except([S key], [S prevValue])` |   Same as `property_compare_except([S key])`, which shows the list of previous values that are excluded from the difference map. |

## Entity Tag Functions

| **Name** | **Description** |
| :--- | :--- |
| `entity_tags(S entity)` | Returns entity tags' keys and values map for provided entity. |
| `entity_tag(S entity, S tagName)` | Returns tag value for provided tag name and entity. |
