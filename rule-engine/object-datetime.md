# `DateTime` Object

## Overview

The `DateTime` object represents a specific date and time in the **server** time zone.

## `get()` Methods

The object provides `get()` methods to extract numeric values for the various calendar units.

* `getDayOfMonth()`
* `getDayOfWeek()`
* `getDayOfYear()`
* `getHourOfDay()`
* `getMillisOfDay()`
* `getMillisOfSecond()`
* `getMinuteOfDay()`
* `getMinuteOfHour()`
* `getMonthOfYear()`
* `getSecondOfDay()`
* `getSecondOfMinute()`
* `getWeekOfWeekyear()`
* `getWeekyear()`
* `getYear()`
* `getYearOfCentury()`
* `getYearOfEra()`
* `getCenturyOfEra()`
* `getEra()`
* `getMillis()`
* `is_weekday()`
* `is_weekend()`
* [`add(a, u)`](#add-function)

The `getMillis()` method returns current time in Unix milliseconds.

## `now` Window Field

The `now` field returns the `DateTime` object that contains **current** server time.

## `add` function

```javascript
add(number a, string u) DateTime
```

Returns a new `DateTime` object with added amount `a` of units `u`.
If `a` is negative, `abs(a)` of units `u` will be subtracted from target `DateTime` object.

If `a` is a floating-point number, its fractional part will be cut off.
Units `u` are case-insensitive. 

The following units are supported:

**Unit** | **Alias**
---------|----------
`NANOS`     | `NANO`, `NANOSECOND`, `NANOSECONDS`
`MICROS`    | `MICRO`, `MICROSECOND`, `MICROSECONDS`
`MILLIS`    | `MILLI`, `MILLISECOND`, `MILLISECONDS`
`SECONDS`   | `SECOND`
`MINUTES`   | `MINUTE`
`HOURS`     | `HOUR`
`HALF_DAYS` | `HALF_DAY`
`DAYS`      | `DAY`
`WEEKS`     | `WEEK`
`MONTHS`    | `MONTH`
`QUARTERS`  | `QUARTER`
`YEARS`     | `YEAR`
`DECADES`   | `DECADE`
`CENTURIES` | `CENTURY`
`MILLENIA`  | `MILLENNIUM`
`ERAS`      | `ERA`
`FOREVER`   |

Examples:

```javascript
/* Returns true if tomorrow is a working day. */
now.add(1, 'day').is_workday()

/* Returns day of week 10 year ago. */
now.add(-10, 'years').day_of_week
```

## Sample Values

The following values are returned by the `DateTime` object on `2018-01-13T16:45:22.303Z` (Saturday).

|**Method**| **Value** |
|:---|---:|
|`getYear()`|2018|
|`getMonthOfYear()`|1|
|`getDayOfMonth()`|13|
|`getHourOfDay()`|16|
|`getMinuteOfHour()`|45|
|`getSecondOfMinute()`|22|
|`getMillisOfSecond()`|303|
|`getDayOfYear()`|13|
|`getDayOfWeek()`|6|
|`getWeekOfWeekyear()`|2|
|`getMillisOfDay()`|60322303|
|`getMinuteOfDay()`|1005|
|`getSecondOfDay()`|60322|
|`getWeekyear()`|2018|
|`getYearOfCentury()`|18|
|`getYearOfEra()`|2018|
|`getCenturyOfEra()`|20|
|`getEra()`|1|
|`getMillis()`|1515861922303|
|`is_weekday()`|`false`|
|`is_weekend()`|`true`|
