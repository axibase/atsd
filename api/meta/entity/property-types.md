# Entity: Property Types

## Description

Retrieve a list property types for the entity.

## Request

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entities/{entity}/property-types` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

### Query Parameters

| **Parameter** | **Type** | **Description** |
|:---|:---|:---|
| `minInsertDate` | string | Include property types with last collection date at or after the specified date. <br>`minInsertDate` can be specified in ISO format or using the [calendar](../../../shared/calendar.md) keywords. |

## Response

An array of strings.

### Fields

| **Name**       | **Description** |
|:---|:---|
| `type` | Property type name |

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities/nurswgvml007/property-types
```

#### Payload

None.

#### curl

```elm
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml007/property-types \
  --insecure --include --user {username}:{password} \
  --request GET
```

### Response

```json
[
   "configuration",
   "system",
   "process"
]
```

## Additional examples
