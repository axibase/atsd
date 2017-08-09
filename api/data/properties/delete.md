# Properties: Delete

## Description

Delete property records that match specified filters.

### Delete Markers

Due to the specifics of the underlying storage technology, the records deleted with this method are not instantly removed from the disk. 

Instead, the records are masked with a so called `DELETE` marker timestamped at the delete request time. The `DELETE` marker hides all data rows that were recorded before the `DELETE` marker.

The actual deletion from the disk, which removes both the `DELETE` marker as well as earlier records, occurs in the background as part of a scheduled procedure called `major compaction`.

Properties that are re-inserted before the `major compaction` is completed with timestamps earlier than the `DELETE` marker will not be visible.

To identify pending `DELETE` markers for a given type and entity, run the following command:

```bash
echo "scan 'atsd_properties', {'LIMIT' => 3, RAW => true, FILTER => \"PrefixFilter('\\"prop_type\\":\\"entity_name\\"')\"}" | /opt/atsd/hbase/bin/hbase shell
```

The same behavior applies to properties deleted when the entire entity is removed, except in this case the `DELETE` marker is timestamped with the `Long.MAX_VALUE-1` time of `9223372036854775806`.

To remove these markers, run `major compaction` on the `atsd_properties` table ahead of schedule.

```bash
echo "major_compact 'atsd_properties'" | /opt/atsd/hbase/bin/hbase shell
```

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/properties/delete` | `application/json` |

### Parameters

None.

### Fields

An array of objects containing fields for filtering records for deletion.

| **Field**  | **Type** | **Description**  |
|:---|:---|:---|
| type | string | [**Required**] Property type name. <br>This method does not allow removal of the reserved `$entity_tags` type.|
| entity | string | [**Required**] Entity name. <br>Set entity to `*` to delete records for all entities.|
| startDate | string | [**Required**] ISO 8601 date or [endtime](../../../end-time-syntax.md) keyword. <br>Delete records updated at or after the specified time. |
| endDate | string | [**Required**] ISO 8601 date or [endtime](../../../end-time-syntax.md) keyword.<br>Delete records updated before the specified time. |
| key | object | Object with `name=value` fields, for example `{"file_system": "/"}`.<br>Deletes records with _exact_ or _partial_ key fields based on the `exactMatch` parameter below.|
| exactMatch | boolean | `key` match operator. _Exact_ match if true, _partial_ match if false. Default: **true**.<br>_Exact_ match deletes a record with exactly the same `key` as requested.<br>_Partial_ match deletes records with key that contains requested fields but may also include other fields.|

* Key and tag names are case-insensitive.
* Key and tag values are case-sensitive.

## Response

### Fields

None.

### Errors

None.

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

Queries would delete the following record:

```ls
| exactMatch | key                     | delete  | 
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

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/properties/delete
```

#### Payload

```json
[{
    "type":"disk",
    "entity":"nurswgvml007",
    "key":{"file_system":"/","name":"sda1"}
},{
    "type":"disk",
    "entity":"nurswgvml006",
    "exactMatch": false
}]
``` 

#### curl

``` elm
curl https://atsd_host:8443/api/v1/properties/delete \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '[{ "type":"disk", "entity":"nurswgvml007", "key":{"file_system":"/","name":"sda1"} }]'
```
