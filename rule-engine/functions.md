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

## Value Functions

The [value](functions-value.md) functions provide a way to retrieve values for other metrics contained in the same command.

| **Name** | **Description** |
| :--- | :--- |
| [`value(S)`](functions-value.md) | Retrieve the value for the specified metric received in the same series command or parsed from the same row in the CSV file. |

## Database Functions

The [database](functions-db.md) functions provide a way to retrieve data from the database for complex comparisons and correlation.

### Database Series Functions

The functions retrieve values for a series which may be different from the series in the current window.

| **Name** | **Description** |
| :--- | :--- |
| [`db_last`](functions-db.md#db_last-function) | Retrieves the last value stored in the database for the specified series. |
| [`db_statistic`](functions-db.md#db_last-function) | Retrieves an aggregated value from the database for the specified series. |

### Database Message Functions

The functions retrieve message counts or specific messages.

| **Name** | **Description** |
| :--- | :--- |
| [`db_message_count`](functions-db.md#db_message_count-function) | Retrieves message count for the specified filters. |
| [`db_message_last`](functions-db.md#db_message_last-function) | Retrieves the last message for the specified filters. |

## Mathematical Functions

The math functions perform basic numeric operations on the input number and return a number as the result.

* [abs](functions-math.md#abs)
* [ceil](functions-math.md#ceil)
* [floor](functions-math.md#floor)
* [pow](functions-math.md#pow)
* [round](functions-math.md#round)
* [max](functions-math.md#max)
* [min](functions-math.md#min)
* [sqrt](functions-math.md#sqrt)
* [exp](functions-math.md#exp)
* [log](functions-math.md#log)

## Text Functions

The text functions transform and compare strings.

* [upper](functions-text.md#upper)
* [lower](functions-text.md#lower)
* [truncate](functions-text.md#truncate)
* [contains](functions-text.md#contains)
* [startsWith](functions-text.md#startswith)
* [endsWith](functions-text.md#endswith)
* [coalesce](functions-text.md#coalesce)
* [urlencode](functions-text.md#urlencode)
* [jsonencode](functions-text.md#jsonencode)

## Formatting Functions

The functions format numbers to strings according to the specified pattern.

* [convert](functions-formatting.md#convert)
* [formatNumber](functions-formatting.md#formatnumber)

## Collection Functions

The collection functions return information about the collection or check it for the presence of the specified element.

* [collection](functions-collection.md#collection)
* [IN](functions-collection.md#in)
* [likeAny](functions-collection.md#likeany)
* [matchList](functions-collection.md#matchlist)
* [matches](functions-collection.md#matches)
* [excludeKeys](functions-collection.md#excludekeys)

## Lookup Functions

The lookup functions retrieve records from replacement tables, collections, and other entities.

* [entity_tag](functions-lookup.md#entity_tag)
* [entity_tags](functions-lookup.md#entity_tags)
* [collection](functions-lookup.md#collection)
* [lookup](functions-lookup.md#lookup)
* [replacementTable](functions-lookup.md#replacementtable)

## Random Distribution Functions

* [random](functions-random.md#random) 
* [randomNormal](functions-random.md#randomnormal) 
* [randomItem](functions-random.md#randomitem) 
* [randomKey](functions-random.md#randomkey) 

## Time Functions

Time functions perform varios operations on dates, timestamps and intervals.

* [window_length_time](functions-time.md#window_length_time)
* [window_length_count](functions-time.md#window_length_count)
* [windowStartTime](functions-time.md#windowstarttime)
* [milliseconds](functions-time.md#milliseconds)
* [seconds](functions-time.md#seconds)
* [date_parse](functions-time.md#date_parse)
* [date_format](functions-time.md#date_format)
* [formatInterval](functions-time.md#formatinterval)
* [formatIntervalShort](functions-time.md#formatintervalshort)
* [elapsedTime](functions-time.md#elapsedtime)

## Property Functions

Property functions retrieve and compare property keys and tags.

* [property_values](functions-property.md#property_valuesstring-s)
* [property](functions-property.md#property)
* [property_compare_except](functions-property.md#property_compare_exceptstring-k)

## Script Functions

| **Name** | **Description** |
| :--- | :--- |
| [`scriptOut(S, Collection args)`](functions-script.md) | Execute script in the `./atsd/conf/script` directory with the specified arguments and return its standard out or error.<br>Example: `${scriptOut('ping.sh', ['2', 'example.org'])}` |
