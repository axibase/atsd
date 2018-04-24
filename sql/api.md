# SQL Query API Endpoint

## Description

Execute an SQL query and retrieve query results in CSV or JSON format, including optional result metadata.

To obtain result metadata without executing the query, submit the query to [`/api/sql/meta`](api-meta.md) endpoint.

## Authorization

The rows returned for the SQL query are filtered by the server according to the user's **entity:read** permissions.

This means that the same query executed by users with different entity permissions may produce different results.

Scheduled queries are executed under full permissions.

## Connection Query

To test a connection, execute the following query:

```sql
SELECT 1
```

This query can be utilized as a validation query in database connection pool implementations such as [Apache Commons DBCP](https://commons.apache.org/proper/commons-dbcp/configuration.html).

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/sql` | `application/x-www-form-urlencoded` |

### Parameters

| **Name**| **Type** | **Description** |
|:---|:---|:---|
| `q` | string | [**Required**] Query text. |
| `outputFormat` | string | Output format: `csv` or `json`. Default: `csv`. <br>A special `null` format can be specified for performance testing. If format is `null`, the query is executed but the response output is not produced by the database.|
| `metadataFormat` | string | Metadata format for CSV format. Default: `HEADER`. <br>Supported values: `NONE`, `HEADER`, `EMBED`, `COMMENTS`. |
| `queryId` | string | User-defined handle submitted at the request time in order to identify the query, if it needs to be cancelled. |
| `limit` | integer | Maximum number of rows to return. Default: 0 (not applied).<br>The number of returned rows is equal to the `limit` parameter or the `LIMIT` clause, whichever is lower.  |
| `discardOutput` | boolean | If set to true, discards the produced content without sending it to the client. |
| `encodeTags` | boolean | If set to true, the `tags` column is encoded in JSON format for safe deserialization on the client. |

As an alternative, the query can be submitted with Content-Type `text/plain` as text payload with the other parameters included in the query string.

#### `limit` parameter vs `LIMIT` clause

| `limit` | `LIMIT` | **Result** |
|:---|:---|:---|
| 5 | 3 | 3 |
| 5 | 10 | 5 |
| 5 | - | 5 |
| 0 | 3 | 3 |
| - | 3 | 3 |
| - | - | - |

```java
  statement.setMaxRows(5);
  statement.executeQuery("SELECT datetime, value FROM \"mpstat.cpu_busy\" LIMIT 3");
  //results will be limited to 3 records
```

### Cancelling the Query

The client may cancel an active query by submitting a request to `/api/sql/cancel?queryId=myid` endpoint.

The `queryId` identifies the query to be cancelled.

## Response

The response in CSV format is subject to the following formatting rules:

* String values are enclosed in double-quotes, even if special characters are not present.
* `NULL` is printed as an empty string.
* Numeric values, including `NaN` (Not a Number), are not enclosed in quotes.

```ls
string,empty_string,null,number,number(NaN)
"hello","",,10.3,NaN
```

### Metadata

The response can include optional metadata to assist API clients in processing results, for example to convert text values in CSV or JSON field values into language-specific data types.

The metadata is specified as JSON-LD (JSON linked data) according to the [W3C Model for Tabular Data](https://www.w3.org/TR/tabular-data-model/).

ATSD JSON-LD schema is published [here](https://www.axibase.com/schemas/2017/07/atsd.jsonld).

Sample metadata:

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
			"table": "cpu_busy",
			"propertyUrl": "atsd:value"
		}, {
			"columnIndex": 2,
			"name": "tbl.datetime",
			"titles": "sample-date",
			"datatype": "xsd:dateTimeStamp",
			"table": "cpu_busy",
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

### Metadata in JSON Output Format

Results in the JSON output format incorporates metadata by default, including table and column schema.

### Metadata in CSV Output Format

The `metadataFormat` parameter specifies how metadata is incorporated into the CSV response.

| **Value**| **Description** |
|:---|:---|
| `NONE` | Do not include metadata in the response. |
| `HEADER` | [**Default**] Add JSON-LD metadata into Base64-encoded `Link` header according to [W3C Model for Tabular Data](http://w3c.github.io/csvw/syntax/#link-header).<br>`<data:application/csvm+json;base64,eyJAY29...ifX0=>; rel="describedBy"; type="application/csvm+json"`<br>Be aware that maximum response header size is 12 kilobytes and avoid Link header option if the response contains many columns or columns with long names.|
| `EMBED` | Append JSON-LD metadata to CSV header as comments prefixed by hash symbol. |
| `COMMENTS` | Append CSV metadata to CSV header as comments prefixed by hash symbol. |

## Examples

### `curl` Query Example

```sh
curl https://atsd_server:8443/api/sql  \
  --insecure  --verbose --compressed \
  --user {username}:{password} \
  --data 'q=SELECT entity, value FROM "mpstat.cpu_busy" WHERE datetime > now - 1*MINUTE'
```

Use `'\'` to escape single quotes inside the query payload.

```sh
curl https://atsd_server:8443/api/sql  \
  --insecure  --verbose --compressed \
  --user {username}:{password} \
  --data 'q=SELECT * FROM "mpstat.cpu_busy" WHERE entity =  '\''nurswghbs001'\'' AND datetime between '\''2018-03-01T17:00:00Z'\'' AND '\''2018-03-02T17:00:00Z'\'''
```

### Bash Client Example

Execute query specified in a `query.sql` file and write CSV results to `/tmp/report-1.csv`.

```ls
./sql.sh -o /tmp/report-1.csv -i query.sql -f csv
```

Execute query specified inline and store results in `/tmp/report-2.csv`.

```ls
./sql.sh --output /tmp/report-2.csv --query "SELECT entity, value FROM \"mpstat.cpu_busy\" WHERE datetime > now - 1*minute LIMIT 3"
```

Bash client [parameters](client/README.md).

### Java Client Example

[SQL to CSV example in Java](client/SqlCsvExample.java).

### Encoding Tags

```ls
encodeTags=true&q=SELECT entity, datetime, value, tags FROM df.disk_used WHERE datetime > current_hour LIMIT 1
```

* Encoding in CSV Format

```txt
"entity","datetime","value","tags"
"nurswgvml007","2017-08-25T12:00:05.000Z",8932448,"{""file_system"":""/dev/mapper/vg_nurswgvml007-lv_root"",""mount_point"":""/""}"
```

## Response Examples

* [CSV response](sql.csv)
* [JSON response](sql.json)
