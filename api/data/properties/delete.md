# Properties: Delete

## Description

Deletes property records that match specified filters.

### Delete Markers

Due to the specifics of the underlying storage technology, the records deleted with this method are not instantly removed from the disk.

Instead, the records are masked with a so called `DELETE` marker timestamped at the delete request time. The `DELETE` marker hides all data rows that were recorded before the `DELETE` marker.

The actual deletion from the disk, which removes both the `DELETE` marker as well as earlier records, occurs in the background as part of a scheduled procedure called `major compaction`.

Properties that are re-inserted before the `major compaction` is completed with timestamps earlier than the `DELETE` marker will not be visible.

To identify pending `DELETE` markers for a given type and entity, run:

```sh
echo "scan 'atsd_properties', {'LIMIT' => 3, RAW => true, FILTER => \"PrefixFilter('\\"prop_type\\":\\"entity_name\\"')\"}" | /opt/atsd/hbase/bin/hbase shell
```

The same behavior applies to properties deleted when the entire entity is removed, except in this case the `DELETE` marker is timestamped with the `Long.MAX_VALUE-1` time of `9223372036854775806`.

To remove these markers, run `major compaction` on the `atsd_properties` table ahead of schedule.

```sh
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
| `type` | string | [**Required**] Property type name. <br>This method does not allow removal of the reserved `$entity_tags` type.|
| `entity` | string | [**Required**] Entity name. <br>Set entity to wildcard `*` to delete records for all entities.|
| `startDate` | string | [**Required**] ISO 8601 date or [calendar](../../../shared/calendar.md) keyword. <br>Delete records updated at or after the specified time. |
| `endDate` | string | [**Required**] ISO 8601 date or [calendar](../../../shared/calendar.md) keyword.<br>Delete records updated before the specified time. |
| `key` | object | Object with `name=value` fields, for example `{"file_system": "/"}`.<br>Deletes records with _exact_ or _partial_ key fields based on the `exactMatch` parameter below.|
| `exactMatch` | boolean | If `exactMatch` is `true`, only one record with exactly the same `key` as in the request is deleted.<br>If `false`, all records with key that **contains** fields in the request `key` (but may also include other fields) are deleted.<br>If `exactMatch` is `false` and no `key` is specified, all records for the specified type and entity are deleted.<br>Default value: `true`.|

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

The table below illustrates which records will be deleted (the `result` column) for the corresponding `exactMatch` and `key` parameters on the left.

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

## Example

### Request

#### URI

```elm
POST /api/v1/properties/delete
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

```bash
curl https://atsd_hostname:8443/api/v1/properties/delete \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{ "type":"disk", "entity":"nurswgvml007", "key":{"file_system":"/","name":"sda1"} }]'
```
