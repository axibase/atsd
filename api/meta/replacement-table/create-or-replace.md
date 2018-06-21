# Replacement Table: Create or Replace

## Description

Creates a replacement table with specified name, description, format, author, and key-value records or replaces an existing table identified by `name` in the request [path](#path-parameters).

Replacement tables are used for key-value lookups in [SQL queries](../../../sql/README.md#lookup) and [rule engine](../../../rule-engine/functions-lookup.md#lookup).

## Request

| **Method** | **Path** |
|:---|:---|---:|
| PUT | `/api/v1/replacement-tables/{format}/{name}`  |

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
PUT /api/v1/replacement-tables/csv/pi_pids
```

#### Payload

```csv
-65536,Inactive
-65537,Active
-196608,Manual
-196609,Auto
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/csv/pi_pids \
  --insecure --include --user {username}:{password} \
  --request PUT \
  --header 'Content-Type: text/csv' \
  --data-binary @pids.csv
```

### Response

None.

## Example with JSON format

### Request

#### URI

```elm
PUT /api/v1/replacement-tables/json/pi_pids
```

#### Payload

```json
{
    "name": "pi_pids",
    "author": "John Doe",
    "description": "PI digital state code to label mapping",
    "valueFormat": "LIST",
    "keys": {
        "0": "Good",
        "-65536": "Inactive",
        "-65537": "Active",
        "-196608": "Manual",
        "-196609": "Auto"
    }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/json/pi_pids \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"author":"John Doe","description":"PI digital state code to label mapping","valueFormat":"LIST","keys":{"-65536":"Inactive","-65537":"Active","-196608":"Manual","-196609":"Auto"}}'
```

### Response

None.

## Additional Examples
