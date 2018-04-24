# Series: URL Query

## Description

Retrieve series values for the specified entity, metric, and optional series tags in CSV and JSON format.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/series/{format}/{entity}/{metric}` |

### Parameters

#### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `entity` | **[Required]** Entity name. |
| `metric` | **[Required]** Metric name. |
| `format` | **[Required]** Response format: `csv` or `json`. |

#### Query String Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
|`t:name`|string|Tag name, prefixed by `t:`. Tag value specified as a parameter value, for example, `&t:file_system=/tmp`. <br>Multiple values for the same tag can be specified by repeating the parameter, for example, `&t:file_system=/tmp&&t:file_system=/home/export`|
|`aggregate`|string|[Statistical function](../aggregation.md#statistical-functions) to compute aggregate results from detailed values in each period.|
|`period`|string|Duration of the aggregation period specified as `count-timeunit`, for example, `1-hour`.|
|`limit`|integer|Maximum number of samples returned in the response. Default value: 0 (unlimited). |
|`columns`|string|Columns included in CSV format response. <br>Possible values: time, date (time in ISO), entity, metric, t:{name}, value. <br>Default: time, entity, metric, requested tag names, value

#### Query String Date Parameters

* **[Required]** Refer to [date filter](../filter-date.md).

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `startDate` | string | Start date in ISO format or [calendar](../../../shared/calendar.md) syntax. |
| `endDate` | string | End date in ISO format or [calendar](../../../shared/calendar.md) syntax. |
| `interval` | string | Interval specified as `{count}-{timeunit}`, for example `1-hour`. |

## Response

### Fields

#### json

See response fields in [Series: Query](query.md#response).

#### csv

Header: `time/date, entity, metric, tag names as specified in t: parameters or column, value`

Data rows.

Example:

```ls
time,entity,metric,value
2016-05-22T12:00:08Z,nurswgvml007,cpu_busy,26.53
```

### Errors

## Example

### Request

#### URI

```elm
GET https://atsd_host:8443/api/v1/series/json/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&timeFormat=iso
```

#### curl

```elm
curl https://atsd_host:8443/api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&timeFormat=iso \
  --insecure --verbose -user {username}:{password} \
  --request GET
```

### Response

#### json

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
        {
          "d": "2015-04-27T11:00:09Z",
          "v": 5.05
        },
        {
          "d": "2015-04-27T11:00:25Z",
          "v": 3.03
        },
        {
          "d": "2015-04-27T11:00:41Z",
          "v": 5
        }
      ]
    }
  ]
```

#### csv

```ls
time,entity,metric,value
2016-05-22T12:00:08Z,nurswgvml007,cpu_busy,26.53
2016-05-22T12:00:24Z,nurswgvml007,cpu_busy,17.35
2016-05-22T12:00:40Z,nurswgvml007,cpu_busy,12.24
2016-05-22T12:00:56Z,nurswgvml007,cpu_busy,15
2016-05-22T12:01:12Z,nurswgvml007,cpu_busy,6.06
```

## Additional Examples

[CSV Format Query](examples/url-query-csv-format.md)
