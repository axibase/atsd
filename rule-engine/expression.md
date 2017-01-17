# Expression

Expression is a condition which is evaluated each time a data sample is
received by the window. For example, the expression **`value > 50`** checks if a
received value is greater than 50.

If the expression evaluates to `TRUE`, it raises an alert, followed by
execution of triggers such as system command and email notification. Once
the expression returns `FALSE`, the alert is closed and another set of
triggers is invoked.

The expression consists of one or multiple checks combined with `OR` and
`AND` operators. Exceptions specified in the Thresholds table take
precedence over expression.

## Fields

**Field** | **Description**
:--- | :---
`value` | Last data sample.
`tags.'tag-name'` | Value of series tag 'tag-name', for example, tags.file _system.
`entity` | Entity name.
`metric` | Metric name.

## Functions

### Time Functions

**Function** | **Description**
:--- | :---
`window_length_time()` | Length of the time-based window in seconds, as configured.
`window_length_count()` | Length of the count-based window, as configured.
`windowStartTime()` | Time when the first command was received by the window, in UNIX milliseconds.
`milliseconds(string isodate)` | Converts ISO8601 date string into epoch time in milliseconds.
`seconds(string isodate)` | Converts ISO8601 date string into epoch time in seconds.
`date(string isodate)` | Converts ISO8601 date string into [Joda-time](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) date object. The object can return [numeric codes](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTimeConstants.html) or string names for calendar constants.

```java
/*
  Return true if difference between event time and start time (ISO) retrieved 
  from property record is greater than 5 minutes
*/
  timestamp - milliseconds(property('docker.container::startedAt')) >  5*60000

/*
  Return true if the specified date is a working day
*/
  property('config::deleted')).dayOfWeek().get() < 6
```



### Aggregation Functions

**Function** | **Description**
:--- | :---
`avg()` | Average value.
`mean()` | Average value. Same as `avg()`.
`sum()` | Sum of values.
`min()` | Minimum value.
`max()` | Maximum value.
`wavg()` | Weighted average. Weight = sample index which starts from 0 for first sample.
`wtavg()` | Weighted time average.<br>`Weight = (sample.time - first.time)/(last.time - first.time + 1)`. <br>Time measured in epoch seconds.
`count()` | Count of values.
`percentile(D)` | Dth percentile. D can be a fractional number.
`median()` | 50% percentile. Same as `percentile(50)`.
`variance()` | Standard deviation.
`stdev()` | Standard deviation. Aliases: `variance`, `stdev`, `std_dev`.
`slope()` | Linear regression slope.
`intercept()` | Linear regression intercept.
`first()` | First value. Same as `first(0)`.
`first(integer N)` | Nth value from start. First value has index of 0.
`last()` | Last value. Same as `last(0)`.
`last(integer N)` | Nth value from end. Last value has index of 0.
`diff()` | Difference between `last` and `first` values. Same as `last() - first()`.
`diff(N)` | Difference between `last(N)` and `first(N)` values. Same as` last(N)-first(N)`.
`diff(string interval)` | Difference between `last value` and `value` at `currentTime - interval`. <br>Interval specified as '`count unit`', i.e. '`5 minute`'.
`new_maximum()` | Returns true if last value is greater than any previous value.
`new_minimum()` | Returns true if last value is smaller than any previous value.
`threshold_time(double D)` | Number of minutes until the sample value reaches specified threshold D<br> based on extrapolation of difference between last and first value.
`threshold_linear_time(double D)` | Number of minutes until the sample value reaches specified threshold D<br> based on linear extrapolation.
`rate_per_second()` | Difference between last and first value per second. <br>Same as `diff()/(last.time-first.time)`. Time measured in epoch seconds.
`rate_per_minute()` | Difference between last and first value per minute. Same as `rate_per_second()/60`.
`rate_per_hour()` | Difference between last and first value per hour. Same as `rate_per_second()/3600`.
`slope_per_second()` | Same as` slope()`.
`slope_per_minute()` | `slope_per_second()/60`.
`slope_per_hour()` | `slope_per_second()/3600`.

### Forecast functions

**Function** | **Description**
:--- | :---
`forecast()` | Forecast value for the entity, metric, and tags in the current window.
`forecast_stdev()` | Forecast standard deviation.
`forecast(string name)` | Named forecast value for the entity, metric, and tags in the current window.
`forecast_deviation()` | `(D-forecast())/forecast_stdev()`.

### Math functions

* `abs(D)`
* `ceil(D)`
* `floor(В)`
* `pow(D, D)`
* `round(D)`
* `round(D, N)`
* `random()`
* `max(double a, double b)`
* `min(D, D)`
* `sqrt(D)`
* `exp(D)`
* `log(D)`

### String Functions

**Function** | **Description**
:--- | :---
`upper(string t)` | Convert string 't' to upper case.
`lower(string t)` | Convert string 't' to lower case.

## Numeric Operators

**Operator** | **Description**
:--- | :---
`=` | Equal.
`!=` | Not equal.
`>` | Greater than.
`>=` | Greater than or equal.
`<` | Less than.
`<=` | Less than or equal.

## Text Operators

**Operator** | **Description**
:--- | :---
`=` | Equal.
`!=` | Not equal.
`t.contains(string t)` | Check if text 't' contains text 'str'.
`t.startsWidth(string t)` | Check if text 't' starts with text 'str'.
`t.endsWidth(string t)` | Check if text 't' ends with text 'str'.

> Note: `=` and `!=` operators are case-insensitive.
