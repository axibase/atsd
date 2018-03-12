# Entity Object Fields

The following fields may be accessed using dot notation, for example `getEntity('nurswgvml007').label` or   `getEntity('nurswgvml007').tags.location`.

|**Name**|**Description** |
|:---|:---|
| created                  | Entity creation timestamp in milliseconds time format.|
| enabled                  | Enabled status. Incoming data for disabled entities is discarded.|
| id                       | Entity ID in the 'Last Insert' table.|
| interpolate              | `LINEAR` / `PREVIOUS`. Interpolation mode supported by the `INTERPOLATE` clause in SQL. |
| label                    | Entity label. |
| lastInsertTime           | Timestamp of the most recent series insert for any metric of the entity.|
| name                     | Entity name. |
| tags                     | Custom attributes to store metadata about the entity.|
| timeZone                 | Timezone in which the entity is located.|     
