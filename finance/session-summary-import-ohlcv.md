# Import OHLCV Bars

## Description

Insert OHLCV bars in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trade-session-summary/import` |

### Request Parameters

| Name | Default Value | Description |
|---|---|---|
| `add_new_instruments` | `false` | Insert trades for the instrument if the instrument is not yet created in ATSD |

The payload and parameters can be sent as follows:

* Both file and parameters as `multipart/form-data` elements, or
* Parameters in query string, file content in body

### Content

The content must start with a header containing `datetime`, `exchange`, `class`, `symbol`, `type`, [`stage`](command-trade-insert.md#trading-session-codes) columns and at least one OHLCV parameter: `open`, `high`, `low`, `close`, `close_adj`, `voltoday`, `vwap`, `numtrades`, `valtoday`.

```txt
datetime,exchange,class,type,stage,symbol,open,high,low,close,vwap,voltoday,numtrades
2021-03-12T21:00:00Z,IEX,IEXG,Day,N,TSLA,670,694.88,666.1394,693.73,683.4197,33583840,1009438
2021-03-12T21:00:00Z,IEX,IEXG,Day,N,AAPL,120.4,121.17,119.16,121.03,120.2455,87955050,762384
```

```txt
datetime,exchange,class,type,stage,symbol,close_adj
2021-03-12T21:00:00Z,IEX,IEXG,Day,N,TSLA,693.73
2021-03-12T21:00:00Z,IEX,IEXG,Day,N,AAPL,121.03
```

## Example

### curl

```sh
curl --insecure --include --user {username}:{password} -X POST \
  -F 'data=@summary.csv' \
  -F 'add_new_instruments=true' \
  'https://atsd_hostname:8443/api/v1/trade-session-summary/import'
```

## Validating Results

* UI. Only last day's records are displayed:

```elm
https://atsd_hostname:8443/financial/instrument/properties/statistics?entity=TSLA_[IEXG]
```

* SQL using [`atsd_session_summary`](./sql.md#atsd_trade-table) table:

```sql
SELECT datetime, class, symbol, type, stage,
    open, high, low, close, close_adj, voltoday, vwap, numtrades, valtoday
  FROM atsd_session_summary
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND type = 'Day' AND stage = 'N'
  AND datetime between '2021-03-12' and '2021-03-15'
ORDER BY datetime
```

* API using [`trade-session-summary/export`](./session-summary-export.md) endpoint:

```elm
GET /api/v1/trades?class=XCBO&symbol=VIX20210216P00035000,VIX20210216P00040000&startDate=2021-02-10T00%3A00%3A00Z&endDate=2021-02-11T00%3A00%3A00Z&fields=datetime,class,symbol,close
```

```txt
datetime,class,symbol,close
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00035000,10.22,34502
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00040000,15.12,18103
```