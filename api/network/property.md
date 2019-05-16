# `property` Command

## Description

Inserts a property record with specified type, keys, and tags for a given entity.

The primary key of the property record consists of the entity, property type, and property keys (`k:` fields). The tags (`v:` fields) are stored as additional attributes.

When inserted into the database, the property record overwrites specific tags of the stored record with the same primary key: **entity+type[+key]**.

## Syntax

```bash
property e:${entity} t:${type} k:${key-1}=${value} k:${key-2}=${value} v:${tag-1}=${text} v:${tag-2}=${text} d:${time}
```

* Entity name, property type, key names, and tag names are case-**insensitive** and are converted to lower case when stored.
* Key values and tag values are case-**sensitive** and are stored as submitted.

```ls
# Input command
property e:nurSWG t:DISK-config k:FS_type=NFS v:Initiator=Pre-fetch

# Stored record after names are normalized
property e:nurswg t:disk-config k:fs_type=NFS v:initiator=Pre-fetch
```

## Empty Values

* At least one non-empty tag is required. For example, commands  `property e:e1 t:t1 k:k1=v1` and `property e:e1 t:t1 v:t1=""` are invalid.
* Empty tags are not stored.
* Empty tags delete stored tags, if present, with the same name.

```ls
# Stored record
property e:nurswg t:cpu v:status=Err v:start_time=12:05 v:message=NaN

# Property command
property e:nurswg t:cpu v:status=OK  v:message="" v:conn_time=12:10

# Modified record
property e:nurswg t:cpu v:status=OK  v:start_time=12:05 v:conn_time=12:10
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

:::tip Note
If time fields are omitted, the record is inserted with the current server time.
:::

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
property e:server-001 t:operating_system v:type=Linux d:2018-03-04T12:43:20Z
```

```ls
property e:server-001 t:$entity_tags v:location=SVL d:2018-03-04T12:43:20Z
```

Delete the `fs_type` tag.

```ls
property e:server-001 t:disk-config k:mount_point=/ k:name=sda1 v:fs_type=""
```
