# DateTime Object

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

## `now` Window Field

The `now` field returns the DateTime object that contains **current** server time. 

## Sample Values 

The following values are returned by the DateTime object on `2018-01-13T16:45:22.303Z` (Saturday).

|**Method**| **Value** |
|:---|---:|
|getYear()|2018|
|getMonthOfYear()|1|
|getDayOfMonth()|13|
|getHourOfDay()|16|
|getMinuteOfHour()|45|
|getSecondOfMinute()|22|
|getMillisOfSecond()|303|
|getDayOfYear()|13|
|getDayOfWeek()|6|
|getWeekOfWeekyear()|2|
|getMillisOfDay()|60322303|
|getMinuteOfDay()|1005|
|getSecondOfDay()|60322|
|getWeekyear()|2018|
|getYearOfCentury()|18|
|getYearOfEra()|2018|
|getCenturyOfEra()|20|
|getEra()|1|