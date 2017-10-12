# Functions

> For the purpose of this reference, arguments have the following data types: `D` - double, `L` - long, `I` - integer, `B` - boolean, `S` - string, `[S]` - array of strings. 

> String literal arguments `S` must be enclosed in single quotes, for instance `diff('1 minute')`.

> Function names are **case-sensitive**.

## Statistical Functions

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
| `percentile(D)` | D-th percentile. D can be a fractional number. |
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

## Statistical Forecast Functions

| **Name** | **Description** |
| :--- | :--- |
| `forecast()` | Forecast value for the entity, metric, and tags in the current window. |
| `forecast_stdev()` | Forecast standard deviation. |
| `forecast(S)` | Named forecast value for the entity, metric, and tags in the current window, for example `forecast('ltm')` |
| `forecast_deviation(D)` | Difference between a number (such as last value) and forecast, divided by forecast standard deviation.<br>Formula: `(number - forecast())/forecast_stdev()`.|

## Data Query Functions

| **Type** | **Example** | **Description** |
| --- | --- | --- |
| atsd_last | `atsd_last(metric: 'transq')` | Query historical database for last value. |
| atsd_values | `avg(atsd_values(entity: 'e1', metric: 'm1', type: 'avg', interval: '5-minute', shift: '1-day', duration: '3-hour'))` | Query historical database for a range of values. Apply analytical functions to the result set. |

## Math Functions

* `abs(D)`
* `ceil(D)`
* `floor(D)`
* `pow(D, D)`
* `round(D)`
* `round(D, I)`
* `random()`
* `max(D, D)`
* `min(D, D)`
* `sqrt(D)`
* `exp(D)`
* `log(D)`
* `convert(D, S)` Convert value to given unit, where unit is one of 'k', 'Ki', 'M', 'Mi', 'G', 'Gi'. For example, `convert(20480, 'Ki')` evaluates to `20.0`
* `formatNumber(D, S)` Format given number by applying specified DecimalFormat pattern, e.g. `formatNumber(3.14159, '#.##')` evaluates to `'3.14'`

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

## Collection Functions

| **Name** | **Description** |
| :--- | :--- |
| `IN` | Returns true if collection contains the specified string. <br>`tags.location IN ('NUR', 'SVL')`|
| `contains(S)` | Returns true if collection contains the specified string. <br>`properties['command'].toString().contains('java')`|
| `isEmpty()` | Returns true if collection has no elements. <br>`entity.tags.isEmpty()`|
| `size()` | Returns number of elements in the collection. <br>`entity.tags.size() > 1`|
| `matches(S pattern, [S])` | Returns true if one of the collection elements matches the specified pattern. <br>`matches('*atsd*', property_values('docker.container::image'))`|
| `lookup(S replacementTable, S key)` | Returns value by specified key in the given replacement table.|

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