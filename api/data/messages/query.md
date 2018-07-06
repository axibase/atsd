# Messages: query

## Description

Retrieves message records for the specified filters.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/v1/messages/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following filtering fields:

#### Message Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
|`type`       |  string   | Message type. |
|`source`       |  string   | Message source. |
|`tags`          | object  | Object with `name=value` fields.<br>Matches records that contain tags specified in the request object.<br>The matching records can include additional tags, not listed in the object. |
|`severity`     |  string   | Severity [name](../../../api/data/severity.md).  <br>Matches records with the specified severity.|
|`severities`   |  array   | An array of severity [codes or names](../../../api/data/severity.md).  <br>Matches records with one of the specified severities.<br>Array elements can be specified as a string or as a number.|
|`minSeverity`  |  string   | Minimum [code or name](../../../api/data/severity.md) severity filter. <br>Can be specified as a string or as a number. |

* `severity`, `minSeverity`, and `severities` values are case-insensitive.

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

#### Date Filter Fields

* [**Required**]
* Refer to [date filter](../filter-date.md).

#### Result Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `limit`   | integer | Maximum number of records to be returned. Default: 1000.<br>Limit is not applied if the parameter value <= 0. |

## Response

An array of matching message objects containing the following fields:

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
|`entity` | string | Entity name. |
|`type` | string | Message type. |
|`source` | string | Message source. |
|`severity` | string | Message [severity](../../../api/data/severity.md) name. |
|`tags` | object |  Object containing `name=value` fields, for example `tags: {"path": "/", "name": "sda"}`. |
|`message` | string | Message text. |
|`date` | string | ISO 8601 date of message record creation. |

### Errors

None.

## Example

### Request

#### URI

```elm
POST /api/v1/messages/query
```

#### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "limit": 5,
    "endDate": "now",
    "interval": {
      "count": 30,
      "unit": "MINUTE"
    }
  }
]
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/messages/query \
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
    "type": "logger",
    "source": "com.axibase.tsd.service.entity.findentitybyexpressionserviceimpl",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "applicationScheduler-5",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Expression entity group 'scollector-linux' updated",
    "date": "2016-05-25T17:05:00Z"
  },
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "source": "com.axibase.tsd.web.csv.csvcontroller",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "qtp490763067-195",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Start processing csv, config: nginx-status",
    "date": "2016-05-25T17:04:01Z"
  }
]
```

## Java Example

* [Messages Query](examples/DataApiMessagesQueryExample.java)

## Python Example

* [Querying Messages](https://github.com/axibase/atsd-api-python#querying-messages)

## Additional Examples

* [Query all types and sources for entity](examples/query/messages-query-all-types.md)
* [Query specified tags](examples/query/messages-query-tags.md)
* [Query that contain the specified Tag](examples/query/messages-query-contain-specifield-tags.md)
* [Query for min/max ISO date](examples/query/messages-query-min-max-iso-date.md)
* [Query with fractional interval](examples/query/messages-query-fractional-interval.md)
* [Query with limit](examples/query/messages-query-limit.md)
* [Multiple entities for specified type](examples/query/messages-query-multiple-entities-specified-type.md)
* [Filter messages for specified severity](examples/query/messages-query-filter-messages-specified-severity.md)
* [Filter messages for minimum severity](examples/query/messages-query-filter-messages-minimum-severity.md)
