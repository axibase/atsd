# Entity Object Fields

The following fields may be accessed using dot notation, for example `getEntity('nurswgvml007').tags`.

|**Name**|**Description** |
|:---|:---|
| created                  | Entity creation timestamp in milliseconds time format.|
| enabled                  | Enabled status. Incoming data for disabled entities is discarded without persisting and processing in the rule engine.|
| id                       | Entity ID in _Last Insert_ table.|
| interpolate              | Interpolation mode: `LINEAR` or `PREVIOUS`. <br>Used in SQL `WITH INTERPOLATE` clause when interpolation mode is set to `AUTO`, for example, `WITH INTERPOLATE(1 MINUTE, AUTO)`.|
| label                    | User-friendly entity label. |
| lastInsertTime           | Timestamp of the most recent series insert for any metric of the entity.|
| name                     | Unique entity name. |
| tags                     | Custom attributes to store metadata about the entity.|
| timeZone                 | Timezone in which the entity is located.|     
