# Properties: Query

## Description

Retrieve property records matching specified filters.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/properties/query` | `application/json` |

### Parameters

None.

### Fields

An array of query objects containing the following filtering fields:

#### Property Filter Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| type | string | **[Required]** Property type name. <br>Use `$entity_tags` type to retrieve entity tags. |
| key | object | Object with `name=value` fields, for example `"key": {"file_system": "/"}`<br>Matches records with _exact_ or _partial_ key fields based on the `exactMatch` parameter value.|
| exactMatch | boolean | `key` match operator. _Exact_ match if true, _partial_ match if false. Default: **false**.<br>_Exact_ match selects a record with exactly the same `key` as requested.<br>_Partial_ match selects records with `key` that contains requested fields but may also include other fields.|
| keyTagExpression| string | Expression for matching properties with specified keys or tags.<br>Example: `keys.file_system LIKE '/u*'` or `tags.fs_type == 'ext4'`.<br>Use `lower()` function to ignore case, for example `lower(keys.file_system) LIKE '/u*'`|

* Key values and tag values are case-sensitive.
* Key names and tag names are case-insensitive.

#### Entity Filter Fields

* [**Required**]
* Refer to [entity filter](../filter-entity.md).

#### Date Filter Fields

* [**Required**]
* Refer to [date filter](../filter-date.md).

#### Control Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| limit   | integer | Maximum number of records to be returned. Default: 0.<br>Limit is not applied if the parameter value <= 0. |
| last | boolean | Returns only records with the update time equal to the maximum update time of matched records. Default: false. |
| offset | integer | Exclude records based on difference, in milliseconds, between maximum update time of matched records and update time of the current record. Default: -1 (not applied).<br>If `offset >=0` and the difference exceeds `offset`, the record is excluded from results. <br>`offset=0` is equivalent to `last=true`.|   
| addMeta | boolean | Include metric and entity metadata (field, tags) under the `meta` object in response. Default: false.|

## Response

An array of matching property objects containing the following fields:

### Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| type | string | Property type name. |
| entity |string |  Entity name. |
| key | object | Object containing `name=value` fields that uniquely identify the property record. <br>Example: `{"file_system": "/","mount_point":"sda1"}`|
| tags | object | Object containing `name=value` fields that are not part of the key and contain descriptive information about the property record. <br>Example: `{"fs_type": "ext4"}`. |
| date | string | ISO 8601 date when the property record was last modified. |

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

Queries would return the following records:

```ls
| exactMatch | key                     | match   |
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

Queries would return the following records:

```ls

| offset | match   |
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
POST https://atsd_host:8443/api/v1/properties/query
```

#### Payload

```json
[
    {
      "type": "disk",
      "entity": "nurswgvml007",
      "key": { "file_system": "/" },
      "startDate": "2016-05-25T04:00:00Z",
      "endDate":   "2016-05-25T05:00:00Z"
     }
]
```
#### curl

```elm
curl  https://atsd_host:8443/api/v1/properties/query \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
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
