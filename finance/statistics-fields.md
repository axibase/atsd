# Statistics Fields

| Name | Code | Type | Short Name | Description |
|----------|-----:|----------|--------|---------|
| `rptseq` | 0 | LONG | Repeat Sequence | |
| `rptseq_st` | 1 | LONG | Starting value of the Repeat Sequence | |
| `numoffers` | 2 | LONG | Sell orders | Number of sell orders in the queue of the Trading System |
| `offerdeptht` | 3 | LONG | Total offer depth | Total unmatched volume of all active sell orders (expressed in lots) |
| `biddeptht` | 4 | LONG | Total bid depth | Total unmatched volume of all active buy orders, expressed in lots |
| `numbids` | 5 | LONG | Buy orders | Number of buy orders in the queue of the Trading System |
| `offerdepth` | 6 | LONG | Best offer depth | Volume of all sell orders at the best price, expressed in lots |
| `offer` | 7 | DECIMAL | Offer | Best offer price |
| `tradingsession` | 8 | STRING | Trading session | Current trading session ID |
| `biddepth` | 9 | LONG | Best bid depth | Total unmatched volume of all active buy orders at the current best bid price (expressed in number of lots) |
| `bid` | 10 | DECIMAL | Bid | Best bid price |
| `lastbid` | 11 | DECIMAL | Session best bid | Best buy-order at the time of the normal trading session end |
| `lastoffer` | 12 | DECIMAL | Session best offer | Best sell-order at the time of the normal trading session end |
| `valtoday` | 13 | DECIMAL | Today value | Value of concluded trades, expressed in the currency of settlement |
| `numtrades` | 14 | LONG | Trades today | Number of trades today |
| `voltoday` | 15 | LONG | Today volume | Volume of concluded trades, expressed in number of securities |
| `last` | 16 | DECIMAL | Last | Last trade price |
| `qty` | 17 | LONG | Lots in the last | Volume of the last trade, expressed in lots |
| `value` | 18 | DECIMAL | Value of the last | Value of the last trade in the current trading session, expressed in the currency of settlement |
| `time` | 19 | TIME | Time of the last | Time of the last trade |
| `change` | 20 | DECIMAL | Last to Previous day change | Difference between the Last Price and the Previous day Last Price |
| `priceminusprevwa` | 21 | DECIMAL | Last price to previous WA price | Difference between the last price and the weighted average price of the previous trading session |
| `min_curr_last_ti` | 22 | TIME | Min. cur. price change time | Change time of the minimum current price |
| `min_curr_last` | 23 | DECIMAL | Minimum current price | Minimum current price |
| `currentvalue` | 24 | DECIMAL | Current Value | Last index value |
| `changetime` | 25 | TIME | Change Time | Time when index value changed |
| `waprice` | 26 | DECIMAL | WA | Weighted-average price |
| `yield` | 27 | DECIMAL | Yield for the last | Yield, based on the trade price |
| `starttime` | 28 | TIME | Auction start time | Actual auction start time |
| `lcurrentprice` | 29 | DECIMAL | Current price | Official current price, calculated as the WA price of the trades concluded during the last 10 minutes of the trading session |
| `yieldatwaprice` | 30 | DECIMAL | Yield, based on the WA price | Yield, based on the WA price |
| `auctvolume` | 31 | LONG | Auction trade volume | Total volume of all trades, expressed in number of securities. Shows expected volume during the auction and the final volume once it finishes. |
| `prevdate` | 32 | DATE | Date of the last trading session | Date of the previous trading day |
| `duration` | 33 | LONG | Duration | Duration |
| `imbalance` | 34 | DECIMAL | Imbalance | Total volume of orders that are left unmatched if the auction ends with currently expected price |
| `plannedtime` | 35 | TIME | Planned Auction Time | Auction start time according to the trading schedule |
| `accruedint` | 36 | DECIMAL | Accrued interest |  |
| `assured` | 37 | BOOLEAN | Prevention of uncovered trading for security | |
| `auctprice` | 38 | DECIMAL | Auction price | Auction price. Displays the expected price of the auction with all the currently registered orders during the auction. Displays the actual auction price after the auction. |
| `highbid` | 39 | DECIMAL | Best bid | Best bid price during the trading session |
| `marketprice` | 40 | DECIMAL | Last day market price | Market price of the previous day. For the REPO boards – settlement price of the previous day. |
| `auctvalue` | 41 | DECIMAL | Auction trade value | Auction trade value, expressed in the currency of settlement. Shows expected value during the auction and the final value once it finishes. |
| `high` | 42 | DECIMAL | Maximum | Maximum trade price |
| `lowoffer` | 43 | DECIMAL | Best offer | Best offer price during this trading session |
| `prevprice` | 44 | DECIMAL | Last closing price | Price of the last trade of the previous trading day |
| `prevwaprice` | 45 | DECIMAL | Previous WA price | The weighted average price of the previous trading session |
| `marketpricetoday` | 46 | DECIMAL | Market price | Today market price |
| `low` | 47 | DECIMAL | Minimum | Minimum trade price |
| `yieldatprevwapr` | 48 | DECIMAL | Yield, based on the last day WA price | |
| `highval` | 49 | DECIMAL | Maximum | Maximum index value |
| `open` | 50 | DECIMAL | First | First trade price |
| `prevadmittedquot` | 51 | DECIMAL | Officially admitted quote of the last day | Officially admitted quote of the last day, price for one security |
| `lcloseprice` | 52 | DECIMAL | Closing price | Official closing price, calculated as the WA price of the trades concluded during the last 10 minutes of the trading session, including the closing period/closing auction |
| `admittedquote` | 53 | DECIMAL | Admitted quote | Officially admitted quote calculated in compliance with official Federal Commission for Financial Markets methodology |
| `prevlegalclosepr` | 54 | DECIMAL | Last day closing price | Last day legal closing price |
| `auctnumtrades` | 55 | LONG | Trades | Number of trades |
| `marketvols` | 56 | LONG | Market Sell | Total volume of market sell orders, expressed in number of securities |
| `marketvolb` | 57 | LONG | Market Buy | Total volume of market buy orders based on currently expected price, expressed in number of securities |
| `darkpool` | 58 | BOOLEAN | | |
| `marketprice2` | 59 | DECIMAL | Market price 2 | Market price calculated in compliance with official Federal Commission for Financial Markets methodology |
| `closeprice` | 60 | DECIMAL | Price of the Closing period | Unified price for the closing period of the current trading session (calculated according to the trading rules) |
| `closeyield` | 61 | DECIMAL | Yield at the closing period price | Yield at the closing period price |
| `lowval` | 62 | DECIMAL | Minimum | Minimum index value |
| `openperiodprice` | 63 | DECIMAL | Opening period price | Opening period/Closing auction price |
| `iopen` | 64 | DECIMAL | First | First Index Value |
| `snapshot_datetime` | 65 | DATETIME | Snapshot Datetime | |
| `snapshot_start_datetime` | 66 | DATETIME | Datetime of the first snapshot in current series | |
| `theorprice` | 67 | DECIMAL | Option theoretical price. | |
| `settleprice` | 68 | DECIMAL | Settlement price| |
| `theorpricelimit` | 69 | DECIMAL | Option theoretical price (limits adjusted) | |
| `prevsettlprice` | 70 | DECIMAL | Previous day settlement price | |
| `numcontracts` | 71 | LONG | Contracts today | Number of contracts today |
| `lastvalue` | 72 | DECIMAL | Closing | Index Value in the closing period |
| `icapital` | 73 | DECIMAL | Capitalization | Index Capitalization |
| `ivolume` | 74 | DECIMAL | Volume | Index Volume |
| `settledate` | 75 | DATE | Settlement date | Settlement date for derivatives |
| `volatility` | 76 | DECIMAL | Option volatility | |
| `action` | 77 | STRING | Message Action | |
| `biddeptht_0` | 78 | LONG | Total bid depth without synthetic liquidity | Total unmatched volume of non-synthetic buy orders (expressed in lots) |
| `offerdeptht_0` | 79 | LONG | Total offer depth without synthetic liquidity | Total unmatched volume of non-synthetic sell orders (expressed in lots) |
| `numbids_0` | 80 | LONG | Buy orders without synthetic liquidity | Number of non-synthetic buy orders in the queue of the Trading System |
| `numoffers_0` | 81 | LONG | Sell orders without synthetic liquidity | Number of non-synthetic sell orders in the queue of the Trading System |
| `settledate1` | 82 | DATE | Settlement date 1 | Settlement date for a trade or the first part of a REPO/swap trade |
| `settledate2` | 83 | DATE | Settlement date 2 | Settlement date for the second part of a REPO/swap trade |
| `crossrate` | 84 | DECIMAL | Index Cross Rate | Currency rate used in index value calculation |
| `nfaprice` | 85 | DECIMAL | NSMA Price | National Securities Market Association Price |
| `chngclose` | 86 | DECIMAL | Last to Closing change | Difference between the Last Price and the Previous day Legal Closing Price |
| `repoterm` | 87 | INTEGER | REPO Term | Number of days between REPO buyback date and trade date |
| `initialmarginonbuy` | 88 | DECIMAL | Collateral for buying | Underlying collateral for buying futures-style option |
| `initialmarginonsell` | 89 | DECIMAL | Collateral for uncovered selling | Underlying collateral for uncovered selling futures-style option |
| `initialmarginsyntetic` | 90 | DECIMAL | Collateral for covered options | Underlying collateral for one covered position in options |
| `lowlimitpx` | 91 | DECIMAL | Lower price limit.  | Lower price limit. Futures and calendar spreads.|
| `highlimitpx` | 92 | DECIMAL | Upper price limit. | Upper price limit. Futures and calendar spreads. |
| `national_bid` | 93 | DECIMAL | National best bid price. | NBBO bid price. |
| `national_offer` | 94 | DECIMAL | National best offer price. | NBBO offer price. |
| `national_biddepth` | 95 | LONG | National best bid size. | NBBO bid size in shares. |
| `national_offerdepth` | 96 | LONG | National best offer size. | NBBO offer size in shares. |
| `settlpriceopen` | 97 | LONG | Settlement price at the start of the session. | |