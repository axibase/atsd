# `DateTime` Object

## Overview

`DateTime` object represents a specific date and time in the **server** time zone.

## `get()` Methods

The object provides `get()` methods to extract numeric values for various calendar units.

* `getDayOfMonth()`
* `getDayOfWeek()`
* `getDayOfYear()`
* `getHourOfDay()`
* `getMillis()`
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

> The `getMillis()` method returns current time in Unix milliseconds.

## Extended Methods

* `is_weekday()`
* `is_weekend()`
* [`add(a, u)`](#add-function)

## `now` Window Field

The `now` field returns a `DateTime` object that contains **current** server time.

## `add` function

```javascript
add(number c, string u) DateTime
```

Returns a [`DateTime`](object-datetime.md) object created by adding an interval to the current `DateTime` object. The interval is specified as count `c` of [time units](../api/data/series/time-unit.md) `u`.

```javascript
now.add(1, 'hour')
```

If count argument `c` is negative, the interval is subtracted from the current `DateTime` object.

Fractional count argument `c` is rounded down to the nearest integer.

The [time unit](../api/data/series/time-unit.md) `u` is case-insensitive [time unit](../api/data/series/time-unit.md) and allows both singular and plural forms.

**Examples**:

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
|`getYear()`|`2018`|
|`getMonthOfYear()`|`1`|
|`getDayOfMonth()`|`13`|
|`getHourOfDay()`|`16`|
|`getMinuteOfHour()`|`45`|
|`getSecondOfMinute()`|`22`|
|`getMillisOfSecond()`|~|
|`getDayOfYear()`|`13`|
|`getDayOfWeek()`|`6`|
|`getWeekOfWeekyear()`|`2`|
|`getMillisOfDay()`|`60322303`|
|`getMinuteOfDay()`|`1005`|
|`getSecondOfDay()`|`60322`|
|`getWeekyear()`|`2018`|
|`getYearOfCentury()`|`18`|
|`getYearOfEra()`|`2018`|
|`getCenturyOfEra()`|`20`|
|`getEra()`|`1`|
|`getMillis()`|`1515861922303`|
|`is_weekday()`|`false`|
|`is_weekend()`|`true`|