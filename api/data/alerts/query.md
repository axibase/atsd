# Alerts: Query

## Description

Retrieve a list of **open** alerts matching specified fields.

## Request

### Path

```elm
/api/v1/alerts/query
```

### Method

```
POST 
```

### Headers

|**Header**|**Value**|
|:---|:---|
| Content-Type | application/json |

### Parameters

None.

## Fields

An array of query objects containing the following filtering fields:

### Alert Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| rules       | array | Array of rules which produced the alerts.        |
| metrics     | array | Array of metric names for which the alerts were created. |
| severities  | array | Array of [severity code or names](/api/data/severity.md)   |
| minSeverity |  string   | Minimal [code or name](/api/data/severity.md) severity filter.  |

> Note that `tags` filter is not supported.

### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

### Date Filter Fields

* [**Required**]
* Date conditions are applied to alert `openDate`.
* Refer to [date filter](../filter-date.md).

## Response 

An array of matching alert objects containing the following fields:

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| id    | integer | Alert id.|
| acknowledged | boolean | Acknowledgement status.|
| entity | string | Entity name. |
| metric | string | Metric name.  |
| rule | string | Rule name. |
| severity  | string | [Severity](/api/data/severity.md) code.  |
| tags | object | Object containing `name=value` pairs, for example `tags: {"path": "/", "name": "sda"}` |
| repeatCount | integer | Number of times when the expression evaluated to true sequentially.  |
| textValue | string | Text value.  |
| value | double | Last numeric value received. |
| openValue | double | First numeric value received.  |
| openDate | string | ISO 8601 date when the alert was open.  |
| lastEventDate | string | ISO 8601 date when the last record was received.  |

### Errors

None.

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/alerts/query
```

#### Payload

```json
[{
	"metrics": ["loadavg.5m", "message"],
	"entity": "nurswgvml007",
	"minSeverity": 4
}]
```

#### curl

```elm
curl https://atsd_host:8443/api/v1/alerts/query \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '[{"metrics":["loadavg.5m","message"],"entity":"nurswgvml007","minSeverity":4}]'
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
        "severity": 6,
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
* [Alerts for Defined Rule](examples/query/alerts-query-defined-rule.md)
* [Multiple Ruless for Specified Entity](examples/query/alerts-query-multiple-rules-specified-entity.md)
* [Rules: All Value](examples/query/alerts-query-rules-all-value.md)

### Metric Filter
* [Alerts for Defined Metric](examples/query/alerts-query-defined-metric.md)
* [Multiple Metrics for Specified Entity](examples/query/alerts-query-multiple-metrics-specified-entity.md)
* [Metrics: All Value](examples/query/alerts-query-metrics-all-value.md)
* [Alerts for Message Commands](examples/query/alerts-query-message-commands.md)
* [Alerts for Property Commands](examples/query/alerts-query-property-commands.md)

### Time Range
* [Alerts for Last Hour](examples/query/alerts-query-last-hour.md)

### Alerts Severity
* [Filter Alerts for Severities](examples/query/alerts-query-filter-alerts-severities.md)
* [Filter Alerts for minSeverity](examples/query/alerts-query-filter-alerts-minseverity.md)

### Filter Status
* [Filter Alerts for Unacknowledged Status](examples/query/alerts-query-filter-unacknowledged-status.md)
* [Filter Alerts for Acknowledged Status](examples/query/alerts-query-filter-acknowledged-status.md)




