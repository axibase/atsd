# Entities: List

## Description

Retrieve a list of entities matching the specified filters.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entities` |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `expression` |string|Include entities that match a filter [expression](../../../api/meta/expression.md) consisting of fields and operators. Supported wildcards: `*` and `?`.|
| `minInsertDate` |string|Include entities with `lastInsertDate` equal or greater than `minInsertDate`.<br>The parameter can be specified in ISO-8601 format or using [calendar](../../../shared/calendar.md) keywords.|
| `maxInsertDate` |string|Include entities with `lastInsertDate` less than `maxInsertDate`, including metrics without `lastInsertDate`.<br>The parameter can be specified in ISO format or using [calendar](../../../shared/calendar.md) keywords.|
| `limit` |integer|Maximum number of entities to retrieve, ordered by name.|
| `tags` |string|Comma-separated list of entity tag names to include in the response, for example, `tags=OS,location`.<br>Specify `tags=*` to include all entity tags.<br>Specify `tags=env.*` to include all entity tags starting with `env.`.|

#### Expression

The expression can include all fields listed below except `lastInsertDate`.

Examples:

```java
name LIKE 'nur*'

name NOT LIKE 'aws*' AND lower(label) NOT LIKE 'aws*' AND createdDate > '2017-10-01T00:00:00Z'

name LIKE '*db*' AND lower(tags.function) = 'database'
```

The `lastInsertDate` field should be filtered using `minInsertDate` and `maxInsertDate` parameters for performance reasons.

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `name` | string | Entity name. |
| `label` | string | Entity label. |
| `enabled` | boolean | Enabled status. Incoming data is discarded for disabled entities. |
| `interpolate` | string | Interpolation mode: `LINEAR` or `PREVIOUS`. <br>Used in SQL `WITH INTERPOLATE` clause when interpolation mode is set to `AUTO`, for example, `WITH INTERPOLATE(1 MINUTE, AUTO)`.|
| `timeZone` | string | Time Zone ID, for example `America/New_York` or `EST`.<br>Refer to the [Time Zone](../../../shared/timezone-list.md) table for a list of supported Time Zone IDs.<br>The time zone is applied by date-formatting functions to return local time in entity-specific time zone.|
| `createdDate` | string | Date when this entity was created in ISO-8601 format.|
| `lastInsertDate` | string |Last time, in ISO format, when a value was received by the database for this entity. |
| `tags` | object | Entity tags, as requested with the `tags` parameter. |

### Interpolate

|**Type**|
|:---|
|`LINEAR`|
|`PREVIOUS`|

### Time Precision

|**Precision**|
|:---|
|`MILLISECONDS`|
|`SECONDS`|

## Example 1

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities?timeFormat=iso&limit=2&expression=name%20like%20%27nurs*%27
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities?timeFormat=iso&limit=2&expression=name%20like%20%27nurs*%27 \
  --insecure --include --user {username}:{password} \
  --request GET
```

### Response

```json
 [
    {
        "name": "nurswgdkr002",
        "enabled": true,
        "lastInsertDate": "2015-09-04T15:43:36.000Z",
        "createdDate": "2014-10-03T07:09:54.551Z"
    },
    {
        "name": "nurswgvml001",
        "label": "NURSWGDKR002.corp.axibase.com",
        "enabled": false
    }
]
```

## Example 2

Expression value:

```txt
name!="" or tags.keyName!="" or label!=null or enabled=true or interpolate="LINEAR" or timeZone!=""
```

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities?expression=label!=%22%22%20and%20enabled=true%20and%20interpolate!=%22%22%20and%20timeZone!=%22%22
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities?expression=label!=%22%22%20and%20enabled=true%20and%20interpolate!=%22%22%20and%20timeZone!=%22%22 \
  --insecure --include --user {username}:{password} \
  --request GET
```

### Response

```json
[
  {
    "name": "nurswgdkl001",
    "enabled": true,
    "timeZone": "PST",
    "lastInsertDate": "2016-10-28T08:37:05.000Z",
    "interpolate": "LINEAR",
    "label": "NURswgdkl001"
  }
]
```

## Additional examples

* [List entities by name](./examples/list-entities-by-name.md)
* [List entities by Max Insert Date](./examples/list-entities-by-maxinsertdate.md)
* [List entities by Min Insert Date](./examples/list-entities-by-mininsertdate.md)
* [List all tags for all entities starting with name](examples/list-all-tags-for-all-entities-with-name.md)
* [List entities by name and tag](examples/list-entities-by-tag-containing-hbase.md)
* [List entities for last insert range](examples/list-entities-for-last-insert-range.md)
* [List entities without last insert date](examples/list-entities-without-last-insert-date.md)
