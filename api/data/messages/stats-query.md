# Messages: Statistics Query

## Description

Retrieve message counters as series for specified filters.

If period aggregation is enabled, the series contains the number of messages in each period. Otherwise, the series contains the total number of messages within the specified interval.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/messages/stats/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following filtering fields:

#### Message Filter Fields

Refer to message [query](query.md#message-filter-fields) fields.

#### Message Counter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
|`metric`|string | [**Required**] Must be set to `message-count`. |
|`groupKeys`|array | Array of message tags used for grouping: `type`, `source`, `entity`, etc, for example `"groupKeys": ["entity", "type"]` |
|`aggregate`|object | Period [aggregator](../../../api/data/series/aggregate.md). Only `COUNT` type is supported. <br>`"aggregate":{"type":"COUNT", "period":{"count":1,"unit":"HOUR"}}` |

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../../../api/data/filter-entity.md).

#### Date Filter Fields

* [**Required**]
* Refer to [date filter](../../../api/data/filter-date.md).

#### Control Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `requestId` | string | Optional identifier used to associate `query` object in request with `series` objects in response. |
| `timeFormat` |string| Time format for data array. `iso` or `milliseconds`. Default: `iso`. |

## Response

An array of `series` objects containing message filter fields and message counter fields.

Tags used for grouping are returned in the `tags` object.

### Fields

Refer to [series fields](../../../api/data/series/insert.md#fields).

### Errors

None.

## Example

### Request

#### URI

```elm
POST https://atsd_hostname:8443/api/v1/messages/stats/query
```

#### Payload

```json
[{
        "entity" : "nurswgvml007",
        "metric" : "message-count",
        "groupKeys" : ["type"],
        "aggregate" : {
            "type" : "COUNT",
            "period" : {
                "count" : 1,
                "unit" : "HOUR"
            }
        },
        "startDate" : "current_day",
        "endDate" : "now"
    }
]
```

#### curl

```elm
curl  https://atsd_hostname:8443/api/v1/messages/stats/query \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data @file.json
```

### Response

#### Payload

```json
[
{
    "entity": "nurswgvml007",
    "metric": "message-count",
    "tags":
    {
        "type": "application"
    },
    "type": "HISTORY",
    "aggregate":
    {
        "type": "COUNT",
        "period":
        {
            "count": 1,
            "unit": "HOUR"
        }
    },
    "data":
    [
        {
            "d": "2016-05-31T06:00:00.000Z",
            "v": 1
        }
    ]
},
{
    "entity": "nurswgvml007",
    "metric": "message-count",
    "tags":
    {
        "type": "backup"
    },
    "type": "HISTORY",
    "aggregate":
    {
        "type": "COUNT",
        "period":
        {
            "count": 1,
            "unit": "HOUR"
        }
    },
    "data":
    [
        {
            "d": "2016-05-31T03:00:00.000Z",
            "v": 4
        }
    ]
},
{
    "entity": "nurswgvml007",
    "metric": "message-count",
    "tags":
    {
        "type": "security"
    },
    "type": "HISTORY",
    "aggregate":
    {
        "type": "COUNT",
        "period":
        {
            "count": 1,
            "unit": "HOUR"
        }
    },
    "data":
    [
        {
            "d": "2016-05-31T00:00:00.000Z",
            "v": 32
        },
        {
            "d": "2016-05-31T07:00:00.000Z",
            "v": 30
        },
        {
            "d": "2016-05-31T09:00:00.000Z",
            "v": 2
        },
        {
            "d": "2016-05-31T10:00:00.000Z",
            "v": 30
        },
        {
            "d": "2016-05-31T12:00:00.000Z",
            "v": 16
        }
    ]
}
]
```

## Additional Examples

* [Counting all Messages for an Entity](examples/stats-query/messages-stats-query-counting-all-messages-for-entity.md)
* [Multiple Entities Counted as 1 Series, no Grouping](examples/stats-query/messages-stats-query-multiple-entities-counted-series.md)
* [Entity Array with Message Counts Grouped by Entity](examples/stats-query/messages-stats-query-entity-array-with-message-counts-grouped.md)
* [Message Counts Grouped by Multiple Fields](examples/stats-query/messages-stats-query-message-counts-grouped-multiple-fields.md)
* [Message Counts Grouped by Type](examples/stats-query/messages-stats-query-message-counts-grouped-type.md)
* [Message Count per Period](examples/stats-query/messages-stats-query-message-count-per-period.md)
* [Interpolate Counts for Missing Periods with 0 value](examples/stats-query/messages-stats-query-interpolate-counts-for-missing-periods.md)
* [Milliseconds `timeFormat`](examples/stats-query/messages-stats-query-with-milliseconds-time-format.md)
* [Multiple Queries for Different Message Types](examples/stats-query/messages-stats-query-multiple-queries-different-message-types.md)
