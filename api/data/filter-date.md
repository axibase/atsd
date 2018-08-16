# Date Filter Fields

Date fields define the time range for selecting the data.

| **Name** | **Type** | **Description** |
|:---|:---|:---|
|`startDate`|    string | Start of the selection interval. <br>[ISO format](../../shared/date-format.md) date or [calendar](../../shared/calendar.md) keyword.<br>Matches records timestamped at or after `startDate`.<br>Examples: `2016-05-25T00:15:00.194Z`, `current_hour` |
| `endDate` |    string | End of the selection interval. <br>[ISO format](../../shared/date-format.md) date or [calendar](../../shared/calendar.md) keyword.<br>Matches records timestamped before `endDate`.<br>Examples: `2016-05-25T00:15:00Z`, `previous_day - 1 * HOUR`|
| `interval` |    object | Duration of the selection interval, specified as `count` and `unit`. <br>Example: `{"count": 5, "unit": "MINUTE"}`|

* `startDate` is inclusive and `endDate` is exclusive.

## Required Fields

* Date filter is **required** in one of the following field combinations.

| **Fields**  | **Notes** |
|:---|:---|
|`startDate` and `endDate`| |
|`startDate` and `interval`|`endDate` is set to `startDate` + `interval`|
|`endDate` and `interval`|`startDate` is set to `endDate` - `interval`|
|`interval`|`endDate` is set to current server time <br>`startDate` is set to the latest of two dates: <br>`endDate` - `interval` and `1970-01-01T00:00:00Z`.|

## ISO Date Formats

See [Date Format Specifications](../../shared/date-format.md) for supported ISO formats.

## Examples

At or after `2016-05-30 14:00` and before `2016-05-30 15:00` in UTC time zone:

```json
"startDate":"2016-05-30T14:00:00Z", "endDate":"2016-05-30T15:00:00Z"
```

At or after `2016-05-30 06:00` and before `2016-05-30 07:00` in PST time zone (GMT-8:00):

```json
"startDate":"2016-05-30T06:00:00-08:00", "endDate":"2016-05-30T07:00:00-08:00"
```

At or after `2016-05-30T10:00:00Z` and before current server time:

```json
"startDate":"2016-05-30T10:00:00Z", "endDate":"now"
```

Last 2 hours, ending with current server time:

```json
"interval":{"count":2, "unit":"HOUR"}
```

Last 2 hours:

```json
"interval":{"count":2, "unit":"HOUR"}, "endDate":"now"
```

Last 2 hours of the previous day:

```json
"interval":{"count":2, "unit":"HOUR"}, "endDate":"current_day"
```

Last hour, rounded:

```json
"startDate":"previous_hour", "endDate": "current_hour"
```

All the data until now:

```json
"startDate":"1970-01-01T00:00:00Z", "endDate":"now"
```

All the data:

```json
"startDate":"1970-01-01T00:00:00.000Z", "endDate":"9999-12-31T23.59.59.999Z"
```
