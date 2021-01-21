# Entity: get

## Description

Retrieves fields and tags describing the specified entity.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entities/{entity}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `entity` | **[Required]** Entity name. |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `version` |string|Return entity tags and fields at the change date, specified in [ISO format](../../../shared/date-format.md#supported-formats). |

## Response

### Fields

Refer to Response Fields in [Entities: List](list.md#fields)

## Example

### Request

#### URI

```elm
GET /api/v1/entities/nurswgvml006
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml007 \
 --insecure --include --user {username}:{password}
```

### Response

```json
{
  "name": "nurswgvml007",
  "enabled": true,
  "timeZone": "US/Eastern",
  "lastInsertDate": "2021-01-21T13:19:30.000Z",
  "tags": {
    "environment": "production",
    "os": "Linux",
    "loc_area": "dc1",
    "ip": "10.102.0.6",
    "location": "SVL",
    "monitor.env": "Production",
    "cpu_count": "1"
  },
  "interpolate": "PREVIOUS",
  "label": "NURswgvml007",
  "versionDate": "2020-04-08T06:09:22.813Z"
}
```

## Additional Examples

```elm
GET /api/v1/entities/nurswgvml007?2020-04-01T06:00:00Z
```

```json
{
  "name": "nurswgvml007",
  "enabled": true,
  "lastInsertDate": "2021-01-21T13:21:00.000Z",
  "tags": {},
  "versionDate": "2016-08-15T08:28:55.262Z"
}
```
