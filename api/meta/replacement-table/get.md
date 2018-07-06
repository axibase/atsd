# Replacement Table: get

## Description

Retrieves key-value records and metadata for the specified replacement table.

Replacement tables are used for key-value lookups in [SQL queries](../../../sql/README.md#lookup) and [rule engine](../../../rule-engine/functions-lookup.md#lookup).

* `json` format

The response in `json` format contains a single JSON object containing both metadata and key-value records.

* `csv` format

The response in `csv` format contains the predefined header `Key,Value` followed by records in CSV format. Metadata is included in the `Link` header as JSON Linked Data (JSON-LD) according to the [W3C Model for Tabular Data](https://www.w3.org/TR/tabular-data-model/) specification.

```txt
Key,Value
key-1,value-1
key-2,value-2
```

If the `addComments` request parameter is set to `true`, the response includes any key-values that are preceded by hash symbol.

```txt
Key,Value
key-1,value-1
key-2,value-2
#key-3,value-3
```

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/replacement-tables/{format}/{name}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `format` | **[Required]** Output format: `json` or `csv`. |
| `name` | **[Required]** Replacement table name. |

### Query String Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `addComments` | boolean | If `true`, response includes comments in output. Applies to `csv` format only. |

## Response

### Fields

If `format` is `json`, the response includes a JSON object with the following fields:

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|
| `author` |string|Replacement table creator.|
| `description` |string|Replacement table description.|
| `valueFormat` |string|Replacement table format.<br>Supported values: `LIST`, `SQL`, `JSON`, `GRAPHQL`, `TEXT`. |
| `keys` |object|Key-value mappings.|

If format is `csv`, the response returns records as a CSV table with the pre-defined header `Key,Value`. The metadata is included in the `Link` header as Base64-encoded JSON-LD content.

## Example with JSON format

### Request

#### URI

```elm
GET /api/v1/replacement-tables/json/status_codes
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/json/status_codes \
  --insecure --include --user {username}:{password}
```

### Response

```json
{
  "name": "status_codes",
  "author": "John Doe",
  "description": "Status codes to text mapping",
  "valueFormat": "LIST",
  "keys": {
    "0": "Unknown",
    "1": "Ok",
    "-1": "Error"
  }
}
```

## Example with CSV format

### Request

#### URI

```elm
GET /api/v1/replacement-tables/csv/status_codes
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/csv/status_codes \
  --insecure --include --user {username}:{password}
```

### Link Header

```csv
<data:application/csvm+json;base64,
eyJAY29udGV4dCI6WyJodHRwOi8vd3d3LnczLm9yZy9ucy9jc3Z3Il0sInVybCI6Imh0dHBzOi8v
ZTI1Y2ZjMjVjOGRiOjg0NDMvYXBpL3YxL3JlcGxhY2VtZW50LXRhYmxlcy9jc3Yvc3RhdHVzX2Nv
ZGVzIiwiQHR5cGUiOiJUYWJsZSIsImRjOnRpdGxlIjoic3RhdHVzX2NvZGVzIiwiZGM6ZGVzY3Jp
cHRpb24iOiJTdGF0dXMgY29kZXMgdG8gdGV4dCBtYXBwaW5nIiwiZGM6cHVibGlzaGVyIjp7InNj
aGVtYTpuYW1lIjoiQXhpYmFzZSBUaW1lLVNlcmllcyBEYXRhYmFzZSIsInNjaGVtYTp1cmwiOnsi
QGlkIjoiaHR0cHM6Ly9lMjVjZmMyNWM4ZGI6ODQ0MyJ9fSwiZGM6Y3JlYXRvciI6IkpvaG4gRG9l
IiwiZGM6dHlwZSI6IkxJU1QiLCJ0YWJsZVNjaGVtYSI6eyJjb2x1bW5zIjpbeyJjb2x1bW5JbmRl
eCI6MCwidGl0bGVzIjoiS2V5IiwiZGF0YXR5cGUiOiJzdHJpbmcifSx7ImNvbHVtbkluZGV4Ijox
LCJ0aXRsZXMiOiJWYWx1ZSIsImRhdGF0eXBlIjoic3RyaW5nIn1dfSwiZGlhbGVjdCI6eyJjb21t
ZW50UHJlZml4IjoiIyIsImRlbGltaXRlciI6IiwiLCJkb3VibGVRdW90ZSI6dHJ1ZSwicXVvdGVD
aGFyIjoiXCIiLCJoZWFkZXJSb3dDb3VudCI6MSwiZW5jb2RpbmciOiJ1dGYtOCIsImhlYWRlciI6
dHJ1ZSwibGluZVRlcm1pbmF0b3JzIjpbIlxyXG4iLCJcbiJdLCJza2lwQmxhbmtSb3dzIjpmYWxz
ZSwic2tpcENvbHVtbnMiOjAsInNraXBSb3dzIjowLCJza2lwSW5pdGlhbFNwYWNlIjpmYWxzZSwi
dHJpbSI6ZmFsc2UsIkB0eXBlIjoiRGlhbGVjdCJ9LCJwcmltYXJ5S2V5IjoiS2V5In0=  
>; rel="describedBy"; type="application/csvm+json"
```

Metadata after Base64 decoding:

```json
{
  "@context": [
    "http://www.w3.org/ns/csvw"
  ],
  "url": "https://e25cfc25c8db:8443/api/v1/replacement-tables/csv/status_codes",
  "@type": "Table",
  "dc:title": "status_codes",
  "dc:description": "Status codes to text mapping",
  "dc:publisher": {
    "schema:name": "Axibase Time-Series Database",
    "schema:url": {
      "@id": "https://e25cfc25c8db:8443"
    }
  },
  "dc:creator": "John Doe",
  "dc:type": "LIST",
  "tableSchema": {
    "columns": [
      {
        "columnIndex": 0,
        "titles": "Key",
        "datatype": "string"
      },
      {
        "columnIndex": 1,
        "titles": "Value",
        "datatype": "string"
      }
    ]
  },
  "dialect": {
    "commentPrefix": "#",
    "delimiter": ",",
    "doubleQuote": true,
    "quoteChar": "\"",
    "headerRowCount": 1,
    "encoding": "utf-8",
    "header": true,
    "lineTerminators": [
      "\r\n",
      "\n"
    ],
    "skipBlankRows": false,
    "skipColumns": 0,
    "skipRows": 0,
    "skipInitialSpace": false,
    "trim": false,
    "@type": "Dialect"
  },
  "primaryKey": "Key"
}
```

### Response

```csv
Key,Value
"-1",Error
0,Unknown
1,Ok
```

## Additional Examples
