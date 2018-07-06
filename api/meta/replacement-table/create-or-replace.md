# Replacement Table: create or replace

## Description

Creates a replacement table with specified name, description, format, author, and key-value records or replaces an existing table identified by `name` in the request [path](#path-parameters).

Replacement tables are used for key-value lookups in [SQL queries](../../../sql/README.md#lookup) and [rule engine](../../../rule-engine/functions-lookup.md#lookup).

## Request

| **Method** | **Path** |
|:---|:---|---:|
| `PUT` | `/api/v1/replacement-tables/{format}/{name}`  |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `format` | **[Required]** Payload format: `json` or `csv`. |
| `name` | **[Required]** Replacement table name. |

### Fields

If `format` is `json`, refer to Response Fields in the [get](get.md#fields) method.

If `format` is `csv`, the request body must contain records in CSV format without header.

## Response

### Fields

None.

## Example with CSV format

### Request

#### URI

```elm
PUT /api/v1/replacement-tables/csv/status_codes
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
  --request PUT \
  --header 'Content-Type: text/csv' \
  --data-binary @status_codes.csv
```

### Response

None.

## Example with JSON format

### Request

#### URI

```elm
PUT /api/v1/replacement-tables/json/status_codes
```

#### Payload

```json
{
  "author": "John Doe",
  "name": "status_codes",
  "description": "Status codes to text mapping",
  "valueFormat": "LIST",
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
  --request PUT \
  --data '{"name":"status_codes","author":"John Doe",
  "description":"Status codes to text mapping","valueFormat":"LIST",
  "keys":{"-1":"Error","0":"Unknown","1":"Ok"}}'
```

### Response

None.

## Additional Examples
