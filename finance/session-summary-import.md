# Insert Snapshots

## Description

Insert order book snapshots in CSV format.

An order book snapshot describes the book state at a particular point of time during the trading day and can include a large set of current and intraday [statistics](statistics-fields.md). It is primarily used to capture the book state at the start and the end of trading sessions and auction stages.

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

The content must start with a header containing `datetime`, `symbol`, `class`, `exchange`, `type`, [`stage`](command-trade-insert.md#trading-session-codes) columns and at least one [statistics](statistics-fields.md) column name.

```txt
datetime,exchange,class,symbol,type,stage,close,openinterest
2021-02-10T20:45:00.000Z,CBOE,XCBO,VIX20210216P00035000,Day,N,10.22,34502
2021-02-10T20:45:00.000Z,CBOE,XCBO,VIX20210216P00040000,Day,N,15.12,18103
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

* API using [`trade-session-summary/export`](./session-summary-export.md) endpoint:

```elm
GET /api/v1/trades?class=XCBO&symbol=VIX20210216P00035000,VIX20210216P00040000&startDate=2021-02-10T00%3A00%3A00Z&endDate=2021-02-11T00%3A00%3A00Z
```

```txt
datetime,class,symbol,close,openinterest
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00035000,10.22,34502
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00040000,15.12,18103
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
WHERE class = 'XCBO' AND symbol IN ('VIX20210216P00035000', 'VIX20210216P00040000')
  AND type = 'Day' AND stage = 'N'
  AND datetime between '2021-02-10' AND '2021-02-11' EXCL
ORDER BY datetime
```