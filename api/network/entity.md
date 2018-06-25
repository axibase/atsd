# `entity` Command

## Description

Creates or updates fields and tags of the specified entity.

If no entity matches the specified name, a new entity is created automatically.

## Syntax

```bash
entity e:${entity} b:${enabled} l:${label} i:${interpolate} z:${timezone} t:${tag-1}=${text} t:${tag-2}=${text}
```

* Entity name and tag names are case-insensitive and are converted to lower case when stored.
* Label and tag values are case-sensitive and are stored as submitted.
* Other fields are case-insensitive.
* Tag values must not be empty.
* Existing entity tags and fields that are not specified in the command are left unchanged.
* To remove the label or an entity tag or to reset the Time Zone ID or Interpolate fields, set the value to a double-quoted empty string.

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| e         | string           | **[Required]** Entity name. |
| b         | boolean          | Enabled status. If the entity is disabled, new data received for this entity is discarded. |
| l         | string           | Label. |
| i         | string           | Interpolation mode: linear, previous. Default is none. |
| z         | string           | Time Zone ID, for example EST.<br>Refer to [Time Zone](../../shared/timezone-list.md) table for a list of supported Time Zone IDs.<br>The time zone is applied by date-formatting functions to return local time in entity-specific time zone.<br>To reset the time zone to the default value, specify it as a double-quoted empty string `z:""`. |
| t         | string           | Entity tag name and text value. Multiple. |

### ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```elm
command = "entity" MSP entity [MSP enabled] [MSP label] [MSP interpolate] [MSP timezone] 1*(MSP tag)
entity = "e:" NAME
enabled = "b:" BOOLEAN
label  = "l:" VALUE
interpolate = "i:" ("linear" / "previous" / DQUOTE DQUOTE)
timezone = "z:" (TIMEZONE / DQUOTE DQUOTE)
tag = "t:" NAME "=" VALUE
```

## Examples

```ls
entity e:nurswgvml007 z:PST i:previous t:location=SVL t:environment=production
```

```ls
entity e:nurswgvml007 b:false l:NURSWGVML007 t:location=SVL t:environment=""
```
