# Command Insert

## Description

Submit data commands in Network API syntax over HTTP.

Multiple commands can be submitted as a batch in one request, separated by a line feed character.

Commands are parsed, validated and processed sequentially.

In case of syntax errors or an out-of-range date in one of commands, the invalid command is discarded and processing continues.

> Note that processing behavior is different from the Data Entry page which terminates processing on the first invalid or out-of-range command.

The method returns a JSON object containing the counters of failed, successful, and total commands.

Supported Network API commands:

* [series](../../../api/network/series.md)
* [property](../../../api/network/property.md)
* [message](../../../api/network/message.md)
* [metric](../../../api/network/metric.md)
* [entity](../../../api/network/entity.md)

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/command` | `text/plain` |

### Query String Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| commit   | boolean   | Store the commands synchronously and return the response after the commands have been committed to the underlying storage. Default: false.|

### Payload

List of network commands (series, metric, property, etc.), separated by line feed.

## Response

### Fields

```json
{"fail":2, "success":10, "total":12}
```

## Example

### Request

#### URI

```elm
POST /api/v1/command
```

#### Payload

```ls
series e:DL1866 m:speed=650 m:altitude=12300
property e:abc001 t:disk k:name=sda v:size=203459 v:fs_type=nfs
series e:DL1867 m:speed=450 m:altitude=12100
message e:server001 d:2015-03-04T12:43:20+00:00 t:subject="my subject" m:"Hello, world"
```

### Response

```json
{"fail":0,"success":4,"total":4}
```

## Java Example

* [Command Insert](https://github.com/axibase/atsd/tree/master/api/data/ext/examples/DataApiCommandInsertExample.java)

## Additional Examples

### curl

```bash
curl https://atsd_hostname:8443/api/v1/command \
  --insecure --include --user collector:******** \
  --header "Content-Type: text/plain" \
  --data-binary $'series e:DL1866 m:speed=650 m:altitude=12300\nproperty e:abc001 t:disk k:name=sda v:size=203459 v:fs_type=nfs'
```
