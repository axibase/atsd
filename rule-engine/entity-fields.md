# Entity Object Fields

The following fields can be accessed using dot notation, for example `getEntity('nurswgvml007').label` or `getEntity('nurswgvml007').tags.location`.

|**Name**|**Type**|**Description** |
|:---|:--|:---|
| `name` | string |  Entity name. |
| `label`        | string   | Entity label. |
| `displayName` | string | Entity label, or entity name if label is empty. |
| `id`           | string   | Internal entity identifier.|
| `enabled`      | boolean  | Enabled status. Incoming data for disabled entities is discarded.|
| `timeZone` | string | Time zone in which the entity is located.|
| `interpolate`  | string   | `LINEAR` / `PREVIOUS`. Interpolation mode supported by the `INTERPOLATE` clause in SQL. |
| `creationTime` | DateTime | Entity creation time as Unix time with millisecond precision.|
| `lastInsertTime` | DateTime | Timestamp of the most recent series insert for any metric of the entity.|
| `tags` | map | Custom attributes to store metadata about the entity.|