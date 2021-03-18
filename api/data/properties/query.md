# Properties: query

## Description

Retrieves property records for the specified filters including type, entity, key, and time range.

Basic example:

```json
[{
  "type": "disk",
  "entity": "nurswgvml007",
  "startDate": "now - 1 * DAY",
  "endDate": "now",
}]
```

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/v1/properties/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following filtering fields:

#### Property Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `type` | string | **[Required]** Property type name. <br>Use `$entity_tags` type to retrieve entity tags. |
| `key` | object | Object with `name=value` fields, for example `"key": {"file_system": "/"}`<br>Matches records with **exact** or **partial** key fields based on the `exactMatch` parameter value.|
| `exactMatch` | boolean | `key` match operator. **Exact** match if `true`, **partial** match if `false`.<br>Default: `false`.<br>**Exact** match selects a record with exactly the same `key` as requested.<br>**Partial** match selects records with `key` that contains requested fields but can also include other fields.|
| `keyTagExpression`| string | Expression for matching properties with specified keys or tags.<br>Example: `keys.file_system LIKE '/u*'` or `tags.fs_type == 'ext4'`.<br>Use `lower()` function to ignore case, for example `lower(keys.file_system) LIKE '/u*'`|

* Key values and tag values are case-sensitive.
* Key names and tag names are case-insensitive.

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

#### Date Filter Fields

* [**Required**]
* Refer to [date filter](../filter-date.md).

#### Record Filter

The filter applies if `exactMatch` is `false` and multiple records matched the query. The filter compares the timestamp of the record with the maximum timestamp of all matched records.

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `last` | boolean | Includes records with the timestamp equal the maximum timestamp of matched records.<br>Default: `false`.|
| `offset` | integer | Includes records based on difference, in milliseconds, between maximum timestamp of matched records and timestamp of the current record.<br>The record is included in results if its timestamp is greater than or equal maximum timestamp less the `offset`.<br>Offset of `0` is equivalent to `last=true`.<br>Default: `-1` (not applied).|

#### Field Filter

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `merge` | boolean | Returns all tag values within the record.<br>If set to `false`, only tag values with update time equal to the row timestamp are included.<br>Default: `false`.|

#### Control Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `limit`   | integer | Maximum number of rows returned.<br>Default: `0` (no limit).<br>The parameter is ignored if the value is negative or `0`. |
| `addMeta` | boolean | Include metric and entity metadata fields under the `meta` object in response.<br>Default: `false`.|

## Response

An array of matching property objects containing the following fields:

### Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `type` | string | Property type name. |
| `entity` |string |  Entity name. |
| `key` | object | Object containing `name=value` fields that uniquely identify the property record. <br>Example: `{"file_system": "/","mount_point":"sda1"}`|
| `tags` | object | Object containing `name=value` fields that are not part of the key and contain descriptive information about the property record. <br>Example: `{"fs_type": "ext4"}`. |
| `date` | string | Date of last modified property record in [ISO format](../../../shared/date-format.md#supported-formats). |

## Key Match Example

Assuming property records A,B,C, and D exist:

```ls
| record | type   | entity | key-1 | key-2 |
|--------|--------|--------|-------|-------|
| A      | type-1 | e-1    | val-1 | val-2 |
| B      | type-1 | e-2    | val-1 |       |
| C      | type-1 | e-3    |       | VAL-3 |
| D      | type-1 | e-4    |       |       |
```

The table below illustrates which records are returned (the `result` column) for the corresponding `exactMatch` and `key` parameters on the left.

```ls
| exactMatch | key                     | result  |
|------------|-------------------------|---------|
| true       |                         | D       |
| false      |                         | A;B;C;D |
| true       | key-1=val-1             | B       |
| false      | key-1=val-1             | A;B     |
| true       | key-1=val-1;key-2=val-2 | A       |
| false      | key-1=val-1;key-2=val-2 | A       |
| false      | key-2=val-3             |         |
| false      | key-2=VAL-3             | C       |
```

## Offset Example

Assuming property records A,B,C, and D exist and time represents their update time in milliseconds:

```ls
| record | type   | entity | key-1 | time |
|--------|--------|--------|-------|------|
| A      | type-1 | e-1    | val-1 |  100 |
| B      | type-1 | e-2    | val-2 |  200 |
| C      | type-1 | e-3    | val-1 |  200 |
| D      | type-1 | e-4    | val-2 |  150 |
```

max(time) = 200

The table below illustrates which records are returned (the `result` column) for the `offset` parameter on the left.

```ls
| offset | result  |
|     -1 | A;B;C;D | Offset filter is not applied.
|      0 | B;C     | Only records with update time = max(time) are included.
|      1 | B;C     |
|     50 | B;C;D   | D time difference = max(time)-150=50. D is included because difference is <= offset of 50.
|    200 | A;B;C;D | Time difference for all records is <= offset of 200. All records included.
```

## Example

### Request

#### URI

```elm
POST /api/v1/properties/query
```

#### Payload

```json
[{
  "type": "disk",
  "entity": "nurswgvml007",
  "key": { "file_system": "/" },
  "startDate": "2016-05-25T04:00:00Z",
  "endDate":   "2016-05-25T05:00:00Z"
}]
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/properties/query \
  -k --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{"type":"disk","entity":"nurswgvml007","key":{"file_system":"/"},"startDate":"2016-05-25T04:00:00Z","endDate":"2016-05-25T05:00:00Z"}]'
```

### Response

```json
[
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "file_system": "/",
           "mount_point": "sda1"
       },
       "tags": {
           "fs_type": "ext4"
       },
       "date": "2016-05-25T04:15:00Z"
   }
]
```

## Java Example

* [Properties Query](examples/DataApiPropertiesQueryExample.java)

## Additional Examples

### Filters

* [Get Records for Type](examples/properties-for-type-disk.md)
* [Get Records for Type and Key](examples/properties-for-type-disk-with-key.md)
* [Get Records for Type and Multiple Keys](examples/properties-for-type-process-with-multiple-keys.md)
* [Get Records for Type and Key Expression](examples/properties-for-type-using-expression.md)
* [Get Entity Tags](examples/query-retrieve-entity-tags.md)
* [Get Entity Tags for Entity Group](examples/entity-tags-for-entitygroup.md)

### Control Fields

* [Entity and Metric Metadata](examples/query-metadata.md)
