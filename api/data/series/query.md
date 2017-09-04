# Series: Query

## Description

Retrieve series objects containing time:value arrays for specified filters.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/series/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following filtering fields:

#### Series Filter Fields

| **Field** | **Type** | **Description** |
|---|---|---|
| type | string | Type of underlying data: `HISTORY`, `FORECAST`, `FORECAST_DEVIATION`. Default: `HISTORY` |
| metric | string | [**Required**] Metric name |
| tags | object  | Object with `name=value` fields. <br>Matches series with tags that contain the same fields but may also include other fields. <br>Tag field values support `?` and `*` wildcards. |
| tagExpression | string | An expression to include series that match the specified tag condition. |
| exactMatch | boolean | `tags` match operator. _Exact_ match if true, _partial_ match if false. Default: **false**.<br>_Exact_ match selects series with exactly the same `tags` as requested.<br>_Partial_ match selects series with tags that contain requested tags but may also include other tags.|

##### Tag Expression Filter

* The `tagExpression` field can refer to series tags by name using `tags.{name}` syntax.
* The series record must satisfy both the `tags` object and the `tagExpression` in order to be included in the results.
* Supported operands: `LIKE`, `NOT LIKE`, `=`, `!=`, `>=`, `>`, `<=`, `<`.
* Supported functions: `LOWER`.
* Supported wildcards: `?` and `*`.

```javascript
tags.location LIKE 'nur*'
```

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

> Queries of `FORECAST` and `FORECAST_DEVIATION` type do **not** support wildcards in the entity name and tag values. Tag value `'*'` matches all tags.

#### Date Filter Fields

* [**Required**]
* Refer to [date filter](../filter-date.md).

#### Forecast Filters

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
|forecastName| string | Unique forecast name. Identifies a custom forecast by name. If `forecastName` is not set, then the default forecast computed by the database will be returned. `forecastName` is applicable only when `type` is set to `FORECAST` or `FORECAST_DEVIATION`. |

#### Versioning Filters

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| versioned | boolean |Returns version status, source, and change date if the metric is versioned. Default: false. |
| versionFilter | string | Expression to filter value history (versions) by version status, source or time, for example: `version_status = 'Deleted'` or `version_source LIKE '*user*'`. To filter by version `time`, use `date()` function, for example, `version_time > date('2015-08-11T16:00:00Z')` or `version_time > date('current_day')`. The `date()` function accepts [endtime](../../../end-time-syntax.md) syntax.|

#### Control Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| limit   | integer | Maximum number of time:value samples returned for each series. Default: 0 (no limit).<br>Note that limit is applied from the end (default direction=`DESC`), for example, `limit=1` means last value.<br>Limit is not applied if the parameter value <= 0. |
| direction| string | Order for applying the `limit`: `DESC` - descending, `ASC` - ascending. Default: `DESC`. <br>The returned data values will still be sorted in ascending order.<br>`limit=10` means the most recent 10 values.<br>`ASC` direction is NOT supported at the moment.|
| seriesLimit   | integer | Maximum number of series returned. Default: 0 (no limit).<br>The database will raise a processing error if series count exceeds **10000** for queries that fetch data for an unversioned metric without `limit`.|
| cache | boolean | If `true`, execute the query against the Last Insert table, which is the fastest way to retrieve the last value for a query. Default: `false`.<br>Values in the Last Insert table may be delayed up to 15 seconds , controlled with `last.insert.write.period.seconds` setting. Only 1 value is returned for each series.|
| requestId | string | Optional identifier used to associate `query` object in request with one or multiple `series` objects in response. |
| timeFormat |string| Time format for a data array. `iso` or `milliseconds`. Default: `iso`. |
| addMeta | boolean | Include metric and entity metadata (field, tags) under the `meta` object in response. Default: false.|

#### Transformation Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| [aggregate](aggregate.md) | object | Group detailed values into periods and calculate statistics for each period. Default: `DETAIL` |
| [group](group.md) | object | Merge multiple series into one series. |
| [rate](rate.md) | object | Compute difference between consecutive samples per unit of time (rate period). |

## Transformation Sequence

The default processor sequence is as follows:

1. group
2. rate
3. aggregate

The sequence can be modified by specifying an `order` field in each processor, in which case processor steps are executed in ascending order as specified in the `order` field.

## Response

The response contains an array of series objects, each containing series identifiers and request fields and an array of timestamped value objects.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| entity | string | Entity name |
| metric | string | Metric name |
| tags | object | Object containing series tags. |
| type | string | Type of inserted data: `HISTORY`, `FORECAST`. |
| aggregate | string | Type of aggregation. |
| data | array | Array of [Value](#value-object) objects.|

#### Value Object

* The value object contains a numeric and/or text value and the time when it was observed.
* The object may contain sample time in Epoch milliseconds (`t` field) or ISO format (`d` field).

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| t | integer | Sample time in Epoch milliseconds.|
| d | string | Sample time in ISO format. |
| v | number | Numeric sample value at time `t`/`d`. <br>The field is set to `null` if the value is Not a Number: `{"d":"2017-09-14T17:00:03.000Z","v":null}`|
| x | string | Text sample value at time `t`/`d`. |
| version | object | Object containing version source and status fields for versioned metrics. |

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/series/query
```

#### Payload

```json
[{
  "startDate": "2017-09-14T17:00:00Z",
  "endDate":   "2017-09-14T18:00:00Z",
  "entity": "nurswgvml007",
  "metric": "mpstat.cpu_busy"
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

## `curl` Example

```
curl http://localhost:8088/api/v1/series/query \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -X POST \
  -d '[{"metric":"mpstat.cpu_busy", "entity":"nurswgvml007", "startDate":"previous_day", "endDate": "now"}]' > response.json
```

## Java Example

* [Series Query](examples/DataApiSeriesQueryExample.java)

## Additional Examples

### Time Range

* [ISO Start/End Range](examples/query-iso-range.md)
* [ISO Millisecond Precision](examples/query-iso-range-millis.md)
* [ISO hh:mm Timezone](examples/query-iso-hhmm-timezone.md)
* [ISO: All Data Range](examples/query-iso-range-all.md)
* [Interval Window](examples/query-interval-window.md)
* [End Date and Interval](examples/query-end-date-interval.md)
* [EndTime Syntax](examples/query-endtime-syntax.md)
* [EndTime Syntax with Expression](examples/query-endtime-syntax-expression.md)
* [EndTime: Current Day](examples/query-endtime-currentday.md)
* [EndTime: Previous Hour](examples/query-endtime-previousday.md)
* [EndTime: Hour Window](examples/query-endtime-hour-window.md)
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

* [Not-a-Number (NaN)](examples/query-nan.md)

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

* [EndTime: Hour to now](examples/query-regularize.md)

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
* [Period Alignment: EndTime](examples/query-period-endtime.md)
* [Period Misalignment](examples/query-period-misalignment.md)

### Group

* [Group Order](examples/query-group-order.md)
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
