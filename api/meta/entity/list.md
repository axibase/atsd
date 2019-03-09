# Entities: list

## Description

Retrieves a list of entities matching the specified filters.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entities` |

### Query Parameters

#### Filter Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `expression` |string|Include entities that match a filter [expression](../../../api/meta/expression.md) consisting of fields and operators.<br>Supported wildcards: `*` and `?`.<br>Example: `name LIKE 'nur*' or tags.app = 'db'`|
| `minInsertDate` |string|Include entities with `lastInsertDate` equal or greater than `minInsertDate`.<br>[ISO format](../../../shared/date-format.md#supported-formats) date or [calendar](../../../shared/calendar.md) keyword, for example `2017-10-01T00:00:00Z` or `current_day`.|
| `maxInsertDate` |string|Include entities with `lastInsertDate` less than `maxInsertDate`, including entities without `lastInsertDate`.<br>[ISO format](../../../shared/date-format.md#supported-formats) date or [calendar](../../../shared/calendar.md) keyword, for example `2017-10-01T00:00:00Z` or `now - 1*DAY`.|

#### Control Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `tags` |string|Comma-separated list of entity tag names to include in the response, for example: `app,OS,location`.<br>Specify `*` wildcard to include all entity tags.<br>Use wildcard as part of name pattern, for example `loc*`, to include matching entity tags.<br>Default: no tags are included.|
| `addInsertTime` | boolean| Include calculated field [`lastInsertDate`](#fields), which requires additional processing, in the response.<br>The default value is inherited from the `default.addInsertTime` setting on the [**Settings > Server Properties**](../../../administration/server-properties.md) page which is set to `true` by default.|
| `limit` |integer|Maximum number of entities to retrieve, ordered by name. Default: `0` (unlimited).|

#### Expression

The [expression](../../../api/meta/expression.md) can include all [fields](#fields) listed below except the calculated `lastInsertDate` field that can be filtered using `minInsertDate` and `maxInsertDate` parameters for performance reasons.

Examples:

* Retrieve entities with name starting with `nur`.

```javascript
name LIKE 'nur*'
```

* Retrieve entities with label not starting with `aws` and created after '2017-Oct-01'.

```javascript
lower(label) NOT LIKE 'aws*' AND createdDate > '2017-10-01T00:00:00Z'
```

* Retrieve entities with tag `function` equal to `database` (case insensitive comparison).

```javascript
lower(tags.function) = 'database'
```

* Retrieve entities with non-empty `function` tag.

```javascript
tags.function != ''
```

* Retrieve entities without any tags and name consisting of 64 characters.

```javascript
tags.size() == 0 && name.length() == 64
```

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `name` | string | Entity name. |
| `label` | string | Entity label. |
| `enabled` | boolean | Enabled status. Incoming data is discarded for disabled entities. |
| `interpolate` | string | Interpolation mode: `LINEAR` or `PREVIOUS`. <br>Used in SQL `WITH INTERPOLATE` clause when interpolation mode is set to `AUTO`, for example, `WITH INTERPOLATE(1 MINUTE, AUTO)`.|
| `timeZone` | string | Time Zone ID, for example EST.<br>Refer to the [Time Zone](../../../shared/timezone-list.md) table for a list of supported Time Zone IDs.<br>The time zone is applied by date-formatting functions to return local time in entity-specific time zone.|
| `createdDate` | string | Date of entity creation in [ISO format](../../../shared/date-format.md#supported-formats).|
| `lastInsertDate` | string |Last time a value is received by the database for this entity in [ISO format](../../../shared/date-format.md#supported-formats). |
| `tags` | object | Entity tags, as requested with the `tags` parameter. |

### Interpolate

|**Type**|
|:---|
|`LINEAR`|
|`PREVIOUS`|

## Example 1

### Request

#### URI

```elm
GET /api/v1/entities?timeFormat=iso&limit=2&expression=name%20LIKE%20%27nurs*%27
```

#### Payload

None.

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/entities?timeFormat=iso&limit=2&expression=name%20LIKE%20%27nurs*%27" \
  --insecure --include --user {username}:{password}
```

### Response

```json
[
  {
    "name": "nurswgdkr002",
    "enabled": true,
    "lastInsertDate": "2018-09-04T15:43:36.000Z",
    "createdDate": "2014-10-03T07:09:54.551Z"
  },
  {
    "name": "nurswgvml001",
    "label": "NURSWGDKR002.corp.example.org",
    "enabled": false
  }
]
```

## Example 2

Expression value:

```txt
name != '' or tags.keyName != '' or label != null or enabled = true or interpolate = 'LINEAR' or timeZone != ''
```

### Request

#### URI

```elm
GET /api/v1/entities?expression=label!=%22%22%20and%20enabled=true%20and%20interpolate!=%22%22%20and%20timeZone!=%22%22
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities?expression=label!=%22%22%20and%20enabled=true%20and%20interpolate!=%22%22%20and%20timeZone!=%22%22 \
  --insecure --include --user {username}:{password}
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

* [Filter entities by name](./examples/list-entities-by-name.md)
* [Retrieve entities with all tags filtered by entity name](examples/list-all-tags-for-all-entities-with-name.md)
* [Filter entities by name and tag value](examples/list-entities-by-tag-containing-hbase.md)
* [Filter entities by maximum insert date](./examples/list-entities-by-maxinsertdate.md)
* [Filter entities by minimum insert date](./examples/list-entities-by-mininsertdate.md)
* [Filter entities for last insert date range](examples/list-entities-for-last-insert-range.md)
* [Retrieve entities without last insert date](examples/list-entities-without-last-insert-date.md)
