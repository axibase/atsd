# CSV File Upload

## Description

Accepts a CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser.

The files can be uploaded in plain text or compressed with the gzip or zip codecs.

Multiple files can be archived with zip/tar and uploaded as one zip or tar.gz archive.

This method supports processing of the uploaded attached file as data as well as a part in a multi-part payload.

## Size Limit

* Maximum file size is **1 gigabyte**.

> If the input file is larger than 1 GB, consider compressing it so that its size is within the threshold or splitting it into multiple smaller files, uploaded separately.

## Date Limits

* Minimum time that can be stored in the database is **1970-01-01T00:00:00.000Z**, or 0 milliseconds from Unix time.
* Maximum date that can be stored by the database is **2106-02-07T06:59:59.999Z**, or 4294969199999 milliseconds from Unix time.
* If the date is outside of the above range, file processing terminates at the line containing invalid date and a corresponding error is raised for the client.

## Request

| **Method** | **Path** |
|:---|:---|
| POST | `/api/v1/csv` |

### Headers

#### File Data Mode

|**Header**|**Value**|
|:---|:---|
| Content-Type | `text/csv` - for plain text CSV file.<br>`application/zip` - for compressed zip file and archive (**.zip**)<br>`application/gzip` or `application/x-gzip` - for compressed gzip file (**.gz**) or archive (**.tar.gz**).|

#### Multi-part Mode

|**Header**|**Value**|
|:---|:---|
| Content-Type | `multipart/*`, for example `multipart/form-data` or  `multipart/mixed`. <br>Content type for the file part itself must be set as described in [File Data Mode](#file-data-mode) above.|

### Query String Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `config`   | string   | [**Required**] Parser Name as configured on **Data > CSV Parsers** page.|
| `encoding`      | string   | File encoding. Default: UTF-8.|
| `filename`      | string   | [**Required** for archived files uploaded in File Data mode] <br>Name of the file or archive being sent, for example text.csv, files.zip, files.tar.gz.<br>The archive can contain multiple files, all of which are processed.<br>Archive compression is determined based on file extension.<br>Supported archive formats: zip and tar.gz.<br>Supported file extensions for the uploaded archive: .gz, .tar.gz, .zip.  |
| `default-entity`| string | Default entity name applied to commands contained in the file. |
| `entity-prefix` | string | Prefix added to all entity names extracted from the file. |
| `entity-tags` | string | Comma-separated list of entity tags added as series, message, or property tags to parsed commands. |
| `default-metric`| string | Default metric name applied to values in the numeric column contained in the file. |
| `metric-prefix` | string | Prefix added to all metric names extracted from the file. |
| `metric-tags` | string | Comma-separated list of metric tags added as series, message, or property tags to parsed commands. |
| `wait` | boolean | Wait until processing of the file into commands is completed by the server.<br>Default: `true`.<br>If wait is disabled, the file is processed by the server asynchronously. |
| `rules` | boolean | Process commands in the rule engine.<br>Default: `true`. |
| `time` | string | Date in ISO format or using [calendar](../../../shared/calendar.md) keywords applies to commands if the file does not contain a time column. |
| `timezone` | string | Time zone applied to timestamps specified in local time. |
| `test` | boolean | Parse and validate the file without actually processing and storing commands.<br>Default: `false`. |
| `t:{name}` | string | One or multiple default tags, inserted as series/property/message tags depending on command type, for example: `&t:location=SVL&t:site=QB1`.<br>Tag names must not contain whitespace. |

### Payload

* File attached as data; or
* Multi-part content containing the file. Part name containing the uploaded file must be named `filedata` and include the `filename` parameter:

```txt
Content-Disposition: form-data; name="filedata"; filename="arch.tar.gz"
```

## Response

The response contains a JSON object containing parsing results.

### Fields

|**Name**|**Value**|
|:---|:---|
| `startTime` | Time when parsing stated. |
| `endTime` | Time when parsing finished. |
| `processed` | Number of lines read from the file. |
| `source` | IP address from which the request was received. |
| `parser` | Parser name. |
| `errorMessage` | Error message occurred while parsing the file. |
| `taskStatus` | Parser task status. |
| `type` | Action type |
| `fileName` | Temporary file name assigned by the database. |
| `fileCount` | File count. The count can be greater than `1` if the uploaded file is an archive. |
| `fileSize` | Size of the uploaded file, in bytes. |

In case of error, the response object is returned as follows:

```json
{"error":"IllegalArgumentException: Configuration with name = 'parser-12' not found"}
```

## Processing

* Names (metric name, property type, key names, tag names) containing non-printable characters are normalized by replacing them with underscore.

## Example

### Request

#### URI

```elm
POST /api/v1/csv?config=my-parser&default-entity=nurswgvml007
```

#### Payload

```ls
time,cpu_user,cpu_system,waitio
1423139581000,12.4,1.4,0
1423139592016,16.0,4.2,0
```

### Response

```json
{
    "startTime": 1471337579825,
    "endTime": 1471337579826,
    "processed": 3,
    "source": "192.0.2.7",
    "parser": "my-parser",
    "errorMessage": null,
    "taskStatus": "COMPLETED",
    "type": "upload",
    "fileName": "csv-upload-6385580066693691391.csv",
    "fileCount": 1,
    "fileSize": 83
}
```

## Additional Examples

### curl upload

```sh
curl --insecure -X POST --user admin:pwd \
  -T csv-3120.csv "https://atsd_hostname:8443/api/v1/csv?config=parser-3120&wait=true"
```

> Make sure that request parameter values in query string are URL-encoded, for example `&time=now%20-%201%20*%20hour`
