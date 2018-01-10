# Time Functions

## Overview

The time functions perform various operations on dates, timestamps, and intervals.

## Reference

* [window_length_time](#window_length_time)
* [window_length_count](#window_length_count)
* [windowStartTime](#windowstarttime)
* [milliseconds](#milliseconds)
* [seconds](#seconds)
* [elapsedTime](#elapsedtime)
* [date_parse](#date_parse)
* [date_format](#date_format)
* [formatInterval](#formatinterval)
* [formatIntervalShort](#formatintervalshort)


### `window_length_time`

```javascript
  window_length_time() long
```

Length of the time-based window in seconds, as configured.

### `window_length_count`

```javascript
  window_length_count() long
```

Length of the count-based window, as configured.

### `windowStartTime`

```javascript
  windowStartTime() long
```

Time when the first command was received by the window, in UNIX milliseconds. 

### `milliseconds`

```javascript
  milliseconds(string datetime [,string format [,string timezone]]) long
```

Converts the `datetime` string into UNIX time in milliseconds according to the specified `format` string and `timezone` (or offset from UTC). 

Available timezones and their standard offsets are listed in [time zones](../shared/timezone-list.md). If the timezone (or offset from UTC) is specified in the datetime string, and it differs from the timezone (offset) provided as the third argument, then the function will throw an exception. 

If the format is omitted, the datetime argument must be specified in ISO8601 format `yyyy-MM-ddTHH:mm:ss.SSSZ`. If the timezone is omitted, the server timezone is used.

Example:

```javascript
  /* Returns true if the difference between the event time and start
  time (ISO) retrieved from the property record is greater than 5 minutes. */
  timestamp - milliseconds(property('docker.container::startedAt')) >  5*60000
```

### `seconds`

```javascript
  seconds(string datetime [,string format [,string timezone]]) long
```

Same arguments as the `milliseconds` function except the result is returned in UNIX seconds. 


### `elapsedTime`

```javascript
  elapsedTime(long timestamp) long
```

Calculates the number of milliseconds between the current time and the specified time. The function accepts time in UNIX milliseconds or in one of the following formats:

```
yyyy-MM-dd[(T| )[hh:mm:ss[.SSS[Z]]]]
```
Example:

```javascript
  /* Assuming current time of 2017-08-15T00:01:30Z, return elapsed time: 90000 */
  elapsedTime("2017-08-15T00:00:00Z")
```

### `date_parse`

```javascript
  date_parse(string datetime [,string format [,string timezone]]) DateTime object
```

Converts the provided datetime string into a [Joda-time](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) DateTime object according to the specified format string and timezone (or offset from UTC).

Available timezones and their standard offsets are listed in [time zones](http://joda-time.sourceforge.net/timezones.html). If the timezone (or offset from UTC) is specified in the datetime string, and it differs from the timezone (offset) provided as the third argument, then the function will throw an exception.

If the format is omitted, the datetime argument must be specified in ISO8601 format `yyyy-MM-ddTHH:mm:ss.SSSZ`. If the timezone is omitted, the server timezone is used.

Examples:

```javascript

  /* Returns true if the specified date is a working day. */
  date_parse(property('config::deleted')).dayOfWeek().get() < 6

  /* Uses the server time zone to construct a DateTime object. */
  date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS")

  /* Uses the offset specified in the datetime string to construct a DateTime object. */
  date_parse("31.01.2017 12:36:03:283 -08:00", "dd.MM.yyyy HH:mm:ss:SSS ZZ")

  /* Uses the time zone specified in the datetime string to construct a DateTime object. */
  date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS ZZZ")

  /* Constructs a DateTime object from the time zone provided as the third argument. */
  date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS", "Europe/Berlin")

  /* Constructs a DateTime object from the UTC offset provided as the third argument. */
  date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS", "+01:00")

  /* If the time zone (offset) is specified in the datetime string,
  it should be exactly the same as provided by the third argument. */
  date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")

  /* These expressions lead to exceptions. */
  date_parse("31.01.2017 12:36:03:283 +01:00", "dd.MM.yyyy HH:mm:ss:SSS ZZ", "Europe/Berlin")
  date_parse("31.01.2017 12:36:03:283 Europe/Brussels", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```

### `date_format`

```javascript
  date_format(long timestamp, string pattern, string timezone) string
```

Converts timestamp to a formatted time string according to the format pattern and the timezone. Timestamp is an epoch timestamp in milliseconds. 

The format string syntax is described in the [datetime format](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html). 

List of available [time zones](../shared/timezone-list.md).

Example:

```javascript
  /* Return formatted time string  "2017-02-22 11:18:00:000 Europe/Berlin" */
  date_format(seconds('2018-01-09T14:23:40Z'), "yyyy-MM-dd HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```

### `formatInterval`

```javascript
  formatInterval(long interval) string
```

Converts interval in UNIX milliseconds to a formatted interval consisting of non-zero years, days, hours, minutes, and seconds.

Example:

```javascript
  /* Return formatted interval: 2y 139d 16h 47m 15s */
  formatInterval(75228435000L)
```

### `formatIntervalShort`

```javascript
  formatIntervalShort(long interval) string
```

Converts interval in UNIX milliseconds to a formatted interval consisting of up to two highest subsequent non-zero time units, where unit is one of years, days, hours, minutes, and seconds.

Examples:

```javascript
  /* Return formatted interval: 2y 139d */
  formatIntervalShort(75228435000L)
  
  /* Assuming current time of 2017-08-15T00:01:30Z, return short interval of elapsed time: 1m 30s */
  formatIntervalShort(elapsedTime("2017-08-15T00:00:00Z"))  
```

