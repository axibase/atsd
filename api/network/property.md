# `property` Command

## Description

Inserts a property record with specified type, keys, and tags for a given entity.

Entity, property type, and property keys (`k:` fields) form a composite primary key of the property record in the database, whereas tags (`v:` fields) are stored as additional attributes.

When a property record is inserted into the database, it overwrites an existing record with the same composite primary key: **entity+type[+key]**.

## Syntax

```bash
property e:${entity} t:${type} k:${key-1}=${value} k:${key-2}=${value} v:${tag-1}=${text} v:${tag-2}=${text} d:${time}
```

* Entity name, property type, key names, and tag names are case-**insensitive** and are converted to lower case when stored.
* Key values and tag values are case-**sensitive** and are stored as submitted.
* Tag names can duplicate key names, for example `{tag-1}` can be equal to `{key-1}`.
* At least one tag is required, for example, command `property e:e1 t:t1 k:k1=v1` is not valid.
* Tags with empty values are ignored, for example `t2` is ignored in command `property e:e1 t:t1 v:t1=v1 v:t2=""`.

```ls
# input command
property e:nurSWG t:DISK-config k:FS_type=NFS v:Initiator=Pre-fetch
# stored record
property e:nurswg t:disk-config k:fs_type=NFS v:initiator=Pre-fetch
```

## Reserved Property Types

| **Type** | **Description** |
|:---|:---|
| `$entity_tags` | Insert [entity tags](../../api/meta/entity/list.md#fields) for the specified entity from the included key and tag fields. |

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| `e`         | string           | **[Required]** Entity name. |
| `t`         | string           | **[Required]** Property type. |
| `k`         | string           | Property key name and text value. Multiple. |
| `v`         | string           | **[Required]** Property tag name and text value. At least one required. |
| `s`         | integer          | Unix time in seconds. |
| `ms`        | integer          | Unix time in milliseconds. |
| `d`         | string           | Time in [ISO format](../../shared/date-format.md). |

> If time fields are omitted, the record is inserted with the current server time.

### ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```elm
; entity, type and at least one tag is required
command = "property" MSP entity type *(MSP key) 1*(MSP tag) [MSP time]
entity = "e:" NAME
type = "t:" NAME
key = "k:" NAME "=" VALUE
tag = "v:" NAME "=" VALUE
time = time-millisecond / time-second / time-iso
time-millisecond = "ms:" POSITIVE_INTEGER
time-second = "s:" POSITIVE_INTEGER
time-iso = "d:" ISO_DATE
```

## Limits

Refer to [limits](README.md#command-limits).

## Examples

```ls
property e:server-001 t:disk-config k:mount_point=/ k:name=sda1 v:size_gb=192 v:fs_type=nfs
```

```ls
property e:server-001 t:operating_system v:type=Linux d:2015-03-04T12:43:20Z
```

```ls
property e:server-001 t:$entity_tags v:location=SVL d:2015-03-04T12:43:20Z
```
