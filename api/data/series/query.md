# Series: query

## Description

Retrieves time series objects for the specified metric, entity, tags, and date range. Applies common time series transformations including aggregation, interpolation, downsampling etc.

## Quick Start

Basic query:

```json
[{
  "metric":    "mpstat.cpu_busy",
  "entity":    "nurswgvml007",
  "startDate": "2018-05-20T00:00:00Z",
  "endDate":   "2018-05-20T01:00:00Z"
}]
```

Query response:

```json
[{
  "metric":    "mpstat.cpu_busy",
  "entity":    "nurswgvml007",
  "data": [
    {"d":"2018-05-20T00:01:30Z", "v":24.2},
    {"d":"2018-05-20T00:03:15Z", "v":39.8},
    {"d":"2018-05-20T00:05:00Z", "v":39.1}
  ]
}]
```

## Request

| **Method** | **Path** | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/v1/series/query` | `application/json` |

The request payload is a JSON document containing an array of query objects.

```sh
[{
  /* query 1: filter, transform, control */
},{
  /* query 2: filter, transform, control */
}]
```

The query contains **filter** fields to find time series in the database, **transform** fields to modify the matched series, and **control** fields to order and format the results.

## Filters

### Base Filter

| **Field** | **Type** | **Description** |
|---|---|---|
| `metric` | string | [**Required**] Metric name. |
| `type` | string | Data type: `HISTORY`, `FORECAST`, `FORECAST_DEVIATION`. <br>Default: `HISTORY` |

### Entity Filter

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

```json
"entity": "nurswgvml007"
```

```json
"entityGroup": "nur-prod-servers"
```

```json
"entityExpression": "tags.location LIKE 'SVL*'"
```

> Queries of `FORECAST` and `FORECAST_DEVIATION` type do **not** support wildcards in the entity name and tag values. Tag value `*` matches all tags.

### Tag Filter

| **Field** | **Type** | **Description** |
|---|---|---|
| `tags` | object  | Object with `name:value` fields. <br>Matches series that contain the specified series tags. <br>Tag values support `?` and `*` wildcards. |
| `exactMatch` | boolean | `tags` match operator. **Exact** match if `true`, **partial** match if `false`.<br>Default: `false` (**partial** match).<br>**Exact** match selects series with exactly the same `tags` as requested.<br>**Partial** match selects series with tags that contain requested tags but can also include additional tags.|
| `tagExpression` | string | An expression to include series with tags that satisfy the specified condition. |

```json
"tags": { "mount_point": "/", "file_system": "/dev/sda1" }
```

#### Tag Expression

* The `tagExpression` can refer to series tags by name using `tags.{name}` syntax.
* The series record must satisfy both the `tags` object and the `tagExpression` condition to be included in the results.
* Supported operators: `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `=`, `!=`, `>=`, `>`, `<=`, `<`.
* Supported functions: `LOWER`.
* Wildcards `?` and `*` are supported by `LIKE` and `NOT LIKE` operators. Symbols `?` and `*` are treated as regular characters when used with comparison operators `=`, `!=`, `>=`, `>`, `<=`, `<`.

```json
"tagExpression": "tags.file_system LIKE '/dev/sda*'"
```

```json
"tagExpression": "tags.file_system NOT IN ('/dev/sda1', '/dev/sda2')"
```

### Date Filter

* [**Required**]
* Refer to [date filter](../filter-date.md).

```json
"startDate": "2018-05-30T14:00:00Z",
"endDate":   "2018-05-30T15:00:00Z"
```

### Forecast Filter

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
|`forecastName`| string | Unique forecast name. Identifies a custom forecast by name. If `forecastName` is not set, then the default forecast computed by the database is returned. `forecastName` is applicable only when `type` is set to `FORECAST` or `FORECAST_DEVIATION`. |

### Versioning Filter

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `versioned` | boolean |Returns version status, source, and change date if the metric is versioned.<br>Default: `false`. |
| `versionFilter` | string | Expression to filter value history (versions) by version status, source or time, for example: `version_status = 'Deleted'` or `version_source LIKE '*user*'`. To filter by version `time`, use `date()` function, for example, `version_time > date('2018-08-11T16:00:00Z')` or `version_time > date('current_day')`. The `date()` function accepts [calendar](../../../shared/calendar.md) keywords.|

### Value Filter

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `valueFilter` | string | Boolean expression applied to each `time:value` sample. Samples that satisfy the condition are included in the result.<br>Available fields: `value` and `date`.<br>The `value` field in the expression refers to the current sample value.<br>The `date` field represents sample timestamp as an instance of the [`DateTime`](../../../rule-engine/object-datetime.md) object.|

Value Filter Processing Rules:

* The value filter is applied **before** series transformations (interpolation, aggregation, etc).
* In case of a versioned metric in `versioned=true` mode, the filter checks only the last value recorded for the given time. If the last value satisfies the filter, all versions for that time are included.
* The `date` fields is an instance of the [`DateTime`](../../../rule-engine/object-datetime.md) object and can be tested with various date functions.

Examples:

* `value > 0`: Retrieves samples which are positive numbers.
* `value > 2 && value <= 3`: Retrieves samples within the specified range.
* `Math.sin(value) < 0.5`: [Math](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html) functions are supported.
* `Double.isNaN(value)`: Only `NaN` values and deleted values pass this check.
* `date.is_weekday()`: Retrieves samples recorded on [week days](../../../rule-engine/object-datetime.md#is_weekday-function) within the selection interval.
* `!date.is_exceptionday()`: Retrieves samples recorded on [regular calendar](../../../rule-engine/object-datetime.md#is_exceptionday-function) days.

## Transformations

| **Name**  | **Description**  |
|:---|:---|
| [interpolate](interpolate.md) | Fill missing values in the detailed data using a linear or step-like interpolation functions. |
| [group](group.md) | Merge multiple series into one series. |
| [rate](rate.md) | Compute difference between consecutive samples per unit of time (rate period). |
| [aggregate](aggregate.md) | Group detailed values into periods and calculate statistics for each period. |
| [smooth](smooth.md) | [Smooth](https://en.wikipedia.org/wiki/Smoothing) time series. |
| [downsample](downsample.md) | Reduce time series cardinality by filtering out some samples. |
| [forecast](forecast.md) | Predict future values based on trends and recurring patterns. |

The default transformation sequence is as follows:

1. [interpolate](interpolate.md)
2. [group](group.md)
3. [rate](rate.md)
4. [aggregate](aggregate.md)
5. [smooth](smooth.md)
6. [downsample](downsample.md)
7. [forecast](forecast.md)

The [interpolate](interpolate.md) transformation, if requested, is applied to detailed data before the values are passed to subsequent stages.

The default sequence can be modified by adding an `transformationOrder` field.

```json
"transformationOrder": ["group", "forecast"]
```

## Control Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `limit`   | integer | Maximum number of `time:value` samples returned for each series. Default: 0 (no limit).<br>The limit is applied from the beginning of the selection interval if the direction is `ASC` and from the end if the direction is `DESC`.<br>For example, `limit=1` with `direction=DESC` returns the most recent last value.<br>Limit is not applied if the parameter value <= 0. |
| `direction`| string | Order for applying the `limit` parameter: `ASC`: ascending, `DESC`: descending. Default: `DESC`. <br>The returned data values are sorted in ascending order regardless of direction.<br>`limit=10` means the most recent 10 values.|
| `seriesLimit`   | integer | Maximum number of series returned. Default: 0 (no limit).<br>The database raises a processing error if series count exceeds **10000** for queries that fetch data for an non-versioned metric without `limit`.|
| `cache` | boolean | If `true`, execute the query against the Last Insert table, which is the fastest way to retrieve the last value for a query. Default: `false`.<br>Values in the Last Insert table can be delayed up to 15 seconds , controlled with `last.insert.write.period.seconds` setting. Only 1 value is returned for each series.|
| `requestId` | string | Optional identifier used to associate `query` object in request with one or multiple `series` objects in response. |
| `timeFormat` |string| Time format for a data array. `iso` or `milliseconds`. Default: `iso`. |
| `addMeta` | boolean | Include metric and entity metadata (fields and tags) under the `meta` object in the response. Default: `false`.|
| `transformationOrder` |array| List of transformation names such as `interpolate`, `aggregate` to control the order in which the transformations are applied to data.<br>Example: `"transformationOrder": ["group", "forecast"]` |

## Response

The response contains an array of series objects, each containing series identifiers and request fields and an array of timestamped value objects.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` | string | Entity name |
| `metric` | string | Metric name |
| `tags` | object | Object containing series tags. |
| `type` | string | Type of inserted data: `HISTORY`, `FORECAST`. |
| `aggregate` | string | Type of statistical aggregation: `DETAIL`, `AVG`, `MAX`, etc. |
| `data` | array | Array of [Value](#value-object) objects.|
| `meta` | object | Metric and entity metadata fields, if requested with the `addMeta` parameter. |

### Value Object

* The value object contains a sample time and a numeric (`v` field) or text (`x` field) value.
* Specify sample time in Unix time with millisecond precision (`t` field) or [ISO format](../../../shared/date-format.md#supported-formats) (`d` field).

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `t` | integer | Sample Unix time with millisecond precision.|
| `d` | string | Sample time in [ISO format](../../../shared/date-format.md#supported-formats). |
| `v` | number | Numeric sample value at time `t`/`d`. <br>The field is set to `null` if the value is Not a Number: `{"d":"2017-09-14T17:00:03.000Z","v":null}`|
| `x` | string | Text sample value at time `t`/`d`. |
| `version` | object | Object containing version source and status fields for versioned metrics. |

## Example

### Request

#### URI

```elm
POST /api/v1/series/query
```

#### Payload

```json
[{
  "startDate": "2017-09-14T17:00:00Z",
  "endDate":   "2017-09-14T18:00:00Z",
  "entity":    "nurswgvml007",
  "metric":    "mpstat.cpu_busy"
}]
```

### Response

```json
[{
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
        {"d":"2017-09-14T17:00:03.000Z","v":24.24},
        {"d":"2017-09-14T17:00:19.000Z","v":39.8},
        {"d":"2017-09-14T17:00:35.000Z","v":39.18}
    ]
}]
```

### `curl` Example

```bash
curl https://atsd_hostname:8443/api/v1/series/query \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  -d '[{"metric":"mpstat.cpu_busy", "entity":"nurswgvml007", "startDate":"previous_day", "endDate": "now"}]' > response.json
```

### Java Example

* [Series Query](examples/DataApiSeriesQueryExample.java)

### Python Example

* [Querying Series](https://github.com/axibase/atsd-api-python#querying-series)

## Additional Examples

### Time Range

* [ISO Start/End Range](examples/query-iso-range.md)
* [ISO Millisecond Precision](examples/query-iso-range-millis.md)
* [ISO hh:mm Time Zone](examples/query-iso-hhmm-timezone.md)
* [ISO: All Data Range](examples/query-iso-range-all.md)
* [Interval Window](examples/query-interval-window.md)
* [End Date and Interval](examples/query-end-date-interval.md)
* [`EndTime` Syntax](examples/query-endtime-syntax.md)
* [`EndTime` Syntax with Expression](examples/query-endtime-syntax-expression.md)
* [`EndTime`: Current Day](examples/query-endtime-currentday.md)
* [`EndTime`: Previous Hour](examples/query-endtime-previousday.md)
* [`EndTime`: Hour Window](examples/query-endtime-hour-window.md)
* [Response Time Format](examples/query-response-time-format.md)
* [Cache Range](examples/query-range-cache.md)

### Series Tags

* [Defined Tags](examples/query-tags-defined.md)
* [Multiple Tag Values](examples/query-tags-multiple.md)
* [Wildcard: All Values](examples/query-tags-wildcard.md)
* [Wildcard: Expression](examples/query-tags-wildcard-expression.md)
* [Exact Tag Match](examples/query-tags-exact-match.md)
* [Unknown Tag](examples/query-tags-unknown.md)
* [Tag Expression](examples/query-tag-expression.md)

### Special Values

* [Not-a-Number (`NaN`)](examples/query-nan.md)

### Entity Filter

* [Multiple Entities](examples/query-entity-array.md)
* [Multiple Entities Including Entities without Data](examples/query-entity-array-nodata.md)
* [Entity Wildcard](examples/query-entity-wildcard.md)
* [Entity Expression: Name](examples/query-entity-expr-name.md)
* [Entity Expression: Entity Tags](examples/query-entity-expr-entity-tags.md)
* [Entity Expression: No Entity Tag](examples/query-entity-expr-entity-tags-not.md)
* [Entity Expression: Entity Properties](examples/query-entity-expr-entity-properties.md)
* [Entity Group](examples/query-entity-group.md)

### Multiple Queries

* [Multiple Queries](examples/query-multiple.md)
* [Multiple Queries With Request Id](examples/query-multiple-request-id.md)
* [Multiple Queries for Unknown Entity](examples/query-multiple-unknown-entity.md)
* [Multiple Queries with Limit](examples/query-multiple-limit.md)

### Control Fields

* [Limit](examples/query-limit.md)
* [Limit with Direction](examples/query-limit-direction.md)
* [Series Limit](examples/query-series-limit.md)
* [Entity and Metric Metadata](examples/query-metadata.md)

### Regularize / Downsample

* [Interpolate Transformation](interpolate.md)
* [`EndTime`: Hour to now](examples/query-regularize.md)

### Aggregation

* [Average](examples/query-aggr-avg.md)
* [Multiple Functions](examples/query-aggr-multiple.md)
* [All Functions](examples/query-aggr-all-functions.md)
* [Counter/Delta](examples/query-aggr-counter.md)
* [Maximum Value Times](examples/query-aggr-minmax-value.md)
* [Maximum Value Time (2)](examples/query-aggr-max-value-time.md)
* [Threshold](examples/query-aggr-threshold.md)
* [Threshold with Working Minutes](examples/query-aggr-threshold-sla.md)
* [Average Threshold Percentage](examples/query-aggr-threshold-avg-multiple.md)
* [Interpolation](examples/query-aggr-interpolation.md)
* [Aggregation of Interpolated Values](examples/query-aggr-interpolate-delta.md)

### Period

* [Multiple Periods](examples/query-period-multiple.md)
* [Period Alignment: `EndTime`](examples/query-period-endtime.md)
* [Period Misalignment](examples/query-period-misalignment.md)

### Group

* [Group Order](examples/query-group-order.md)
* [Group by Entity and Tags](examples/query-group-by-entity-and-tags.md)
* [Group Without Aggregation](examples/query-group-no-aggr.md)
* [Group Without Aggregation: Truncate](examples/query-group-no-aggr-truncate.md)
* [Group Without Aggregation: Extend](examples/query-group-no-aggr-extend.md)
* [Group Without Aggregation: Interpolate](examples/query-group-no-aggr-interpolate.md)
* [Group Without Aggregation: Wildcard and Entity Group](examples/query-group-no-aggr-entity-group.md)
* [Group With Period Aggregation](examples/query-group-aggr.md)
* [Group > Period Aggregation](examples/query-group-order-aggr-group.md)
* [Period Aggregation > Group](examples/query-group-order-group-aggr.md)

### Rate

* [Rate of Change](examples/query-rate.md)
* [Rate of Change with Aggregation](examples/query-rate-aggr.md)

### Forecast

* [Named Forecast](examples/query-named-forecast.md)

### Versioning

* [Versioning](examples/query-versioning.md)
* [Versioning: Status Filter](examples/query-versioning-filter-status.md)
* [Versioning: Source Filter](examples/query-versioning-filter-source.md)
* [Versioning: Date Filter](examples/query-versioning-filter-date.md)
* [Versioning: Composite Filter](examples/query-versioning-filter-composite.md)
