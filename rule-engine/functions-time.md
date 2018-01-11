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

Parses the datetime string `d` into UNIX milliseconds according to the specified [pattern](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html) `p` and [timezone](http://joda-time.sourceforge.net/timezones.html) `z` (or offset from UTC).

Available timezones and their offsets are listed in [time zones](../shared/timezone-list.md).

The default pattern is ISO8601 format `yyyy-MM-ddTHH:mm:ss.SSSZ` and the default timezone is the server timezone.

> The function will raise an error if the timezone (or offset from UTC) is specified in the datetime string `d` and it differs from the timezone (offset) `z`.

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

Same as the `milliseconds` function except the result is returned in UNIX seconds.

### `elapsedTime`

```javascript
  elapsedTime(long timestamp) long
```

Calculates the number of milliseconds between the current time and the specified time. The function accepts time in UNIX milliseconds or the following format:

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
  date_parse(string d [,string p [,string z]]) DateTime
```

Parses the input string `d` into a [DateTime](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) object according to the specified [pattern](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html) `p` and [timezone](../shared/timezone-list.md) `z` (or offset from UTC).

The default pattern is ISO8601 format `yyyy-MM-ddTHH:mm:ss.SSSZ` and the default timezone is the server timezone.

> The function will raise an error if the timezone (or offset from UTC) is specified in the datetime string `d` and it differs from the timezone (offset) `z`.

The fields of the DateTime object can be accessed with getter methods:

```javascript
  date_parse('2018-01-13T16:45:22.303Z').getDayOfWeek()
```

Method values for sample date 2018-01-13T16:45:22.303Z (Saturday):

|**Method**| **Value** |
|:---|:---|
|getCenturyOfEra()|20|
|getDayOfMonth()|13|
|getDayOfWeek()|6|
|getDayOfYear()|13|
|getEra()|1|
|getHourOfDay()|16|
|getMillisOfDay()|60322303|
|getMillisOfSecond()|303|
|getMinuteOfDay()|1005|
|getMinuteOfHour()|45|
|getMonthOfYear()|1|
|getSecondOfDay()|60322|
|getSecondOfMinute()|22|
|getWeekOfWeekyear()|2|
|getWeekyear()|2018|
|getYear()|2018|
|getYearOfCentury()|18|
|getYearOfEra()|2018|

Examples:

  ```javascript
    /* Returns true if the specified date is a working day. */
    date_parse(property('config::deleted')).getDayOfWeek() < 6
  ```

  ```javascript
    /* Uses the server timezone to construct a DateTime object. */
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
    /* If the timezone (offset) is specified in the datetime string,
    it should be exactly the same as provided by the third argument. */
    date_parse("31.01.2017 12:36:03:283 Europe/Berlin", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")
  ```

  ```javascript
    /* These expressions lead to exceptions. */
    date_parse("31.01.2017 12:36:03:283 +01:00", "dd.MM.yyyy HH:mm:ss:SSS ZZ", "Europe/Berlin")
    date_parse("31.01.2017 12:36:03:283 Europe/Brussels", "dd.MM.yyyy HH:mm:ss:SSS ZZZ", "Europe/Berlin")
  ```

Datetime Pattern reference:

  ```
   Symbol  Meaning                      Presentation  Examples
   ------  -------                      ------------  -------
   G       era                          text          AD
   C       century of era (>=0)         number        20
   Y       year of era (>=0)            year          1996

   x       weekyear                     year          1996
   w       week of weekyear             number        27
   e       day of week                  number        2
   E       day of week                  text          Tuesday; Tue

   y       year                         year          1996
   D       day of year                  number        189
   M       month of year                month         July; Jul; 07
   d       day of month                 number        10

   a       halfday of day               text          PM
   K       hour of halfday (0~11)       number        0
   h       clockhour of halfday (1~12)  number        12

   H       hour of day (0~23)           number        0
   k       clockhour of day (1~24)      number        24
   m       minute of hour               number        30
   s       second of minute             number        55
   S       fraction of second           number        978

   z       time zone                    text          Pacific Standard Time; PST
   Z       time zone offset/id          zone          -0800; -08:00; America/Los_Angeles

   '       escape for text              delimiter
   ''      single quote                 literal       '
  ```  
