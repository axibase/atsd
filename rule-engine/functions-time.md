# Date Functions

## Overview

Date functions perform various operations on dates, timestamps, and intervals.

## Reference

* [`now`](#now)
* [`window_length_time`](#window_length_time)
* [`window_length_count`](#window_length_count)
* [`windowStartTime`](#windowstarttime)
* [`milliseconds`](#milliseconds)
* [`seconds`](#seconds)
* [`elapsedTime`](#elapsedtime)
* [`date_parse`](#date_parse)

## Related Formatting Functions

* [`date_format`](functions-format.md#date_format)
* [`formatInterval`](functions-format.md#formatinterval)
* [`formatIntervalShort`](functions-format.md#formatintervalshort)

### `now`

```javascript
  now long
```

Returns the current time as a [`DateTime`](object-datetime.md) object. The object's fields can be accessed with `get` methods.

```javascript
  // returns true if it's Thursday
  now.getDayOfWeek() == 4
```

```javascript
  // returns true on Thursday at anytime between 15:00 and 16:00 (exclusive)
  now.getDayOfWeek() == 4 && now.getHourOfDay() == 15
```

```javascript
  // returns true if difference between current time (long, UNIX millis) and create_ms (long, UNIX millis) exceeds 1 hour
  (now.getMillis() - create_ms) > 60*60000
```

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
  milliseconds(string d [,string p [,string z]]) long
```

Parses the date string `d` into UNIX milliseconds according to the specified [date pattern](../sql/time-pattern.md) `p` and [time zone](../shared/timezone-list.md) `z` (or offset from UTC).

The function returns `0` if the date `d` is `null` or empty.

Available time zones and their offsets are listed in [time zones](../shared/timezone-list.md).

The default pattern is ISO8601 format `yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'` and the default time zone is the server time zone.

> The function will raise an error if the time zone (or offset from UTC) is specified in the date string `d` and it differs from the time zone (offset) `z`.

Example:

```javascript
  /* Returns true if the difference between the event time and start
  time (ISO) retrieved from the property record is greater than 5 minutes. */
  timestamp - milliseconds(property('docker.container::startedAt')) >  5*60000
```

### `seconds`

```javascript
  seconds(string d [,string p [,string z]]) long
```

This function provides the same arguments as the [`milliseconds`](#milliseconds) function except the result is returned in UNIX seconds instead of milliseconds.

### `elapsedTime`

```javascript
  elapsedTime(long t) long
```

```javascript
  elapsedTime(string d) long
```

Calculates the number of milliseconds between the current time and time `t` which is specified in UNIX milliseconds.

The function accepts time `t` in UNIX milliseconds or the date `d` in the following format:

```txt
yyyy-MM-dd[(T| )[hh:mm:ss[.SSS[Z]]]]
```

The function returns `0` if the date `d` is `null` or empty.

Example:

```javascript
  /* Assuming current time of 2017-08-15T00:01:30Z, returned elapsed time is 90000 */
  elapsedTime("2017-08-15T00:00:00Z")
```

```javascript
  /* Returns elapsed time in milliseconds since ISO date in tags.last_updated */
  elapsedTime(milliseconds(tags.last_updated))
```

The interval in milliseconds can be formatted with [`formatInterval`](functions-format.md#formatinterval) or [`formatintervalshort`](functions-format.md#formatintervalshort).

```javascript
  /* Returns interval in short notation, for example 2y 201d */
  formatIntervalShort(elapsedTime(milliseconds(tags.last_updated)))
```

### `date_parse`

```javascript
  date_parse(string d [,string p [,string z]]) DateTime
```

Parses the input string `d` into a [`DateTime`](object-datetime.md) object according to the specified [date pattern](../sql/time-pattern.md) `p` and [time zone](../shared/timezone-list.md) `z` (or offset from UTC).

The default pattern is ISO8601 format `yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'` and the default time zone is the server time zone.

> The function will raise an error if the time zone (or offset from UTC) is specified in the date string `d` differs from the time zone (offset) `z`. See Exception Examples below.

The fields of the `DateTime` object can be accessed using the following methods:

```javascript
  date_parse("2018-01-13T16:45:22.303Z").getDayOfWeek()
```

Examples:

```javascript
    /* Returns true if the specified date is a working day. */
    date_parse(property('config::deleted')).getDayOfWeek() < 6
```

```javascript
    /* Uses the server time zone to construct a DateTime object. */
    date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS")
```

```javascript
    /* Uses the offset specified in the datetime string to construct a DateTime object. */
    date_parse("31.01.2017 12:36:03:283 -08:00", "dd.MM.yyyy HH:mm:ss:SSS XXX")
```

```javascript
    /* Uses the time zone specified in the datetime string to construct a DateTime object. */
    date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS VV")
```

```javascript
    /* Constructs a DateTime object from the time zone provided as the third argument. */
    date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS", "Europe/Berlin")
```

```javascript
    /* Constructs a DateTime object from the UTC offset provided as the third argument. */
    date_parse("31.01.2017 12:36:03:283", "dd.MM.yyyy HH:mm:ss:SSS", "+01:00")
```

```javascript
    /* If the time zone (offset) is specified in the datetime string,
    it should be exactly the same as provided by the third argument. */
    date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS VV", "Europe/Berlin")
```

```javascript
    /* These expressions lead to exceptions. */
    date_parse("31.01.2017 12:36:03:283 +01:00", "dd.MM.yyyy HH:mm:ss:SSS XXX", "Europe/Berlin")
    date_parse("31.01.2017 12:36:03:283 Europe/Brussels", "dd.MM.yyyy HH:mm:ss:SSS VV", "Europe/Berlin")
```
