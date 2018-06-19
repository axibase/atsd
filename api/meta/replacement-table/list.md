# Replacement Table: List

## Description

Retrieves a list of replacement table names.

## Request

| **Method** | **Path** |
|:---|:---|:---|
| GET | `/api/v1/replacement-tables/{format}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `format` | **[Required]** Output format: `json` or `csv`. |

### Query Parameters

None

## Response

### Fields

If `format` is `json`, response includes a JSON array containing names of existing replacement tables.

If `format` is `csv`, response includes a list of names in CSV file with header `Name`.

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
["pi_pids"]
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
<data:application/csvm+json;base64,eyJAY29udGV4dCI6WyJodHRwOi8vd3d3LnczLm9yZy9ucy9jc3Z3Il0sInVybCI6Imh0dHBzOi8v
YXRzZF9ob3N0Ojg0NDMvYXBpL3YxL3JlcGxhY2VtZW50LXRhYmxlcy9jc3YiLCJAdHlwZSI6IlRh
YmxlIiwiZGM6dGl0bGUiOiJSZXBsYWNlbWVudCBUYWJsZXMiLCJkYzpkZXNjcmlwdGlvbiI6Ikxp
c3Qgb2YgcmVwbGFjZW1lbnQgdGFibGUgbmFtZXMiLCJkYzpwdWJsaXNoZXIiOnsic2NoZW1hOm5h
bWUiOiJBeGliYXNlIFRpbWUtU2VyaWVzIERhdGFiYXNlIiwic2NoZW1hOnVybCI6eyJAaWQiOiJo
dHRwczovL2F0c2RfaG9zdDo4NDQzIn19LCJ0YWJsZVNjaGVtYSI6eyJjb2x1bW5zIjpbeyJjb2x1
bW5JbmRleCI6MCwidGl0bGVzIjoiTmFtZSIsImRhdGF0eXBlIjoic3RyaW5nIn1dfSwiZGlhbGVj
dCI6eyJjb21tZW50UHJlZml4IjoiIyIsImRlbGltaXRlciI6IiwiLCJkb3VibGVRdW90ZSI6dHJ1
ZSwicXVvdGVDaGFyIjoiXCIiLCJoZWFkZXJSb3dDb3VudCI6MSwiZW5jb2RpbmciOiJ1dGYtOCIs
ImhlYWRlciI6dHJ1ZSwibGluZVRlcm1pbmF0b3JzIjpbIlxyXG4iLCJcbiJdLCJza2lwQmxhbmtS
b3dzIjpmYWxzZSwic2tpcENvbHVtbnMiOjAsInNraXBSb3dzIjowLCJza2lwSW5pdGlhbFNwYWNl
IjpmYWxzZSwidHJpbSI6ZmFsc2UsIkB0eXBlIjoiRGlhbGVjdCJ9fQ==
>; rel="describedBy"; type="application/csvm+json"
```

Metadata after Base64 decoding:

```json
{
   "@context":[
      "http://www.w3.org/ns/csvw"
   ],
   "url":"https://atsd_host:8443/api/v1/replacement-tables/csv",
   "@type":"Table",
   "dc:title":"Replacement Tables",
   "dc:description":"List of replacement table names",
   "dc:publisher":{
      "schema:name":"Axibase Time-Series Database",
      "schema:url":{
         "@id":"https://atsd_host:8443"
      }
   },
   "tableSchema":{
      "columns":[
         {
            "columnIndex":0,
            "titles":"Name",
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
   }
}
```

### Response

```csv
Name
pi_pids
```

## Additional Examples
