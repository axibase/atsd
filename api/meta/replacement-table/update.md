# Replacement Table: update

## Description

Updates records and metadata of the specified replacement table.

Unlike the [replace](create-or-replace.md) method, records and metadata that are **not** specified in the request remain unchanged.

Similarly, fields set to `null` remain unchanged.

If `format` is `json`, the request updates both metadata and records. If `format` is `csv`, the request updates only records.

## Request

| **Method** | **Path** |
|:---|:---|---:|
| `PATCH` | `/api/v1/replacement-tables/{format}/{name}` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `format` |string| **[Required]** Payload format: `json` or `csv`. |
| `name` |string| **[Required]** Replacement table name. |

### Fields

Refer to Fields specified in the [get](get.md#fields) method.

The `name` field specified in the payload must match the one specified in the path or not be provided.

## Response

### Fields

None.

## Example with CSV format

### Request

#### URI

```elm
PATCH /api/v1/replacement-tables/csv/status_codes
```

#### Payload

```csv
-1,Error
0,Unknown
1,Ok
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/csv/status_codes \
  --insecure --include --user {username}:{password} \
  --request PATCH \
  --header 'Content-Type: text/csv' \
  --data-binary @status_codes.csv
```

### Response

None.

## Example with JSON format

### Request

#### URI

```elm
PATCH /api/v1/replacement-tables/json/status_codes
```

#### Payload

```json
{
  "author": "John Doe",
  "keys": {
      "-1": "Error",
       "0": "Unknown",
       "1": "Ok"
  }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/status_codes \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data '{"author":"John Doe","keys":{"-1": "Error","0":"Unknown","1":"OK"}}'
```

### Response

None.

## Additional Examples
