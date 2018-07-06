# Replacement Table: list

## Description

Retrieves a list of replacement table names.

Replacement tables are used for key-value lookups in [SQL queries](../../../sql/README.md#lookup) and [rule engine](../../../rule-engine/functions-lookup.md#lookup).

## Request

| **Method** | **Path** |
|:---|:---|:---|
| `GET` | `/api/v1/replacement-tables/{format}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `format` | **[Required]** Output format: `json` or `csv`. |

### Query Parameters

None

## Response

### Fields

If `format` is `json`, response includes a JSON array containing names of existing replacement tables.

If `format` is `csv`, response includes a list of names in CSV format with the predefined header `Name`.

## Example with JSON format

### Request

#### URI

```elm
GET /api/v1/replacement-tables/json
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/json \
  --insecure --include --user {username}:{password}
```

### Response

```json
[
  "status_codes"
]
```

## Example with CSV format

### Request

#### URI

```elm
GET /api/v1/replacement-tables/csv
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/csv \
  --insecure --include --user {username}:{password}
```

### Link Header

```csv
<data:application/csvm+json;base64,
eyJAY29udGV4dCI6WyJodHRwOi8vd3d3LnczLm9yZy9ucy9jc3Z3Il0sInVybCI6Imh0dHBzOi8v
ZTI1Y2ZjMjVjOGRiOjg0NDMvYXBpL3YxL3JlcGxhY2VtZW50LXRhYmxlcy9jc3YiLCJAdHlwZSI6
IlRhYmxlIiwiZGM6dGl0bGUiOiJSZXBsYWNlbWVudCBUYWJsZXMiLCJkYzpkZXNjcmlwdGlvbiI6
Ikxpc3Qgb2YgcmVwbGFjZW1lbnQgdGFibGUgbmFtZXMiLCJkYzpwdWJsaXNoZXIiOnsic2NoZW1h
Om5hbWUiOiJBeGliYXNlIFRpbWUtU2VyaWVzIERhdGFiYXNlIiwic2NoZW1hOnVybCI6eyJAaWQi
OiJodHRwczovL2UyNWNmYzI1YzhkYjo4NDQzIn19LCJ0YWJsZVNjaGVtYSI6eyJjb2x1bW5zIjpb
eyJjb2x1bW5JbmRleCI6MCwidGl0bGVzIjoiTmFtZSIsImRhdGF0eXBlIjoic3RyaW5nIn1dfSwi
ZGlhbGVjdCI6eyJjb21tZW50UHJlZml4IjoiIyIsImRlbGltaXRlciI6IiwiLCJkb3VibGVRdW90
ZSI6dHJ1ZSwicXVvdGVDaGFyIjoiXCIiLCJoZWFkZXJSb3dDb3VudCI6MSwiZW5jb2RpbmciOiJ1
dGYtOCIsImhlYWRlciI6dHJ1ZSwibGluZVRlcm1pbmF0b3JzIjpbIlxyXG4iLCJcbiJdLCJza2lw
QmxhbmtSb3dzIjpmYWxzZSwic2tpcENvbHVtbnMiOjAsInNraXBSb3dzIjowLCJza2lwSW5pdGlh
bFNwYWNlIjpmYWxzZSwidHJpbSI6ZmFsc2UsIkB0eXBlIjoiRGlhbGVjdCJ9fQ==  
>; rel="describedBy"; type="application/csvm+json"
```

Metadata after Base64 decoding:

```json
{
  "@context": [
    "http://www.w3.org/ns/csvw"
  ],
  "url": "https://e25cfc25c8db:8443/api/v1/replacement-tables/csv",
  "@type": "Table",
  "dc:title": "Replacement Tables",
  "dc:description": "List of replacement table names",
  "dc:publisher": {
    "schema:name": "Axibase Time-Series Database",
    "schema:url": {
      "@id": "https://e25cfc25c8db:8443"
    }
  },
  "tableSchema": {
    "columns": [
      {
        "columnIndex": 0,
        "titles": "Name",
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
  }
}
```

### Response

```csv
Name
status_codes
```

## Additional Examples
