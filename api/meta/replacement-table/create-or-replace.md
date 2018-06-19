# Replacement Table: Create or Replace

## Description

Creates a replacement table with specified name, description, type, author, and records.

If the specified replacement table exists, all current replacement table records and metadata are replaced by those specified in the request.

## Request

| **Method** | **Path** |
|:---|:---|---:|
| PUT | `/api/v1/replacement-tables/{format}/{name}`  |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `format` | **[Required]** Output format: `json` or `csv`. |
| `name` | **[Required]** Replacement table name. |

### Fields

If `format` is `json`, refer to Response Fields in [Replacement Table: Get](get.md#fields).

If `format` is `csv`, the request body should contain records in CSV format without header.

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

```json
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
  --data @- <<'EOF'
-65536,Inactive
-65537,Active
-196608,Manual
-196609,Auto'
EOF
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
    "format": "LIST",
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
  --data '{"author":"John Doe","description":"PI digital state code to label mapping","format":"LIST","keys":{"-65536":"Inactive","-65537":"Active","-196608":"Manual","-196609":"Auto"}}'
```

### Response

None.

## Additional Examples
