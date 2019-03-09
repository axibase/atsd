# Date Functions

## Overview

Date functions operate on dates, timestamps, and intervals.

## Reference

* [`date_parse`](#date_parse)
* [`date_format`](#date_format)
* [`elapsed_minutes`](#elapsed_minutes)
* [`elapsedTime`](#elapsedtime)
* [`formatInterval`](#formatinterval)
* [`formatIntervalShort`](#formatintervalshort)
* [`formatSecondOffset`](#formatsecondoffset)
* [`now`](#now)
* [`milliseconds`](#milliseconds)
* [`seconds`](#seconds)
* [`to_datetime`](#to_datetime)
* [`today`](#today)
* [`tomorrow`](#tomorrow)
* [`yesterday`](#yesterday)
* [`window_length_time`](#window_length_time)
* [`window_length_count`](#window_length_count)
* [`windowStartTime`](#windowstarttime)

### `now`

```javascript
now DateTime
```

Returns the current time as a [`DateTime`](object-datetime.md) object.

Access `DateTime` object fields using dot notation.

```javascript
// returns true on Thursdays
now.dayOfWeek == 4  
```

When printed as text, for example with `${now}` placeholder, the [`DateTime`](object-datetime.md) object is ISO date with time zone information.

```txt
2018-08-17T15:13:16.946Z[Etc/UTC]
```

**Examples**:

```javascript
// returns true on Thursdays at anytime between 15:00 and 16:00 (exclusive)
now.day_of_week == 'Thursday' && now.hourOfDay == 15
```

```javascript
// returns true if difference between current Unix time (long, milliseconds)
// and create_ms (long, Unix time in milliseconds) exceeds 15 minutes
(now.millis - create_ms) > 15*60000
```

```javascript
// returns the same result as above using the elapsedTime function
elapsedTime(create_ms) > 15*60000
```

```javascript
// returns the same result as above using the elapsed_minutes function
elapsed_minutes(create_ms) > 15
```

### `today`

```javascript
today DateTime
```

Returns the current day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.

### `tomorrow`

```javascript
tomorrow DateTime
```

Returns the following day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.

### `yesterday`

```javascript
yesterday DateTime
```

Returns the previous day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.

### `window_length_time`

```javascript
window_length_time() long
```

Returns the length of a time-based window in seconds.

### `window_length_count`

```javascript
window_length_count() long
```

Returns the length of a count-based window.

### `windowStartTime`

```javascript
windowStartTime() long
```

Returns time when the first command is received by the window, in Unix time with millisecond precision.

### `milliseconds`

```csharp
milliseconds(string date [,string pattern [,string zone]]) long
```

Parses the date string `date` into Unix time in milliseconds according to the specified [date pattern](../shared/time-pattern.md) and [time zone](../shared/timezone-list.md) (or offset from UTC).

Returns `0` if `date` is `null` or empty.

Available time zones and offsets are listed in [time zones](../shared/timezone-list.md).

The default pattern is [ISO format](../shared/date-format.md) `yyyy-MM-ddTHH:mm:ss[.S]Z` and the default time zone is the server time zone.

:::tip Warning
The function raises an error if the time zone or offset from UTC is specified in the date string `date` and differs from the time zone or offset `zone`.
:::

**Example**:

```javascript
/* Returns true if the difference between the event time and start
time (ISO) retrieved from the property record is greater than 5 minutes. */
command_time.millis - milliseconds(property('docker.container::startedAt')) >  5*60000
```

### `seconds`

```csharp
seconds(string date [,string pattern [,string zone]]) long
```

Accepts the same arguments as the [`milliseconds`](#milliseconds) function with the result in Unix time measured in seconds instead of milliseconds.

### `elapsedTime`

```csharp
elapsedTime(long timestamp) long
```

```csharp
elapsedTime(DateTime timestamp) long
```

```csharp
elapsedTime(string timestamp) long
```

Calculates the number of **milliseconds** between the current time and `timestamp` specified as Unix time in milliseconds, [`DateTime`](object-datetime.md) object, or date specified in the following format:

```txt
yyyy-MM-dd[(T| )[hh:mm:ss[.SSS[Z]]]]
```

Function returns `0` if `date` is `null` or empty.

**Example**:

```javascript
/* Assuming current time of 2017-08-15T00:01:30Z, returned elapsed time is 90000 */
elapsedTime("2017-08-15T00:00:00Z")
```

```javascript
/* Returns elapsed time in milliseconds since ISO date in tags.last_updated */
elapsedTime(milliseconds(tags.last_updated))
```

Format the interval in milliseconds with [`formatInterval`](functions-date.md#formatinterval) or [`formatintervalshort`](functions-date.md#formatintervalshort).

```javascript
/* Returns interval in short notation, for example 2y 201d */
formatIntervalShort(elapsedTime(milliseconds(tags.last_updated)))
```

### `elapsed_minutes`

```csharp
elapsed_minutes(long timestamp) long
```

```csharp
elapsed_minutes(DateTime timestamp) long
```

```csharp
elapsed_minutes(string timestamp) long
```

Calculates the number of **minutes** between the current time and `timestamp` specified as Unix time in milliseconds, [`DateTime`](object-datetime.md) object, or date specified in the following format:

```txt
yyyy-MM-dd[(T| )[hh:mm:ss[.SSS[Z]]]]
```

Function returns `0` if `date` is `null` or empty.

Returns the same result as the `elapsedTime` function divided by `60000`.

### `date_parse`

```csharp
date_parse(string date [,string pattern [,string zone]]) DateTime
```

Parses the input string `date` into a [`DateTime`](object-datetime.md) object according to the specified [date pattern](../shared/time-pattern.md) and [time zone](../shared/timezone-list.md) or offset from UTC.

The default pattern is [ISO format](../shared/date-format.md) `yyyy-MM-ddTHH:mm:ss[.S]Z` and the default time zone is the server time zone.

:::tip Warning
The function raises an error if the time zone (or offset from UTC) is specified in `date` and differs from the time zone (offset) `zone`.
:::

Access fields of the [`DateTime`](object-datetime.md#fields) object using dot notation:

```javascript
date_parse("2018-01-13T16:45:22.303Z").day_of_week
date_parse("2018-01-13T16:45:22.303Z").millis
date_parse("2018-01-13T16:45:22.303Z").next_workday
```

**Examples**:

```javascript
/* Returns true if the specified date is a working day. */
date_parse(property('config::deleted')).is_workday()
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

### `to_datetime`

```csharp
to_datetime(long time [, string zone]) DateTime
```

Returns [`DateTime`](object-datetime.md) object initialized from Unix time in milliseconds `time` in the  **server** time zone.
If the optional [time zone](../shared/timezone-list.md) argument `zone` is specified, the `DateTime` is initialized in the user-defined time zone.

**Example**:

```javascript
/* Returns true if the create_ms date is a working day. */
to_datetime(create_ms, 'America/Chicago').is_workday()
```

### `date_format`

```csharp
date_format(long time | DateTime date
               [, string pattern
                   [, string zone]]) string
```

Converts timestamp `time`, specified as Unix time in milliseconds or a [`DateTime`](object-datetime.md) object, to a string according to the specified [date pattern](../shared/time-pattern.md) and the [time zone](../shared/timezone-list.md).
If neither the date pattern nor the time zone are specified, the input time is formatted with the default ISO format in the **UTC time zone**.
If time zone is not specified, the input time `t` is formatted using `pattern` in the **server** time zone.

Examples:

```javascript
/* Returns current time minus 1 hour formatted as "2018-01-09T15:23:40:00Z" */
date_format(now.millis - 3600000L)
```

```javascript
/* Returns current time formatted as "Jan-09 15:23" in server time zone */
date_format(now, "MMM-dd HH:mm")
```

```javascript
/* Returns formatted time string  "2018-01-09 15:23:40:00 Europe/Berlin" */
date_format(milliseconds('2018-01-09T14:23:40Z'), "yyyy-MM-dd HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```

:::tip Related Functions
Related date parsing function: [`date_parse`](functions-date.md#date_parse)
:::

### `formatInterval`

```csharp
formatInterval(long interval) string
```

Converts interval in Unix time measured in milliseconds to a formatted interval consisting of non-zero years, days, hours, minutes, and seconds.

Examples:

```javascript
/* Returns formatted interval: 2y 139d 16h 47m 15s */
formatInterval(75228435000L)
```

```javascript
formatInterval(elapsedTime(milliseconds(tags.last_updated)))
```

### `formatIntervalShort`

```csharp
formatIntervalShort(long interval) string
```

Converts interval measured in milliseconds to a formatted interval consisting of up to the two highest subsequent non-zero time units, where the unit comprises years, days, hours, minutes, and seconds.

Examples:

```javascript
/* Returns formatted interval: 2y 139d */
formatIntervalShort(75228435000L)
```

```javascript
/* Assuming current time of 2017-08-15T00:01:30Z, returns a short interval of elapsed time: 1m 30s */
formatIntervalShort(elapsedTime("2017-08-15T00:00:00Z"))
```

### `formatSecondOffset`

```csharp
formatSecondOffset(int interval) string
```

Converts UTC offset in seconds to time zone pattern `±hh:mm`. The input seconds are negative for time zones ahead of UTC, such as `Europe/Vienna`.

Examples:

```javascript
/* Returns 00:00 */
formatSecondOffset(0)
```

```javascript
/* Returns +02:00 */
formatSecondOffset(-7200)
```

```javascript
${formatSecondOffset(column('TMZDIFF'))}
```