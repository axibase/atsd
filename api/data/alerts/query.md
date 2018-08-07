# Alerts: query

## Description

Retrieves **open** alerts for specified filters.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/v1/alerts/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following fields:

#### Alert Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `rules`       | array | Array of rules which produced the alerts.        |
| `metrics`     | array | Array of metric names to filter alerts. |
| `severities`  | array | Array of [severity names](../../../api/data/severity.md)   |
| `minSeverity` |  string   | Minimal severity [name](../../../api/data/severity.md) filter.  |
| `acknowledged` |  boolean   | Acknowledgement status. If set, filters alerts for the specified status. |

> Note that the `tags` filter is not supported.

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

#### Date Filter Fields

* [**Required**]
* Date conditions are applied to alert `openDate`.
* Refer to [date filter](../filter-date.md).

#### Result Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `limit`   | integer | Maximum number of records returned. Default: `-1`.<br>Limit is not applied if the parameter value <= `0`. |

## Response

An array of matching alert objects containing the following fields:

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| `id`    | integer | Alert id.|
| `acknowledged` | boolean | Acknowledgement status.|
| `entity` | string | Entity name. |
| `metric` | string | Metric name.  |
| `rule` | string | Rule name. |
| `severity`  | string | [Severity](../../../api/data/severity.md) name.  |
| `tags` | object | Object containing `name=value` pairs, for example `tags: {"path": "/", "name": "sda"}` |
| `repeatCount` | integer | Number of times when the expression evaluated to `true` sequentially.  |
| `textValue` | string | Text value.  |
| `value` | double | Last numeric value received. |
| `openValue` | double | First numeric value received.  |
| `openDate` | string | ISO format date for alert open.  |
| `lastEventDate` | string | ISO format date for the last received record.  |

### Errors

None.

## Example

### Request

#### URI

```elm
POST /api/v1/alerts/query
```

#### Payload

```json
[
  {
    "metrics": [
      "loadavg.5m",
      "message"
    ],
    "entity": "nurswgvml007",
    "minSeverity": "MINOR",
    "startDate": "2016-05-07T04:00:00Z",
    "endDate": "2016-06-25T05:00:00Z"
  }
]
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/alerts/query \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{"metrics":["loadavg.5m","message"],"entity":"nurswgvml007","minSeverity":"CRITICAL"}]'
```

### Response

#### Payload

```json
[
    {
        "id": 13,
        "entity": "nurswgvml006",
        "tags": {
            "file_system": "/dev/sdc1",
            "mount_point": "/media/datadrive"
        },
        "repeatCount": 106,
        "textValue": "61.365",
        "metric": "disk_used_percent",
        "severity": "CRITICAL",
        "rule": "disk_low",
        "acknowledged": false,
        "openDate": "2015-05-12T13:39:37Z",
        "openValue": 61.3998,
        "lastEventDate": "2015-05-12T14:57:42Z",
        "value": 61.3651
    }
]
```

## Additional Examples

### Entity Filter

* [Multiple Entities](examples/query/alerts-query-multiple-entity.md)
* [Entity Wildcard](examples/query/alerts-query-entity-wildcard.md)
* [Entity Expression: Name](examples/query/alerts-query-entity-expression-name.md)
* [Entity Expression: Entity Tags](examples/query/alerts-query-entity-expression-entity-tags.md)
* [Entity Expression: Entity Properties](examples/query/alerts-query-entity-expression-entity-properties.md)
* [Entity Group](examples/query/alerts-query-entity-group.md)

### Rule Filter

* [Alerts for Specified Rule](examples/query/alerts-query-defined-rule.md)
* [Multiple Rules for Specified Entity](examples/query/alerts-query-multiple-rules-specified-entity.md)
* [All Rules](examples/query/alerts-query-rules-all-value.md)

### Metric Filter

* [Alerts for Specified Metric](examples/query/alerts-query-defined-metric.md)
* [Multiple Metrics for Specified Entity](examples/query/alerts-query-multiple-metrics-specified-entity.md)
* [All Metrics](examples/query/alerts-query-metrics-all-value.md)
* [Alerts for `message` Command](examples/query/alerts-query-message-commands.md)
* [Alerts for `property` Command](examples/query/alerts-query-property-commands.md)

### Multiple Queries

* [Multiple Queries](examples/query/alerts-query-multiple-queries.md)
* [Multiple Queries for Unknown Entity](examples/query/alerts-query-multiple-queries-unknown-entity.md)

### Time Range

* [Alerts for Last Hour](examples/query/alerts-query-last-hour.md)

### Alerts Severity

* [Alerts for Specified Severities](examples/query/alerts-query-filter-alerts-severities.md)
* [Alerts for Minimum Severity](examples/query/alerts-query-filter-alerts-minseverity.md)

### Filter Status

* [Unacknowledged Alerts](examples/query/alerts-query-filter-unacknowledged-status.md)
* [Acknowledged Alerts](examples/query/alerts-query-filter-acknowledged-status.md)
