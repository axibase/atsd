# SQL Query Metadata API Endpoint

## Description

Retrieve SQL query result metadata in JSON format without executing the query. 

> The metadata will be provided even if one of the metrics referenced in the query does not exist in the database. In this case, the metric value column will be of the default `float` datatype.

## Authorization

No entity permissions are required.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/sql/meta` | `application/x-www-form-urlencoded` |

### Parameters

| **Name**| **Type** | **Description** |
|:---|:---|:---|
| q | string | [**Required**] Query text. |

As an alternative, the query can be submitted with Content-Type `text/plain` as text payload with the other parameters included in the query string.

## Response

The response contains resultset metadata in JSON format to assist JDBC drivers and API clients in processing query results.

The metadata is specified as JSON-LD (JSON linked data) according to the [W3C Model for Tabular Data](https://www.w3.org/TR/tabular-data-model/).

ATSD JSON-LD schema is published [here](https://www.axibase.com/schemas/2017/07/atsd.jsonld).

```json
{
	"@context": ["http://www.w3.org/ns/csvw", {
		"atsd": "http://www.axibase.com/schemas/2017/07/atsd.jsonld"
	}],
	"dc:created": {
		"@value": "2017-07-04T16:59:19.908Z",
		"@type": "xsd:date"
	},
	"dc:publisher": {
		"schema:name": "Axibase Time-Series Database",
		"schema:url": {
			"@id": "https://atsd_hostname:8443"
		}
	},
	"dc:title": "SQL Query",
	"rdfs:comment": "SELECT tbl.value*100 AS \"cpu_percent\", tbl.datetime 'sample-date'\n FROM \"mpstat.cpu_busy\" tbl \n WHERE datetime > now - 1*MINUTE",
	"@type": "Table",
	"url": "sql.csv",
	"tableSchema": {
		"columns": [{
			"columnIndex": 1,
			"name": "tbl.value * 100",
			"titles": "cpu_percent",
			"datatype": "double",
			"table": "mpstat.cpu_busy",
			"propertyUrl": "atsd:value"
		}, {
			"columnIndex": 2,
			"name": "tbl.datetime",
			"titles": "sample-date",
			"datatype": "xsd:dateTimeStamp",
			"table": "mpstat.cpu_busy",
			"propertyUrl": "atsd:datetime",
			"dc:description": "Sample time in ISO8601 format"
		}]
	},
	"dialect": {
		"commentPrefix": "#",
		"delimiter": ",",
		"doubleQuote": true,
		"quoteChar": "\"",
		"headerRowCount": 1,
		"encoding": "utf-8",
		"header": true,
		"lineTerminators": ["\r\n", "\n"],
		"skipBlankRows": false,
		"skipColumns": 0,
		"skipRows": 0,
		"skipInitialSpace": false,
		"trim": false,
		"@type": "Dialect"
	}
}
```


## Example

### `curl` Query Example

```sh
curl https://atsd_server:8443/api/sql/meta  \
  --insecure  --verbose --user {username}:{password} \
  --request POST \
  --data 'q=SELECT entity, value FROM "mpstat.cpu_busy" WHERE datetime > now - 1*MINUTE'
```

```json
{
	"@context": ["http://www.w3.org/ns/csvw", {
		"atsd": "http://www.axibase.com/schemas/2017/07/atsd.jsonld"
	}],
	"dc:created": {
		"@value": "2017-07-07T13:05:48.395Z",
		"@type": "xsd:date"
	},
	"dc:publisher": {
		"schema:name": "Axibase Time-Series Database",
		"schema:url": {
			"@id": "https://atsd_server:8443"
		}
	},
	"dc:title": "SQL Query",
	"rdfs:comment": "SELECT entity, value FROM \"mpstat.cpu_busy\" WHERE datetime > now - 1*MINUTE",
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
			"name": "value",
			"titles": "value",
			"datatype": "float",
			"table": "mpstat.cpu_busy",
			"propertyUrl": "atsd:value"
		}]
	},
	"dialect": {
		"commentPrefix": "#",
		"delimiter": ",",
		"doubleQuote": true,
		"quoteChar": "\"",
		"headerRowCount": 1,
		"encoding": "utf-8",
		"header": true,
		"lineTerminators": ["\r\n", "\n"],
		"skipBlankRows": false,
		"skipColumns": 0,
		"skipRows": 0,
		"skipInitialSpace": false,
		"trim": false,
		"@type": "Dialect"
	}
}
```
