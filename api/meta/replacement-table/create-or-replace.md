# Replacement Table: Create or Replace

## Description

Creates a replacement table with specified name, description, type, author, and records.

In case of an existing replacement table, all the current replacement table records and metadata are replaced with the ones specified in the request.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| PUT | `/api/v1/replacement-tables/csv/{name}`  | `text/html` |
| PUT | `/api/v1/replacement-tables/json/{name}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|

### Fields

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|
| `author` |string|Replacement table creator.|
| `description` |string|Replacement table description.|
| `format` |string|Replacement table UI representation.|
| `keys` |object|Key-value mappings.|

## Response

### Fields

None.

## Example

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
