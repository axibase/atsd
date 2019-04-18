# `DateTime` Object

## Overview

A `DateTime` object represents a specific date and time. The object provides fields to extract calendar units and functions to perform calendar arithmetic.

`DateTime` objects can be retrieved from [window fields](./window-fields.md#date-fields) and by creating new objects using the [`to_datetime`](./functions-date.md#to_datetime) function. In addition, special date objects such as `now` are available to access the current server time.

When printed as text, a `DateTime` object is formatted as [ISO date](../shared/date-format.md) with additional time zone details.

```ls
${now} --> 2018-08-17T15:13:16.946Z[Etc/UTC]
```

To format the `DateTime` object using a different pattern or time zone, use the [`date_format`](./functions-date.md#date_format) function.

```javascript
// Jan-09 15:23
date_format(command_time, "MMM-dd HH:mm", "US/Pacific")
```

To compare two dates, use the `millis` field.

```javascript
// Check the difference between open and command times
command_time.millis - open_time.millis > 15000
```

To compare the date with current time, use the [`elapsedTime`](./functions-date.md#elapsedtime) function.

```javascript
// Check if any command arrived within the 5 minutes
elapsedTime(add_time) < 5*60000
```

To calculate the interval between the two `DateTime` objects, the [`elapsedTime`](./functions-date.md#elapsedtime) function.

```javascript
// Return the number of milliseconds between add_time and command_time
elapsedTime(add_time, command_time) < 5*60000
```

The `DateTime` objects can be compared in boolean conditions, for example in the notification [control flow](./control-flow.md) statements.

```java
@if{command_time > add_time}
Command has future timestamp: `${command_time}` / `${add_time}` / `${now}`
@end{}
```

## Time Zone

By default, a `DateTime` object is initialized in **server** time zone.

To change the time zone of an existing `DateTime` object, invoke the [`to_timezone(tz)`](#to_timezone-function) function which returns a modified `DateTime` object in a custom [time zone](../shared/timezone-list.md).

To create a new `DateTime` object from Unix time in milliseconds, use the [`to_datetime(ms, tz)`](functions-date.md#to_datetime) function.

## Fields

The table below enumerates available `DateTime` object fields and their values for `2018-01-13T16:45:22.303Z` (Saturday).

|**Method**| **Value for `2018-01-13T16:45:22.303Z`** |
|:---|---:|
|`day_of_week`|`Saturday`|
|`year`|`2018`|
|`monthOfYear`|`1`|
|`dayOfMonth`|`13`|
|`hourOfDay`|`16`|
|`minuteOfHour`|`45`|
|`secondOfMinute`|`22`|
|`millisOfSecond`|`303`|
|`dayOfYear`|`13`|
|`weekOfWeekyear`|`2`|
|`millisOfDay`|`60322303`|
|`minuteOfDay`|`1005`|
|`secondOfDay`|`60322`|
|`weekyear`|`2018`|
|`yearOfCentury`|`18`|
|`yearOfEra`|`2018`|
|`centuryOfEra`|`20`|
|`millis`|`1515861922303`<br>Unix time in milliseconds.|
|`next_workday`|`DateTime('2018-01-16T00:00Z[UTC]')`|
|`previous_workday`|`DateTime('2018-01-12T00:00Z[UTC]')`|
|`next_non_working_day`|`DateTime('2018-01-14T00:00Z[UTC]')`|
|`previous_non_working_day`|`DateTime('2018-01-07T00:00Z[UTC]')`|
|`is_weekday()`|`false`|
|`is_weekday('usa')`|`false`|
|`is_weekend()`|`true`|
|`is_weekend('usa')`|`true`|
|`is_workday()`|`false`|
|`is_workday('usa')`|`false`|
|`is_exceptionday('usa')`|`false`|

Fields `next_workday`, `previous_workday`, `next_non_working_day`, and `previous_non_working_day` are calculated based on the [workday calendar](workday-calendar.md) specified in `default.holiday.calendar` server property.

## Functions

* [`add`](#add-function)
* [`is_weekday`](#is_weekday-function)
* [`is_weekend`](#is_weekend-function)
* [`is_workday`](#is_workday-function)
* [`is_exceptionday`](#is_exceptionday-function)
* [`to_timezone`](#to_timezone-function)

### `add` Function

```javascript
add(number count, string unit) DateTime
```

Returns a [`DateTime`](object-datetime.md) object created by adding an interval to the current `DateTime` object. The interval is specified as `count` of [time `units`](../api/data/series/time-unit.md).

```javascript
now.add(1, 'hour')
```

If `count` is negative, the interval is subtracted from the current `DateTime` object.

Fractional `count` is rounded **down** to the nearest integer.

The [time `unit`](../api/data/series/time-unit.md) is **case-insensitive** and supports both singular and plural units (`hour`/`HOUR`/`hours`/`HOURS`).

The new `DateTime` object inherits the time zone of the original object.

**Examples**:

```javascript
/* Returns true if tomorrow is a working day. */
now.add(1, 'day').is_workday()

/* Returns day of week 10 year ago. */
now.add(-10, 'years').day_of_week
```

### `is_weekday` Function

```javascript
is_weekday( [string code] ) boolean
```

* Returns `true` if the `DateTime` object is a weekday.
* Accepts optional [ISO-3166 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country `code`.
* If country cannot be resolved by country code, returns `true` if day of week is not Saturday or Sunday.
* If country code is not specified, the database uses the `default.holiday.calendar` server property.
* By default `default.holiday.calendar` resolves country code from the `user.country` system property.

### `is_weekend` Function

```javascript
is_weekend( [string code] ) boolean
```

* Returns `true` if the `DateTime` object is a weekend day.
* Accepts optional [ISO-3166 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country `code`.
* If country cannot be resolved by country code, returns `true` if day of week is Saturday or Sunday.
* If country code is not specified, the database uses the `default.holiday.calendar` server property.
* By default `default.holiday.calendar` resolves country code from the `user.country` system property.

### `is_workday` Function

```javascript
is_workday( [string calendarKey] ) boolean
```

* Returns `true` if the `DateTime` object is a working day based on the observed [workday calendar](workday-calendar.md).
* Accepts optional calendar key argument `calendarKey`.
* If `calendarKey` is not specified, the database uses the `default.holiday.calendar` server property.
* The function throws an exception if no workday calendar is found, or if the workday calendar contains no date for the given year.

```javascript
// returns true if average exceeds 10 on a working day, taking observed holidays into account
avg() > 10 && is_workday('usa')
```

```javascript
// returns true 2 days before the first non-working day, typically on Thursdays
now.hourOfDay = 12 AND
  now.is_workday()
  AND now.add(1, 'day').is_workday()
  AND NOT now.add(2, 'day').is_workday()
```

### `is_exceptionday` Function

```javascript
is_exceptionday( [string code] ) boolean
```

The convenience function returns `true` if a working day is classified as a holiday or if a weekend day becomes a working day.

```javascript
now.is_weekend() && now.is_workday() || now.is_weekday() && !now.is_workday()
```

### `to_timezone` Function

```javascript
to_timezone(string zone) DateTime
```

* Returns a new `DateTime` object based on server time but modified to the specified [time `zone`](../shared/timezone-list.md).

```javascript
now.to_timezone('Europe/Berlin').next_workday
```