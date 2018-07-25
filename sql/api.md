# SQL Query API Endpoint

## Description

This endpoint executes an SQL query and returns the results in CSV or JSON format, with the optional inclusion of result metadata.

To retrieve result set metadata without query execution, submit the query to the [`/api/sql/meta`](api-meta.md) endpoint.

## Authorization

The result set is filtered by the database based on the entity `read` [permissions](../administration/user-authorization.md#entity-permissions) granted to the user.

Thus, the same query executed by users with different entity permissions produces different results.

Scheduled queries are executed with full `All Entities: Read` permissions.

## Connection Query

To test a connection, execute a query without table reference.

```sql
SELECT 1
```

Use this query for validation in connection pool implementations such as [Apache Commons DBCP](https://commons.apache.org/proper/commons-dbcp/configuration.html).

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/sql` | `application/x-www-form-urlencoded` |

### Parameters

| **Name**| **Type** | **Description** |
|:---|:---|:---|
| `q` | string | **[Required]** Query text. |
| `outputFormat` | string | Output format: `csv` or `json`. Default: `csv`. <br>Specify `null` format for performance testing.<br>If format is `null`, the query is executed but the response output is not produced by the database.|
| `metadataFormat` | string | Metadata format for CSV format. Default: `HEADER`. <br>Allowed values: `NONE`, `HEADER`, `EMBED`, `COMMENTS`. |
| `queryId` | string | User-defined identification submitted at request time to identify the query. Cancel a long-running query with its `queryId`. |
| `limit` | integer | Maximum number of rows to return.<br>Default: `0`.<br>The number of returned rows is equal to the `limit` parameter or the `LIMIT` clause, whichever is lower.  |
| `discardOutput` | boolean | If set to `true`, discards the produced content without sending it to the client. |
| `encodeTags` | boolean | If set to `true`, the `tags` column is encoded in JSON format for safe parsing on the client. |
| `datetimeAsNumber` | boolean | If set to `true`, the `datetime` column contains Unix milliseconds since `1970-01-01T00:00:00Z`, similar to the `time` column. |

> As an alternative, submit the query as a text payload with the `Content-Type` header set to `text/plain` and other parameters included in the query string.

#### limit parameter versus LIMIT clause

| `limit` | `LIMIT` | **Result** |
|:---|:---|:---|
| `5` | `3` | `3` |
| `5` | `10` | `5` |
| `5` | `-` | `5` |
| `0` | `3` | `3` |
| `-` | `3` | `3` |
| `-` | `-` | `-` |

```java
statement.setMaxRows(5);
statement.executeQuery("SELECT datetime, value FROM \"mpstat.cpu_busy\" LIMIT 3");
//results are limited to 3 records
```

### Cancelling a Query

Cancel an active query by submitting a request to `/api/sql/cancel?queryId={client-query-id}` endpoint from the client.

The `client-query-id` parameter identifies the query to be cancelled.

## Response

The CSV formatted response is subject to the following rules:

* String values are enclosed in double quotes `"`, even if special characters are not present.
* `NULL` is printed as an empty string.
* Numeric values, including `NaN`, are not enclosed in quotes.

```ls
string,empty_string,null,number,number(NaN)
"hello","",,10.3,NaN
```

### Metadata

The response can include optional metadata to assist API clients in processing results, for example to convert text values in CSV or JSON field values into language-specific data types.

The metadata is specified as JSON-LD (JSON linked data) according to the [W3C Model for Tabular Data](https://www.w3.org/TR/tabular-data-model/).

Download ATSD JSON-LD schema:

[![](./images/button-download.png)](https://www.axibase.com/schemas/2017/07/atsd.jsonld)

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

By default, results in JSON output format incorporate metadata. This includes table and column schema.

### Metadata in CSV Output Format

The `metadataFormat` parameter specifies how metadata is incorporated into a CSV response.

| **Value**| **Description** |
|:---|:---|
| `NONE` | Do not include metadata in the response. |
| `HEADER` | **[Default]** Add JSON-LD metadata to the Base64 encoded `Link` header according to [W3C Model for Tabular Data](http://w3c.github.io/csvw/syntax/#link-header).<br>`<data:application/csvm+json;base64,eyJAY29...ifX0=>; rel="describedBy"; type="application/csvm+json"`<br>Maximum response header size is 12 KB. Do not use `Link` header option if the response contains many columns or columns with long names.|
| `EMBED` | Append JSON-LD metadata to CSV header as comments prefixed by hash symbol. |
| `COMMENTS` | Append CSV metadata to CSV header as comments prefixed by hash symbol. |

## Examples

### curl Query Example

```bash
curl https://atsd_hostname:8443/api/sql  \
  --insecure  --include --compressed \
  --user {username}:{password} \
  --data 'q=SELECT entity, value FROM "mpstat.cpu_busy" WHERE datetime > now - 1*MINUTE'
```

Use backslash `'\'` to escape single quotes inside the query payload.

```bash
curl https://atsd_hostname:8443/api/sql  \
  --insecure  --include --compressed \
  --user {username}:{password} \
  --data 'q=SELECT * FROM "mpstat.cpu_busy" WHERE entity =  '\''nurswghbs001'\'' AND datetime between '\''2018-03-01T17:00:00Z'\'' AND '\''2018-03-02T17:00:00Z'\'''
```

### bash Client Example

Execute query specified in a `query.sql` file and write CSV results to `/tmp/report-1.csv`.

```ls
./sql.sh -o /tmp/report-1.csv -i query.sql -f csv
```

Execute query specified inline and store results in `/tmp/report-2.csv`.

```ls
./sql.sh --output /tmp/report-2.csv --query "SELECT entity, value FROM \"mpstat.cpu_busy\" WHERE datetime > now - 1*minute LIMIT 3"
```

Review `bash` client [parameters](client/README.md).

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
