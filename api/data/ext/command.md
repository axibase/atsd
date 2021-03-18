# command

## Description

Accepts commands in [Network API](../../../api/network/README.md) syntax over HTTP.

Supported Network API commands:

* [series](../../../api/network/series.md)
* [property](../../../api/network/property.md)
* [message](../../../api/network/message.md)
* [metric](../../../api/network/metric.md)
* [entity](../../../api/network/entity.md)

The method returns a JSON object containing the counters of failed, successful, and total commands.

## Authorization

* `API_DATA_WRITE` role is required to send `series`, `property`, and `message` commands.
* `API_META_WRITE` role is required to send `metric` and `entity` commands.

In addition, the user must have [`write` permissions](../../../administration/user-authorization.md#entity-permissions) for the entity specified in the commands.

## Multiple Commands

Multiple commands, separated by a line feed character, can be submitted in one request in which case the commands are parsed, validated and processed sequentially.

In case of syntax errors or an out-of-range date in one of commands, the invalid command is discarded and processing continues.

The processing behavior is different from the **Data Entry** page, which stops processing on the first invalid command.

## Request

| Method| Path | `Content-Type` Header|
|:---|:---|---:|
| `POST` | `/api/v1/command` | `text/plain` |

### Query String Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `commit`   | boolean   | Store the commands synchronously and return the response after the commands have been stored.<br>Default: `false`.|

### Payload

List of network commands, separated by line breaks.

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
message e:server001 d:2018-03-04T12:43:20+00:00 t:subject="my subject" m:"Hello, world"
```

### Response

```json
{"fail":0,"success":4,"total":4}
```

## Java Example

* [Command Insert](examples/DataApiCommandInsertExample.java)

## Additional Examples

### curl

```bash
curl https://atsd_hostname:8443/api/v1/command \
  -k --user collector:******** \
  --header "Content-Type: text/plain" \
  --data-binary $'series e:DL1866 m:speed=650 m:altitude=12300\nproperty e:abc001 t:disk k:name=sda v:size=203459 v:fs_type=nfs'
```
