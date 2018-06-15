# Entity Group: Get Entities

## Description

Retrieves a list of entities that are members of the specified entity group and are matching the specified filter conditions.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entity-groups/{group}/entities` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| group | **[Required]** Entity group name. |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `expression` |string|Expression to include entities by name or by entity tags. Use the `name` field for entity name. The wildcard `*` is supported.|
| `minInsertDate` |string|Include entities with last insert date at or greater than specified time. <br>`minInsertDate` can be specified in ISO format or using [calendar](../../../shared/calendar.md) keywords.|
| `maxInsertDate` |string|Include entities with last insert date less than specified time.<br>`maxInsertDate` can be specified in ISO format or using [calendar](../../../shared/calendar.md) keywords.|
| `limit` |integer|Maximum number of entities to retrieve, ordered by name.|
| `tags` |string|Comma-separated list of entity tag names to include in the response, for example, `tags=OS,location`.<br>Specify `tags=*` to include all entity tags.<br>Specify `tags=env.*` to include all metric tags starting with `env.`.|
| `addInsertTime` | boolean| The parameter controls whether [`lastInsertDate`](../entity/list.md#fields) field should be included in the response.<br>Default value can be defined by the `default.addInsertTime` setting at the **Settings > Server Properties** page.|

## Response

### Fields

Refer to fields specified in [Entity List](../../../api/meta/entity/list.md#fields) method.

## Example

### Request

#### URI

```elm
GET /api/v1/entity-groups/nur-entities-name/entities?tags=*&limit=3
```

#### Payload

None.

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/entity-groups/nur-entities-name/entities?tags=*&limit=3" \
  --insecure --include --user {username}:{password}
```

### Response

```json
[
    {
        "name": "atsd_hostname",
        "enabled": true,
        "tags": {}
    },
    {
        "name": "nurswgvml003",
        "enabled": true,
        "lastInsertDate": "2015-09-04T15:43:36.000Z",
        "tags": {
            "app": "Shared NFS/CIFS disk, ntp server",
            "ip": "10.102.0.2",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml004",
        "enabled": true,
        "tags": {}
    }
]
```

## Additional examples
