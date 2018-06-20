# Replacement Table: Get

## Description

Retrieves records and metadata for the specified replacement table.

If `format` is `json`, the response contains a single object with metadata and records.

If `format` is `csv`, the response contains records in CSV format, and metadata is specified as JSON Linked Data (JSON-LD) according to the [W3C Model for Tabular Data](https://www.w3.org/TR/tabular-data-model/) in `Link` header.

If `format` is `csv`, the response includes comments from the replacement table if `addComments=true` query string parameter is provided by user.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/replacement-tables/{format}/{name}` |

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

If `format` is `json`, the response includes a JSON object which includes the following values:

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|
| `author` |string|Replacement table creator.|
| `description` |string|Replacement table description.|
| `valueFormat` |string|Replacement table format.<br>Supported values: LIST, SQL, JSON, GRAPHQL, TEXT. |
| `keys` |object|Key-value mappings.|

If format is `csv`, the response returns records as a CSV table with header `Key,Value`. The metadata is specified as JSON-LD.

## Example with JSON format

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

## Example with CSV format

### Request

#### URI

```elm
GET /api/v1/replacement-tables/csv/pi_pids
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/csv/pi_pids \
  --insecure --include --user {username}:{password}
```

### Link Header

```csv
<data:application/csvm+json;base64,eyJAY29udGV4dCI6WyJodHRwOi8vd3d3LnczLm9yZy9ucy9jc3Z3Il0sInVybCI6Imh0dHBzOi8v
YXRzZF9ob3N0Ojg0NDMvYXBpL3YxL3JlcGxhY2VtZW50LXRhYmxlcy9jc3YvcGlfcGlkcyIsIkB0
eXBlIjoiVGFibGUiLCJkYzp0aXRsZSI6InBpX3BpZHMiLCJkYzpkZXNjcmlwdGlvbiI6IlBJIGRp
Z2l0YWwgc3RhdGUgY29kZSB0byBsYWJlbCBtYXBwaW5nIiwiZGM6cHVibGlzaGVyIjp7InNjaGVt
YTpuYW1lIjoiQXhpYmFzZSBUaW1lLVNlcmllcyBEYXRhYmFzZSIsInNjaGVtYTp1cmwiOnsiQGlk
IjoiaHR0cHM6Ly9hdHNkX2hvc3Q6ODQ0MyJ9fSwiZGM6Y3JlYXRvciI6IkpvaG4gRG9lIiwiZGM6
dHlwZSI6IkxJU1QiLCJ0YWJsZVNjaGVtYSI6eyJjb2x1bW5zIjpbeyJjb2x1bW5JbmRleCI6MCwi
dGl0bGVzIjoiS2V5IiwiZGF0YXR5cGUiOiJzdHJpbmcifSx7ImNvbHVtbkluZGV4IjoxLCJ0aXRs
ZXMiOiJWYWx1ZSIsImRhdGF0eXBlIjoic3RyaW5nIn1dfSwiZGlhbGVjdCI6eyJjb21tZW50UHJl
Zml4IjoiIyIsImRlbGltaXRlciI6IiwiLCJkb3VibGVRdW90ZSI6dHJ1ZSwicXVvdGVDaGFyIjoi
XCIiLCJoZWFkZXJSb3dDb3VudCI6MSwiZW5jb2RpbmciOiJ1dGYtOCIsImhlYWRlciI6dHJ1ZSwi
bGluZVRlcm1pbmF0b3JzIjpbIlxyXG4iLCJcbiJdLCJza2lwQmxhbmtSb3dzIjpmYWxzZSwic2tp
cENvbHVtbnMiOjAsInNraXBSb3dzIjowLCJza2lwSW5pdGlhbFNwYWNlIjpmYWxzZSwidHJpbSI6
ZmFsc2UsIkB0eXBlIjoiRGlhbGVjdCJ9LCJwcmltYXJ5S2V5IjoiS2V5In0=
>; rel="describedBy"; type="application/csvm+json"
```

Metadata after Base64 decoding:

```json
{
   "@context":[
      "http://www.w3.org/ns/csvw"
   ],
   "url":"https://atsd_host:8443/api/v1/replacement-tables/csv/pi_pids",
   "@type":"Table",
   "dc:title":"pi_pids",
   "dc:description":"PI digital state code to label mapping",
   "dc:publisher":{
      "schema:name":"Axibase Time-Series Database",
      "schema:url":{
         "@id":"https://atsd_host:8443"
      }
   },
   "dc:creator":"John Doe",
   "dc:type":"LIST",
   "tableSchema":{
      "columns":[
         {
            "columnIndex":0,
            "titles":"Key",
            "datatype":"string"
         },
         {
            "columnIndex":1,
            "titles":"Value",
            "datatype":"string"
         }
      ]
   },
   "dialect":{
      "commentPrefix":"#",
      "delimiter":",",
      "doubleQuote":true,
      "quoteChar":"\"",
      "headerRowCount":1,
      "encoding":"utf-8",
      "header":true,
      "lineTerminators":[
         "\r\n",
         "\n"
      ],
      "skipBlankRows":false,
      "skipColumns":0,
      "skipRows":0,
      "skipInitialSpace":false,
      "trim":false,
      "@type":"Dialect"
   },
   "primaryKey":"Key"
}
```

### Response

```csv
Key,Value
"-65536",Inactive
"-65537",Active
"-196608",Manual
"-196609",Auto
```

## Additional Examples
