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
datetime,exchange,class,symbol,open,high,low,close,vwap,voltoday,numtrades
2021-01-13T21:00:00Z,IEX,IEXG,AAPL,128.76,131.45,128.49,130.89,130.5588,88636831,596230
2021-01-14T21:00:00Z,IEX,IEXG,AAPL,130.8,131,128.76,128.91,129.7381,89671755,651392
2021-01-13T21:00:00Z,IEX,IEXG,TSLA,852.76,860.47,832,854.41,846.5136,33312385,776362
2021-01-14T21:00:00Z,IEX,IEXG,TSLA,843.39,863,838.75,845,851.4645,31265746,695464
```

## Example

### curl

```sh
curl "https://atsd_hostname:8443/api/v1/trade-session-summary/import" \
  -F "data=@ohlcv-2021-03-21.csv" \
  -F "add_new_instruments=true" \
  -k --header "Authorization: Bearer ****"
```

## Validating Results

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
GET /api/v1/trade-session-summary/export?class=IEXG&symbol=TSLA,AAPL&startDate=2021-01-13T00%3A00%3A00Z&endDate=2021-01-15T00%3A00%3A00Z&fields=datetime,class,symbol,open,high,low,close,vwap,voltoday,numtrades
```

```txt
datetime,class,symbol,open,high,low,close,vwap,voltoday,numtrades
2021-01-13T21:00:00Z,SIP,AAPL,128.76,131.45,128.49,130.89,130.5588,88636831,596230
2021-01-14T21:00:00Z,SIP,AAPL,130.8,131,128.76,128.91,129.7381,89671755,651392
2021-01-13T21:00:00Z,SIP,TSLA,852.76,860.47,832,854.41,846.5136,33312385,776362
2021-01-14T21:00:00Z,SIP,TSLA,843.39,863,838.75,845,851.4645,31265746,695464
```