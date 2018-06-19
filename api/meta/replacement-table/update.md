# Replacement Table: Update

## Description

Updates records and metadata of the specified replacement table.

Unlike the [replace method](create-or-replace.md), records and metadata that are **not** specified by the request remain unchanged.

Similarly, fields set to `null` remain unchanged.

If content type is `json`, request updates both metadata and records. If content type is `csv`, request updates only records.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| PATCH | `/api/v1/replacement-tables/csv/{name}` | `text/csv` |
| PATCH | `/api/v1/replacement-tables/json/{name}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|

### Fields

Refer to Fields specified in the [Replacement Table: Get](get.md#fields) method.

The `name` field specified in the payload must match the one specified in the path or not be provided.

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PATCH /api/v1/replacement-tables/json/pi_pids
```

#### Payload

```json
{
  "author": "Eve",
  "keys": {
      "0": "UNKNOWN",
       "-65536": "UNKNOWN",
       "-65537": "UNKNOWN",
       "-196608": "UNKNOWN",
       "-196609": "UNKNOWN"
  }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/pi_pids \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data '{"author":"Eve","keys":{"0": "UNKNOWN","-65536":"UNKNOWN","-65537":"UNKNOWN","-196608":"UNKNOWN","-196609":"UNKNOWN"}}'
```

### Response

None.

## Additional Examples
