# Statistics Fields

<!-- markdownlint-disable MD101 -->

| Name | Code | Type | Description |
|----------|-----:|----------|--------|
| `accruedint` | 36 | DECIMAL | Accrued interest. |
| `admittedquote` | 53 | DECIMAL | Admitted quote. |
| `assured` | 37 | BOOLEAN | Is uncovered trading enabled. |
| `auctnumtrades` | 55 | LONG | Trades | Number of trades during the auction. |
| `auctprice` | 38 | DECIMAL | Auction price. Displays the expected price before the crossing, and the actual crossing price after the auction. |
| `auctvalue` | 41 | DECIMAL | Auction trade value. Displays expected value before the crossing and the total value of auction trades after the auction. |
| `auctvolume` | 31 | LONG | Auction trade volume. Displays expected volume before the crossing and the final volume after the auction. |
| `bid` | 10 | DECIMAL | Bid | Best bid price. |
| `biddepth` | 9 | LONG | Best bid size. Total unmatched volume of active buy orders at the best bid price. |
| `biddeptht` | 4 | LONG | Total volume of all active buy orders. |
| `biddeptht_0` | 78 | LONG | Total volume of all active buy orders without synthetic liquidity. |
| `change` | 20 | DECIMAL | Difference between the last price and the previous day last price. |
| `changetime` | 25 | TIME | Time when index value changed. |
| `chngclose` | 86 | DECIMAL | Difference between the last price and the previous day legal closing price. |
| `close_adj` | 107 | DECIMAL | Close price adjusted for dividends and splits.|
| `close` | 106 | DECIMAL | Close price.|
| `closeprice` | 60 | DECIMAL | Price of the closing period. |
| `closeyield` | 61 | DECIMAL | Yield at the closing period price. |
| `crossrate` | 84 | DECIMAL | Currency rate used in index value calculation. |
| `currentvalue` | 24 | DECIMAL | Current index value. |
| `darkpool` | 58 | BOOLEAN | Is venue lit or dark. |
| `duration` | 33 | LONG | Duration. |
| `high` | 42 | DECIMAL | Highest price during the trading day or the session. |
| `highbid` | 39 | DECIMAL | Highest bid price registered during the trading day or the session. |
| `highlimitpx` | 92 | DECIMAL | Upper price limit.
| `highval` | 49 | DECIMAL | Highest index value during the trading day or the session. |
| `icapital` | 73 | DECIMAL | Index Capitalization |
| `imbalance` | 34 | DECIMAL | Total volume of orders that are left unmatched if the auction ends with currently expected price. |
| `initialmarginonbuy` | 88 | DECIMAL | Collateral for buying an option. |
| `initialmarginonsell` | 89 | DECIMAL | Collateral for uncovered selling of option. |
| `initialmarginsyntetic` | 90 | DECIMAL | Collateral for covered options. |
| `iopen` | 64 | DECIMAL | Opening index Value. |
| `ivolume` | 74 | DECIMAL | Index volume during the trading day. |
| `last` | 16 | DECIMAL | Last trade price |
| `lastbid` | 11 | DECIMAL | Best buy price at the end of the session. |
| `lastoffer` | 12 | DECIMAL | Best offer price at the end of the session. |
| `lastvalue` | 72 | DECIMAL | Closing index value. |
| `lcloseprice` | 52 | DECIMAL | Official closing price |
| `lcurrentprice` | 29 | DECIMAL | Official current price |
| `low` | 47 | DECIMAL | Lowest trade price during the trading day or the session. |
| `lowlimitpx` | 91 | DECIMAL | Lower price limit.|
| `lowoffer` | 43 | DECIMAL |Best offer price during this trading session. |
| `lowval` | 62 | DECIMAL | Lowest index value. |
| `marketprice2` | 59 | DECIMAL | Market price (Method 2). |
| `marketprice` | 40 | DECIMAL | Previous day market price. |
| `marketpricetoday` | 46 | DECIMAL | Today market price |
| `marketvolb` | 57 | LONG | Total volume of market buy orders (MOO, MOC) during the auction. |
| `marketvols` | 56 | LONG | Total volume of market sell orders (MOO, MOC) during the auction. |
| `min_curr_last_ti` | 22 | TIME | Change time of the minimum current price |
| `min_curr_last` | 23 | DECIMAL | Minimum current price |
| `national_bid` | 93 | DECIMAL | National best bid price. NBB price. |
| `national_biddepth` | 95 | LONG | National best bid size. NBB size. |
| `national_offer` | 94 | DECIMAL | National best offer price. NBO price. |
| `national_offerdepth` | 96 | LONG | National best offer size. NBO offer size. |
| `nfaprice` | 85 | DECIMAL | NSMA Price. |
| `numbids_0` | 80 | LONG | Number of buy orders without synthetic liquidity. |
| `numbids` | 5 | LONG | Number of buy orders. |
| `numcontracts` | 71 | LONG | Number of contracts today |
| `numoffers_0` | 81 | LONG | Number of sell orders without synthetic liquidity. |
| `numoffers` | 2 | LONG | Number of sell orders. |
| `numtrades` | 14 | LONG | Number of trades today |
| `offer` | 7 | DECIMAL | Offer | Best offer price |
| `offerdepth` | 6 | LONG | Best offer size. Total unmatched volume of active sell orders at the best offer price. |
| `offerdeptht` | 3 | LONG | Total volume of all active sell orders. |
| `offerdeptht_0` | 79 | LONG | Total volume of all active sell orders without synthetic liquidity. |
| `open` | 50 | DECIMAL | Opening trade price. |
| `openinterest` | 105 | LONG | Open Interest. |
| `openperiodprice` | 63 | DECIMAL | Opening period price. |
| `plannedtime` | 35 | TIME | Planned auction time. |
| `prevadmittedquot` | 51 | DECIMAL | Officially admitted quote of the previous day. |
| `prevdate` | 32 | DATE | Previous trading day. |
| `prevlegalclosepr` | 54 | DECIMAL | Previous day legal closing price. |
| `prevprice` | 44 | DECIMAL |Price of the last trade on the previous trading day. |
| `prevsettlprice` | 70 | DECIMAL | Previous day settlement price. |
| `prevwaprice` | 45 | DECIMAL | Previous day weighted average price. |
| `priceminusprevwa` | 21 | DECIMAL | Difference between the last price and the weighted average price of the previous trading session. |
| `qty` | 17 | LONG | Volume of the last trade. |
| `repoterm` | 87 | INTEGER | Number of days between repo buyback date and trade date. |
| `root_bid` | 102 | DECIMAL | Root instrument bid price |
| `root_last` | 104 | DECIMAL | Root instrument last trade price |
| `root_offer` | 103 | DECIMAL | Root instrument offer |
| `settledate1` | 82 | DATE | Settlement date for the first trade in repo/swap. |
| `settledate2` | 83 | DATE | Settlement date for the second trade in repo/swap. |
| `settledate` | 75 | DATE | Settlement date |
| `settleprice` | 68 | DECIMAL | Settlement price|
| `settlpriceopen` | 97 | LONG | Settlement price at the start of the session. |
| `starttime` | 28 | TIME | Auction start time |
| `theorprice` | 67 | DECIMAL | Theoretical option price. |
| `theorpricelimit` | 69 | DECIMAL | Theoretical option price (limits adjusted) |
| `time` | 19 | TIME | Time of the last | Time of the last trade. |
| `tradingsession` | 8 | STRING | Trading session identifier. |
| `underlying_bid` | 99 | DECIMAL | Underlying instrument bid. |
| `underlying_last` | 101 | DECIMAL | Underlying instrument last trade price. |
| `underlying_offer` | 100 | DECIMAL | Underlying instrument offer. |
| `valtoday` | 13 | DECIMAL | Total trade value during the day. |
| `value` | 18 | DECIMAL | Trade value of the last trade. |
| `volatility` | 76 | DECIMAL | Option volatility. |
| `voltoday` | 15 | LONG | Today volume of trades today.|
| `vwap` | 98 | DECIMAL | Volume weighted average price.|
| `waprice` | 26 | DECIMAL | WAP | Weighted-average price reported by the exchange. |
| `yield` | 27 | DECIMAL | Yield-to-maturity based on the trade price. |
| `yieldatprevwapr` | 48 | DECIMAL | Yield-to-maturity based on the previous day VWAP price. |
| `yieldatwaprice` | 30 | DECIMAL | Yield-to-maturity based on the VWAP price. |
| `custom_num_01` | 254 | DECIMAL | Custom numeric field 1 |
| `custom_num_02` | 253 | DECIMAL | Custom numeric field 2 |
| `custom_num_03` | 252 | DECIMAL | Custom numeric field 3 |
| `custom_num_04` | 251 | DECIMAL | Custom numeric field 4 |
| `custom_num_05` | 250 | DECIMAL | Custom numeric field 5 |
| `custom_num_06` | 249 | DECIMAL | Custom numeric field 6 |
| `custom_num_07` | 248 | DECIMAL | Custom numeric field 7 |
| `custom_num_08` | 247 | DECIMAL | Custom numeric field 8 |
| `custom_num_09` | 246 | DECIMAL | Custom numeric field 9 |
| `custom_num_10` | 245 | DECIMAL | Custom numeric field 10 |
| `action` | 77 | STRING | Message Action |
| `rptseq_st` | 1 | LONG | Starting value of the Repeat Sequence |
| `rptseq` | 0 | LONG | Repeat Sequence |
| `snapshot_datetime` | 65 | DATETIME | Snapshot Datetime |
| `snapshot_start_datetime` | 66 | DATETIME | Datetime of the first snapshot in current series |

```sql
SELECT name,
  STAT.accruedint,
  STAT.action,
  STAT.admittedquote,
  STAT.assured,
  STAT.auctnumtrades,
  STAT.auctprice,
  STAT.auctvalue,
  STAT.auctvolume,
  STAT.bid,
  STAT.biddepth,
  STAT.biddeptht,
  STAT.biddeptht_0,
  STAT.change,
  STAT.changetime,
  STAT.chngclose,
  STAT.close,
  STAT.close_adj,
  STAT.closeprice,
  STAT.closeyield,
  STAT.crossrate,
  STAT.currentvalue,
  STAT.custom_num_01,
  STAT.custom_num_02,
  STAT.custom_num_03,
  STAT.custom_num_04,
  STAT.custom_num_05,
  STAT.custom_num_06,
  STAT.custom_num_07,
  STAT.custom_num_08,
  STAT.custom_num_09,
  STAT.custom_num_10,
  STAT.darkpool,
  STAT.datetime,
  STAT.duration,
  STAT.high,
  STAT.highbid,
  STAT.highlimitpx,
  STAT.highval,
  STAT.icapital,
  STAT.imbalance,
  STAT.initialmarginonbuy,
  STAT.initialmarginonsell,
  STAT.initialmarginsyntetic,
  STAT.iopen,
  STAT.ivolume,
  STAT.last,
  STAT.lastbid,
  STAT.lastoffer,
  STAT.lastvalue,
  STAT.lcloseprice,
  STAT.lcurrentprice,
  STAT.low,
  STAT.lowlimitpx,
  STAT.lowoffer,
  STAT.lowval,
  STAT.marketprice,
  STAT.marketprice2,
  STAT.marketpricetoday,
  STAT.marketvolb,
  STAT.marketvols,
  STAT.min_curr_last,
  STAT.min_curr_last_ti,
  STAT.national_bid,
  STAT.national_biddepth,
  STAT.national_offer,
  STAT.national_offerdepth,
  STAT.nfaprice,
  STAT.numbids,
  STAT.numbids_0,
  STAT.numcontracts,
  STAT.numoffers,
  STAT.numoffers_0,
  STAT.numtrades,
  STAT.offer,
  STAT.offerdepth,
  STAT.offerdeptht,
  STAT.offerdeptht_0,
  STAT.open,
  STAT.openinterest,
  STAT.openperiodprice,
  STAT.plannedtime,
  STAT.prevadmittedquot,
  STAT.prevdate,
  STAT.prevlegalclosepr,
  STAT.prevprice,
  STAT.prevsettlprice,
  STAT.prevwaprice,
  STAT.priceminusprevwa,
  STAT.qty,
  STAT.repoterm,
  STAT.root_bid,
  STAT.root_last,
  STAT.root_offer,
  STAT.rptseq,
  STAT.rptseq_st,
  STAT.settledate,
  STAT.settledate1,
  STAT.settledate2,
  STAT.settleprice,
  STAT.settlpriceopen,
  STAT.snapshot_datetime,
  STAT.snapshot_start_datetime,
  STAT.starttime,
  STAT.theorprice,
  STAT.theorpricelimit,
  STAT.time,
  STAT.tradingsession,
  STAT.underlying_bid,
  STAT.underlying_last,
  STAT.underlying_offer,
  STAT.valtoday,
  STAT.value,
  STAT.volatility,
  STAT.voltoday,
  STAT.vwap,
  STAT.waprice,
  STAT.yield,
  STAT.yieldatprevwapr,
  STAT.yieldatwaprice
FROM atsd_entity
  WHERE tags.class_code = 'IEXG' AND tags.symbol = 'TSLA'
```