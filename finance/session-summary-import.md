# Trades

## Description

Insert session summary records for the instrument in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trade-session-summary/import` |

### Request Parameters

| Name | Default Value | Description |
|---|---|---|
| `add_new_instruments` | `false` | Insert trades for the instrument if the instrument is not yet created in ATSD |

The parameters can be set as follows:

* Both file and parameters as `multipart/form-data` elements, or
* Parameters in query string, file content in body

### Content

The file can be attached as `multipart/form-data` element or as text content in payload.

The content must start with a header containing `datetime`, `symbol`, `class`, `exchange`, `type`, `stage`  columns and at least one [statistics](statistics-fields.md) column name.

```txt
datetime,exchange,class,symbol,type,stage,open,high,low,closeprice,voltoday,vwap
2021-02-10T20:45:00.000Z,CBOE,XCBO,VIX20210216P00035000,Day,C,10.22,10.74,10.01,10.50,34502,10.456
2021-02-10T20:45:00.000Z,CBOE,XCBO,VIX20210216P00040000,Day,C,15.12,15.64,15.01,15.54,18103,15.482
```

## Example

### curl

```sh
curl --insecure --include --user {username}:{password} -X POST \
  -F 'data=@summary.csv' \
  -F 'add_new_instruments=true' \
  'https://atsd_hostname:8443/api/v1/trade-session-summary/import'
```