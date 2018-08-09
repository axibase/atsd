# SQL Report Metadata

## Overview

The metadata section is located in the header and is prepended with the hash symbol `#`.
It includes the following fields in the "name,value" format:

|**Name**|**Description**|
|:---|:---|
|publisher| Name of the reporting product (ATSD) and the URL of the ATSD server.|
|created| Date when the report is produced in [ISO format](../shared/date-format.md).|
|title | Report name, such as "CPU Busy Daily Report". |
|command | Query statement on one or multiple lines. |

In addition, the metadata header contains a list of column names with their respective data types.

```txt
#name,entity,Average,...
#datatype,string,double,...
```

### Metadata Specification

* ATSD [Ontology](atsd.jsonld) in `jsonld` format according to [RFC6350](https://tools.ietf.org/html/rfc6350)
* W3C Recommendation [Metadata Vocabulary for Tabular Data](https://www.w3.org/TR/tabular-metadata/)

### Metadata in CSV Format

Metadata can be embedded in CSV files as part of the header using the hash symbol (`#`).

```txt
#publisher,Axibase Time Series Database,https://atsd.example.org
#created,2016-06-12T15:56:39.106Z
#title,SQL Query
#comment,"SELECT entity, avg(value) AS "Average", median(value), max(value), count(*)
#FROM "mpstat.cpu_busy"
#  WHERE time BETWEEN previous_day and current_day
#  GROUP BY entity
#  ORDER BY avg(value) DESC"
#name,entity,Average,median(value),max(value),count(*)
#datatype,string,double,double,double,double
entity,Average,median(value),max(value),count(*)
nurswgvml006,18.4,4.0,100.0,5385.0
```

### Metadata in Excel Format

Same as in CSV format.

### Metadata in JSON Format

Metadata is specified according to W3C Recommendation [Metadata Vocabulary for Tabular Data](https://www.w3.org/TR/tabular-metadata/)

Table schema object provides the following information about the columns in the result set:

* index, starts with 1
* name
* label (alias)
* datatype
* table name (metric name)
* type as specified in [ontology](atsd.jsonld)
* description

```json
{
  "metadata": {
    "@context": ["http://www.w3.org/ns/csvw", {
      "atsd": "http://www.axibase.com/schemas/2017/07/atsd.jsonld"
    }],
    "dc:created": {
      "@value": "2017-07-04T17:08:39.745Z",
      "@type": "xsd:date"
    },
    "dc:publisher": {
      "schema:name": "Axibase Time Series Database",
      "schema:url": {
        "@id": "https://atsd.example.org"
      }
    },
    "dc:title": "SQL Query",
    "rdfs:comment": "SELECT entity, datetime, avg(value) AS \"Average\" FROM \"mpstat.cpu_busy\" WHERE datetime > current_minute GROUP BY entity, period(1 minute) ORDER BY avg(value) DESC",
    "@type": "Table",
    "url": "sql.csv",
    "tableSchema": {
      "columns": [{
        "columnIndex": 1,
        "name": "entity",
        "titles": "entity",
        "datatype": "string",
        "table": "mpstat.cpu_busy",
        "propertyUrl": "atsd:entity"
      }, {
        "columnIndex": 2,
        "name": "datetime",
        "titles": "datetime",
        "datatype": "xsd:dateTimeStamp",
        "table": "mpstat.cpu_busy",
        "propertyUrl": "atsd:datetime",
        "dc:description": "Sample time in ISO8601 format"
      }, {
        "columnIndex": 3,
        "name": "avg(value)",
        "titles": "Average",
        "datatype": "double",
        "table": "mpstat.cpu_busy",
        "propertyUrl": "atsd:avg"
      }]
    }
  },
  "data": [
    ["nurswgvml007", "2017-07-04T17:08:00.000Z", 11.756666666666664],
    ["nurswgvml006", "2017-07-04T17:08:00.000Z", 3.3499999999999996],
    ["nurswgvml502", "2017-07-04T17:08:00.000Z", 2.9966666666666666],
    ["nurswgvml010", "2017-07-04T17:08:00.000Z", 0.375],
    ["nurswgvml301", "2017-07-04T17:08:00.000Z", 0.0]
  ]
}
```
