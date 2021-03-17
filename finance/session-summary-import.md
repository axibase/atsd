# Trades

## Description

Insert session summary records in CSV format.

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

* UI. Only last day's records are displayed:

```elm
https://atsd_hostname:8443/financial/instrument/properties/statistics?entity=GAZP_[TQBR]
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
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND type = 'Day' AND stage = 'N'
  AND datetime between '2021-02-15' and '2021-02-17'
ORDER BY datetime
```

* API using [`trade-session-summary/export`](./session-summary-export.md) endpoint:

```elm
POST /api/v1/trade-session-summary/export
```

Payload:

```json
{
    "startDate": "2021-02-15T00:00:00Z",
    "endDate":   "2021-02-17T00:00:00Z",
    "instruments": [{
        "symbol" : "TSLA", "class" : "IEXG"
    }],
    "stages": ["N", "O"],
    "sessions": ["DAY"],
    "fields": ["datetime", "entity", "stage", "open", "close", "high", "low", "voltoday"]
}
```