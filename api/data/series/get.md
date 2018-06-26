# Series: Get

## Description

Retrieves series values for the specified entity, metric, and series tags in JSON or CSV format.

The method implements a subset of features of the [Series: Query](query.md) method with a simplified parameter syntax.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/series/{format}/{entity}/{metric}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `entity` | **[Required]** Entity name. |
| `metric` | **[Required]** Metric name. |
| `format` | **[Required]** Response format: `csv` or `json`. |

### Query String Parameters

#### Date Parameters

The date interval for loading the time series is **required** and must be defined using a combination of any of the two parameters listed below. Refer to [date filter](../filter-date.md) for more details.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `startDate` | string | Start date in ISO format or [calendar](../../../shared/calendar.md) expression. |
| `endDate` | string | End date in ISO format or [calendar](../../../shared/calendar.md) expression. |
| `interval` | string | Interval specified as  `count`-`time_unit`.<br>Example: `interval=1-DAY`.<br>Refer to the list of supported [time units](time-unit.md). |

Examples:

* `interval=1-DAY&endDate=now`
* `startDate=2018-01-01T00:00:00Z&endDate=2018-06-01T00:00:00Z`
* `startDate=previous_month&endDate=current_month`

#### Series Filter Parameters

To restrict results to series with specific tags, specify one or multiple tag names and values in the query string. A series is included in the results if it contains all of the requested tags and the tag values match the values enumerated in the request.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`t:{name}`|string|Series tag name and value.<br>Prefix the tag name by `t:` to differentiate it from other parameters.<br>Example: `t:disk=sda1`.<br>Example: `t:disk=sda1&t:fstype=ext4`.<br>Multiple values for the same tag can be requested by repeating the parameter.<br>Example: `t:disk=sda1&t:disk=sdb1`.<br>Tag value supports wildcards, for example `t:disk=*`.|

#### Extended Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`aggregate`|string|[Statistical function](../aggregation.md#statistical-functions) applied to detailed values in each period.<br>Example: `aggregate=avg`.|
|`period`|string|Duration of the aggregation period specified as `count`-`time_unit`.<br>Example: `period=1-HOUR`.<br>Refer to the list of supported [time units](time-unit.md).|
| `align` | string | Alignment of the period start/end time.<br>Allowed values: `CALENDAR`, `START_TIME`, `END_TIME`, `FIRST_VALUE_TIME`.<br>Default: `CALENDAR`.<br>Example: `align=START_TIME`. Refer to the [alignment](./period.md#alignment) for more details.|

#### Format Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`limit`|integer|Limit the response to last-N samples for each series.<br>The constraint applies to each series in the response separately.<br>Default: `0` (unlimited).<br>Example: `limit=1`. |
|`columns`|string|_Applies to CSV format_.<br>Columns included in the response.<br>Possible values: `time`, `date`, `entity`, `metric`, `value`, requested tag names (prefixed by `t:`).<br>Default: `time`, `entity`, `metric`, requested tag names, `value`.<br>Example: `columns=time,t:disk,value`. |
|`timeFormat`|string|_Applies to JSON format_.<br>Timestamp format in the `data` array in the JSON document.<br>Possible values: `iso`, `milliseconds`. Default: `milliseconds`.<br>Example: `timeFormat=iso`. |

## Response

### JSON Format

The returned JSON document contains the same fields as in the [Series: Query](query.md#response) method.

```elm
/api/v1/series/json/nurswgvml006/df_used?startDate=current_hour&endDate=now&limit=2
```

Note that the `tags` object in the JSON response contains **all** tags in the series key irrespective of which tags are specified in the request.

```json
[
  {
    "entity": "nurswgvml006",
    "metric": "df_used",
    "tags": {
      "disk": "sda1",
      "fstype": "ext4"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      { "t": 1529854360000, "v": 4584832 },
      { "t": 1529854375000, "v": 4584840 }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "df_used",
    "tags": {
      "disk": "sdb1",
      "fstype": "ext4"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      { "t": 1529854360000, "v": 59353568 },
      { "t": 1529854375000, "v": 59407956 }
    ]
  }
]
```

#### CSV Format

The response in CSV format contains the header row followed by data rows.

The default header is `time,entity,metric,requested tags,value` and contains the following columns.

* `time`: value time in Unix milliseconds
* `date`: value time in ISO format
* `entity`: entity name
* `metric`: metric name
* `tag` columns (if requested)
* `value`: numeric value

Example for `columns=date,t:disk,value`.

```elm
/api/v1/series/csv/nurswgvml006/df_used?limit=2&startDate=current_hour&endDate=now&t:disk=*&columns=time,t:disk,value
```

Note that the tag column names in the header _do not_ start with the `t:` prefix.

```ls
time,disk,value
1529854420000,sda1,4584832
1529854435000,sda1,4584840
1529854420000,sda2,59353568
1529854435000,sda2,59407956
```

## Example

### Request

#### URI

```elm
GET /api/v1/series/json/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now
```

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&limit=3" \
  --insecure --include -user {username}:{password}
```

### Response

#### JSON Format

```json
[
    {
      "entity": "nurswgvml007",
      "metric": "mpstat.cpu_busy",
      "tags": {},
      "type": "HISTORY",
      "aggregate": {
        "type": "DETAIL"
      },
      "data": [
        { "d": "2018-04-27T11:00:09Z", "v": 5.05 },
        { "d": "2018-04-27T11:00:25Z", "v": 3.03 },
        { "d": "2018-04-27T11:00:41Z", "v": 5 }
      ]
    }
]
```

#### CSV Format

```ls
time,entity,metric,value
2018-05-22T12:00:08Z,nurswgvml007,cpu_busy,26.53
2018-05-22T12:00:24Z,nurswgvml007,cpu_busy,17.35
2018-05-22T12:00:40Z,nurswgvml007,cpu_busy,12.24
2018-05-22T12:00:56Z,nurswgvml007,cpu_busy,15
2018-05-22T12:01:12Z,nurswgvml007,cpu_busy,6.06
```

## Additional Examples

[CSV Format Query](examples/get-csv-format.md)
