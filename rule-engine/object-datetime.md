# `DateTime` Object

## Overview

The `DateTime` object represents a specific date and time in the **server** time zone.

## Properties

* `day_of_week`
* `dayOfMonth`
* `dayOfYear`
* `hourOfDay`
* `millisOfDay`
* `millisOfSecond`
* `minuteOfDay`
* `minuteOfHour`
* `monthOfYear`
* `secondOfDay`
* `secondOfMinute`
* `weekOfWeekyear`
* `weekyear`
* `year`
* `yearOfCentury`
* `yearOfEra`
* `centuryOfEra`
* `millis`
* `next_workday`
* `previous_workday`
* `next_non_working_day`
* `previous_non_working_day`

The `millis` property returns current time in Unix milliseconds.

## Methods

* `is_weekday([c])`
* `is_weekend([c])`
* `is_workday([cal])`

`is_weekday` and `is_weekend` functions accept optional [ISO-3166 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country code.

`is_workday()` function accepts optional calendar key parameter. Refer to [Holiday Calendar](holiday-calendar.md) description for details.
If calendar key is not specified, ATSD uses the `default.holiday.calendar` server property.

## Window Fields

|**Field**| **Description** |
|:---|---:|
| `now` | `DateTime` object that contains **current** server time. |
| `today` | `DateTime` object that contains **midnight** of the **current day** in server time zone. |
| `yesterday` | `DateTime` object that contains **midnight** of the **previous day** in server time zone. |
| `tomorrow` | `DateTime` object that contains **midnight** of the **next day** in server time zone. |

## Sample Values

The following values are returned by the `DateTime` object on `2018-01-13T16:45:22.303Z` (Saturday).

|**Method**| **Value** |
|:---|---:|
|`day_of_week`|Saturday|
|`year`|2018|
|`monthOfYear`|1|
|`dayOfMonth`|13|
|`hourOfDay`|16|
|`minuteOfHour`|45|
|`secondOfMinute`|22|
|`millisOfSecond`|303|
|`dayOfYear`|13|
|`weekOfWeekyear`|2|
|`millisOfDay`|60322303|
|`minuteOfDay`|1005|
|`secondOfDay`|60322|
|`weekyear`|2018|
|`yearOfCentury`|18|
|`yearOfEra`|2018|
|`centuryOfEra`|20|
|`millis`|1515861922303|
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
