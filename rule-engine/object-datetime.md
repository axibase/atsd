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
* `is_weekday(cal)`
* `is_weekend()`
* `is_weekend(cal)`

The `getMillis()` method returns current time in Unix milliseconds.

`is_weekday` and `is_weekend` functions accept optional calendar key parameters. Refer to [Holiday Calendar](holiday-calendar.md) description for details.
If calendar key is not specified, ATSD uses the `default.holiday.calendar` server property.

## `now` Window Field

The `now` field returns the `DateTime` object that contains **current** server time.

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
|`is_weekday('usa')`|`false`|
|`is_weekend()`|`true`|
|`is_weekend('usa')`|`true`|
