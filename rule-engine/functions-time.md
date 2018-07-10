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

Returns the current time as a [`DateTime`](object-datetime.md) object. The object fields can be accessed with `get` methods.

```javascript
  // returns true on Thursdays
  now.getDayOfWeek() == 4
```

```javascript
  // returns true on Thursdays at anytime between 15:00 and 16:00 (exclusive)
  now.getDayOfWeek() == 4 && now.getHourOfDay() == 15
```

```javascript
  // returns true if difference between current time (long, Unix milliseconds) and create_ms (long, Unix milliseconds) exceeds 1 hour
  (now.getMillis() - create_ms) > 60*60000
```

### `window_length_time`

```javascript
  window_length_time() long
```

Returns length of a time-based window in seconds, as configured.

### `window_length_count`

```javascript
  window_length_count() long
```

Returns length of a count-based window, as configured.

### `windowStartTime`

```javascript
  windowStartTime() long
```

Returns time when the first command is received by the window, in Unix milliseconds.

### `milliseconds`

```javascript
  milliseconds(string d [,string p [,string z]]) long
```

Parses the date string `d` into Unix milliseconds according to the specified [date pattern](../shared/time-pattern.md) `p` and [time zone](../shared/timezone-list.md) `z` (or offset from UTC).

Returns `0` if the date `d` is `null` or empty.

Available time zones and offsets are listed in [time zones](../shared/timezone-list.md).

The default pattern is `ISO8601` format `yyyy-MM-dd'T'HH:mm:ss[.SSS]Z` and the default time zone is the server time zone.

> Raises an error if the time zone (or offset from UTC) is specified in the date string `d` and it differs from the time zone (offset) `z`.

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

Provides the same arguments as the [`milliseconds`](#milliseconds) function except the result is returned in Unix seconds instead of milliseconds.

### `elapsedTime`

```javascript
  elapsedTime(long t) long
```

```javascript
  elapsedTime(string d) long
```

Calculates the number of milliseconds between the current time and time `t` which is specified in Unix milliseconds.

Accepts time `t` in Unix milliseconds or the date `d` in the following format:

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

Parses the input string `d` into a [`DateTime`](object-datetime.md) object according to the specified [date pattern](../shared/time-pattern.md) `p` and [time zone](../shared/timezone-list.md) `z` (or offset from UTC).

The default pattern is `ISO8601` format `yyyy-MM-dd'T'HH:mm:ss[.SSS]Z` and the default time zone is the server time zone.

> The function raises an error if the time zone (or offset from UTC) is specified in the date string `d` differs from the time zone (offset) `z`. See Exception Examples below.

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
    date_parse("31.01.2017 12:36:03:283 -08:00", "dd.MM.yyyy HH:mm:ss:SSS ZZ")
```

```javascript
    /* Uses the time zone specified in the datetime string to construct a DateTime object. */
    date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS ZZZ")
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
    /* Time zone (offset) specified in the datetime must be the same as provided in the third argument. */
    date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```

```javascript
    /* These expressions lead to exceptions. */
    date_parse("31.01.2017 12:36:03:283 +01:00", "dd.MM.yyyy HH:mm:ss:SSS ZZ", "Europe/Berlin")
    date_parse("31.01.2017 12:36:03:283 Europe/Brussels", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```
