# Period

Period is a repeating time interval used to group samples occurred within each interval into buckets in order to apply aggregation functions.

| **Name**  | **Type** | **Description** |
|:---|:---|:---|
| count  | number | Number of time units contained in the period. |
| unit  | string | [Time unit](time-unit.md) such as `MINUTE`, `HOUR`, `DAY`. |
| align | string | Alignment of the period's start/end time. Default: `CALENDAR`. <br>Possible values: `CALENDAR`, `START_TIME`, `END_TIME`, `FIRST_VALUE_TIME`. Not supported for [Group Processor](group.md)|

## Examples

```json
"period": { "count": 1, "unit": "HOUR" }
```

```json
"period": { "count": 5, "unit": "MINUTE" }
```

```json
"period": { "count": 5, "unit": "MINUTE", "align": "START_TIME" }
```

## Alignment

The default `CALENDAR` setting creates calendar-aligned periods using the **duration** specified with `count` and `unit` fields.

For example, `1 HOUR` initializes 1-hour long periods starting at `0` minutes of each hour within the selection interval.

| **Alignment** | **Description**|
|:---|:---|
| CALENDAR | Period start is rounded down to the nearest time unit. |
| START_TIME | First period begins at start time specified in the query. |
| FIRST_VALUE_TIME | First period begins at the time of first retrieved value. |
| END_TIME | Last period ends on end time specified in the query. |

### `CALENDAR` Alignment

The `CALENDAR` alignment calculates the initial period according to the rules below and creates subsequent periods by incrementing the duration specified with `count` and `unit` fields. The initial period is defined as the earliest period starting within the selection interval.

* `startDate` of the selection interval is rounded to calculate the _base time_ using the rule table below.
* If the _base time_ is within the selection interval, it becomes the initial period.
* Otherwise, the period starting with _base time_ is incremented (decremented if _base time_ exceeds start time) to find the earliest period starting withing the selection interval. This period becomes the initial period.

**`startDate` Rounding Rules**

| **Time Unit**   | **Base Time (Rounded)** |
|-------------|-----------|
| MILLISECOND | 0m:0s in a given hour. |
| SECOND | 0m:0s in a given hour. |
| MINUTE | 0m:0s in a given hour. |
| HOUR | 0h:0m:0s on a given day. |
| DAY | 0h:0m:0s on the 1st day in a given month. |
| WEEK | 0h:0m:0s on the 1st Monday in a given month. |
| MONTH | 0h:0m:0s on January 1st in a given year. |
| QUARTER | 0h:0m:0s on January 1st in a given year. |
| YEAR | 0h:0m:0s on January 1st, 1970. |

For example, if period is `2 HOUR`, start date of `2016-06-20 15:08` will be rounded to `2016-06-20 00:00` as the **base** time, and the initial period will start at `2016-06-20 16:00`.

Start of the day is determined according to the server timezone for `DAY`, `WEEK`, `MONTH`, `QUARTER`, and `YEAR` units.

#### Example 1

`45 MINUTE`-period with `startDate` of `2016-06-20 15:05` and `endDate` of `2016-06-20 17:30`: [`2016-06-20 15:05` - `2016-06-20 17:30`) .
* Start time `2016-06-20 15:05` is rounded to `2016-06-20 00:00` as the **base** time.
* Base time is incremented by 45 minutes until a period start is >= `15:05`: 00:00, 00:45, 01:30, etc.
* The first period to reach the start of the selection interval is `15:45` or `[2016-06-20 15:45 - 2016-06-20 16:30)`.
* The next period is incremented by 45 minutes from the start of the previous period to `[2016-06-20 16:30 - 2016-06-20 17:15)`.
* Subsequent periods are incremented by 45 minutes while their start time is earlier than `endDate`.
* The last period is `[17:15 - 18:00)` however it will contain partial data bounded by `endDate` of `17:30`: `[17:15 - 17:30)`.

#### Example 2

`45 MINUTE`-period with `startDate` of `2016-06-20 15:05:00`.

* Time is rounded to `15:00:00` and then incremented by 45 minutes until period start time is >= `15:05:00`.
* The period that first satisfies this condition is `[15:45:00 - 16:30:00)`.

#### Example 3

`365 DAY`-period with `startDate` of `2014-12-21 00:00` and `endDate` of `2016-12-20 00:00`.

* Since time unit is `DAY`, time is rounded to 1st day of the month containing `startDate`, which is `2014-12-01 00:00`.
* The first period is `[2014-12-01 00:00 - 2015-12-01 00:00)` and its start time is **outside** of the selection interval.
* The next period is `[2015-12-01 00:00 - 2016-12-01 00:00)` and its start time is within the selection interval.
* The 3rd period is `[2016-12-01 00:00 - 2017-12-01 00:00)` and its start time is also within the selection interval, although it will contain data within `[2016-12-01 00:00 - 2016-12-20 00:00)` interval being limited by `endDate`.

#### Calculation Examples

```ls
| Period     | Start Date        | End Date          | Initial Period    | 2nd Period        | Last Period      |
|-----------:|-------------------|-------------------|-------------------|-------------------|------------------|
| 1 MINUTE   | 2016-06-20 15:05  | 2016-06-24 00:00  | 2016-06-20 15:05  | 2016-06-20 15:06  | 2016-06-23 23:59 |
| 3 MINUTE   | 2016-06-20 15:05  | 2016-06-24 00:00  | 2016-06-20 15:06  | 2016-06-20 15:09  | 2016-06-23 23:57 |
| 37 MINUTE  | 2016-06-20 15:05  | 2016-06-24 00:00  | 2016-06-20 15:37  | 2016-06-20 16:14  | 2016-06-23 23:47 |
| 45 MINUTE  | 2016-06-20 15:05  | 2016-06-24 00:00  | 2016-06-20 15:45  | 2016-06-20 16:30  | 2016-06-23 23:15 |
| 45 MINUTE  | 2016-06-20 15:00  | 2016-06-24 00:00  | 2016-06-20 15:00  | 2016-06-20 15:45  | 2016-06-23 23:15 |
| 1 HOUR     | 2016-06-20 16:00  | 2016-06-24 00:00  | 2016-06-20 16:00  | 2016-06-20 17:00  | 2016-06-23 23:00 |
| 1 HOUR     | 2016-06-20 16:05  | 2016-06-23 23:55  | 2016-06-20 17:00  | 2016-06-20 18:00  | 2016-06-23 23:00 |
| 1 HOUR     | 2016-06-20 16:30  | 2016-06-24 00:00  | 2016-06-20 17:00  | 2016-06-20 18:00  | 2016-06-23 23:00 |
| 7 HOUR     | 2016-06-20 16:00  | 2016-06-24 00:00  | 2016-06-20 21:00  | 2016-06-21 04:00  | 2016-06-23 19:00 |
| 10 HOUR    | 2016-06-20 16:00  | 2016-06-24 00:00  | 2016-06-20 20:00  | 2016-06-21 06:00  | 2016-06-23 18:00 |
| 1 DAY      | 2016-06-01 16:00  | 2016-06-24 00:00  | 2016-06-02 00:00  | 2016-06-03 00:00  | 2016-06-23 00:00 |
| 2 DAY      | 2016-06-01 16:00  | 2016-06-24 00:00  | 2016-06-03 00:00  | 2016-06-05 00:00  | 2016-06-23 00:00 |
| 5 DAY      | 2016-06-01 16:00  | 2016-06-24 00:00  | 2016-06-06 00:00  | 2016-06-11 00:00  | 2016-06-21 00:00 |
| 10 DAY     | 2016-06-03 16:00  | 2016-06-24 00:00  | 2016-06-10 00:00  | 2016-06-20 00:00  | 2016-06-20 00:00 |
| 365 DAY    | 2016-06-03 16:00  | 2017-06-24 00:00  | 2017-06-01 00:00  | -                 | -                |
| 1 WEEK     | 2016-06-01 16:00  | 2016-06-24 00:00  | 2016-06-06 00:00  | 2016-06-13 00:00  | 2016-06-20 00:00 |
| 1 WEEK     | 2016-05-01 16:00  | 2016-05-24 00:00  | 2016-05-02 00:00  | 2016-05-09 00:00  | 2016-05-23 00:00 |
| 1 WEEK     | 2016-06-01 00:00  | 2016-06-02 00:00  | 1st Monday Jun-06 | -                 | -                |
```
