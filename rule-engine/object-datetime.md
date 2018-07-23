# `DateTime` Object

## Overview

The `DateTime` object represents a specific date and time in the **server** time zone.

## Fields

* `millis`
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
* `next_workday`
* `previous_workday`
* `next_non_working_day`
* `previous_non_working_day`

The `millis` field returns time in Unix milliseconds.

`next_workday`, `previous_workday`, `next_non_working_day`, `previous_non_working_day` fields are based on the calendar specified in `default.holiday.calendar` server property.

## Window Fields

|**Field**| **Description** |
|:---|---:|
| `now` | `DateTime` object that contains **current** server time. |
| `today` | `DateTime` object that contains **midnight** of the **current day** in server time zone. |
| `yesterday` | `DateTime` object that contains **midnight** of the **previous day** in server time zone. |
| `tomorrow` | `DateTime` object that contains **midnight** of the **next day** in server time zone. |

## Functions

* [`is_weekday`](#is_weekday)
* [`is_weekend`](#is_weekend)
* [`is_workday`](#is_workday)

### `is_weekday`

```javascript
is_weekday( [string c] ) boolean
```

Returns `true` if the `DateTime` object is a weekday.
Accepts optional [ISO-3166 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country code `c`.
If country cannot be resolved by country code, returns `true` if day of week is not Saturday or Sunday.
If country code is not specified, the database uses the `default.holiday.calendar` server property.
By default `default.holiday.calendar` resolves country code from the `user.country` system property.

### `is_weekend`

```javascript
is_weekend( [string c] ) boolean
```

Returns `true` if the `DateTime` object is a weekend day.
Accepts optional [ISO-3166 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country code `c`.
If country cannot be resolved by country code, returns `true` if day of week is Saturday or Sunday.
If country code is not specified, the database uses the `default.holiday.calendar` server property.
By default `default.holiday.calendar` resolves country code from the `user.country` system property.

### `is_workday`

```javascript
is_workday( [string c] ) boolean
```

Returns `true` if the `DateTime` object is a working day based on the observed [holiday calendar](holiday-calendar.md). Accepts optional calendar key parameter `c`. If calendar `c` is not specified, the database uses the `default.holiday.calendar` server property.

The function throws an exception if no holiday calendar is found, or if the holiday calendar contains no date for the given year.

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
