# Replacement Table: Get

## Description

Retrieves records and metadata for the specified replacement table.

If content type is `application/json`, the response contains a single object with metadata and records.

If content type is `text/csv`, the response contains records in CSV format, and metadata is encoded in jsonld format in Link header.

If content type is `text/csv`, the comments from the replacement table are returned if `comments=true` query string parameter is provided.

## Request

| **Method** | **Path** | **Content-Type** |
|:---|:---|:---|
| GET | `/api/v1/replacement-tables/csv` | `text/csv` |
| GET | `/api/v1/replacement-tables/json` | `application/json` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `name` | **[Required]** Replacement table name. |

### Query String Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `comments` | boolean | Should the comments be included into the output? Works with csv format only. |

## Response

### Fields

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|
| `author` |string|Replacement table creator.|
| `description` |string|Replacement table description.|
| `format` |string|Replacement table UI representation.|
| `keys` |object|Key-value mappings.|


## Example

### Request

#### URI

```elm
GET /api/v1/replacement-tables/json/pi_pids
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/json/pi_pids \
  --insecure --include --user {username}:{password}
```

### Response

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

## Additional Examples
