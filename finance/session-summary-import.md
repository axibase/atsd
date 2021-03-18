# Insert Snapshots

The endpoint inserts point-in-time order book snapshots in CSV format.

An order book snapshot describes the book state for the specified instrument at a particular point of time during the trading day. The snapshot can include a large set of current and intraday [statistics](statistics-fields.md) and is primarily used to capture the book state at the start and the end of trading sessions as well as during the auction stages.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trade-session-summary/import` |

### Request Parameters

| Name | Default Value | Description |
|---|---|---|
| `add_new_instruments` | `false` | Insert records for instruments that are not present in the database |

The payload parameters can be set as follows:

* Both file and parameters as `multipart/form-data` elements, or
* Parameters in query string, file content in body

### Content

The file can be attached as `multipart/form-data` element or as text content in payload.

The content must start with a header containing `datetime`, `symbol`, `class`, `exchange`, `session`, [`stage`](./sessions.md) columns and at least one [statistic](statistics-fields.md).

`session` if one of `Morning`, `Day`, `Evening`. If not specified, session and stage are set to `Day` and `N` respectively.

```txt
datetime,exchange,class,symbol,session,stage,auctvolume,auctprice,imbalance
2021-01-13T16:00:01.859-05:00,IEX,IEXG,TSLA,Day,E,34500,843.67,-8200
2021-01-13T16:00:01.859-05:00,IEX,IEXG,AAPL,Day,E,50100,128.91,15400
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

* API using [`trade-session-summary/export`](./session-summary-export.md) endpoint:

```elm
GET /api/v1/trade-session-summary/export?class=IEXG&symbol=TSLA,AAPL&stage=E&startDate=2021-01-13T00%3A00%3A00Z&endDate=2021-01-14T00%3A00%3A00Z&fields=datetime,class,symbol,session,stage,auctvolume,auctprice,imbalance
```

```txt
datetime,class,symbol,session,stage,auctvolume,auctprice,imbalance
2021-01-13T21:00:01.859Z,IEXG,TSLA,Day,E,34500,843.67,-8200
2021-01-13T21:00:01.859Z,IEXG,AAPL,Day,E,50100,128.91,15400
```

* SQL using [`atsd_session_summary`](./sql.md#atsd_trade-table) table:

```sql
SELECT datetime, class, symbol, type, stage,
    accruedint,
    action,
    admittedquote,
    assured,
    auctnumtrades,
    auctprice,
    auctvalue,
    auctvolume,
    bid,
    biddepth,
    biddeptht,
    biddeptht_0,
    change,
    changetime,
    chngclose,
    close,
    close_adj,
    closeprice,
    closeyield,
    crossrate,
    currentvalue,
    custom_num_01,
    custom_num_02,
    custom_num_03,
    custom_num_04,
    custom_num_05,
    custom_num_06,
    custom_num_07,
    custom_num_08,
    custom_num_09,
    custom_num_10,
    darkpool,
    datetime,  
    duration,
    high,
    highbid,
    highlimitpx,
    highval,
    icapital,
    imbalance,
    initialmarginonbuy,
    initialmarginonsell,
    initialmarginsyntetic,
    iopen,
    ivolume,
    last,
    lastbid,
    lastoffer,
    lastvalue,
    lcloseprice,
    lcurrentprice,
    low,
    lowlimitpx,
    lowoffer,
    lowval,
    marketprice,
    marketprice2,
    marketpricetoday,
    marketvolb,
    marketvols,
    min_curr_last,
    min_curr_last_ti,
    national_bid,
    national_biddepth,
    national_offer,
    national_offerdepth,
    nfaprice,
    numbids,
    numbids_0,
    numcontracts,
    numoffers,
    numoffers_0,
    numtrades,
    offer,
    offerdepth,
    offerdeptht,
    offerdeptht_0,
    open,
    openinterest,
    openperiodprice,
    plannedtime,
    prevadmittedquot,
    prevdate,
    prevlegalclosepr,
    prevprice,
    prevsettlprice,
    prevwaprice,
    priceminusprevwa,
    qty,
    repoterm,
    root_bid,
    root_last,
    root_offer,
    rptseq,
    rptseq_st,
    settledate,
    settledate1,
    settledate2,
    settleprice,
    settlpriceopen,
    snapshot_datetime,
    snapshot_start_datetime,
    starttime,
    theorprice,
    theorpricelimit,
    time,
    tradingsession,
    underlying_bid,
    underlying_last,
    underlying_offer,
    valtoday,
    value,
    volatility,
    voltoday,
    vwap,
    waprice,
    yield,
    yieldatprevwapr,
    yieldatwaprice
  FROM atsd_session_summary
WHERE class = 'IEXG' AND symbol IN ('TSLA', 'AAPL')
  AND type = 'Day' AND stage = 'E'
  AND datetime between '2021-01-13T00:00:00-05:00' AND '2021-01-14T00:00:00-05:00' EXCL
ORDER BY datetime
```