# Security Definitions

```ls
| Type    | Name                         |
|---------|------------------------------|
| Number  | contractmultiplier           |
| Number  | couponperiod                 |
| Number  | dividendnetpx                |
| Number  | exchangetradingsessionid     |
| Number  | facevalue                    |
| Number  | flags                        |
| Number  | highlimitpx                  |
| Number  | initialcapitalization        |
| Number  | initiald                     |
| Number  | initialmarginonbuy           |
| Number  | initialmarginonsell          |
| Number  | initialmarginsyntetic        |
| Number  | initialvalue                 |
| Number  | lowlimitpx                   |
| Number  | minpriceincrement            |
| Number  | minpriceincrementamount      |
| Number  | nosharesissued               |
| Number  | ordernote                    |
| Number  | pricetype                    |
| Number  | product                      |
| Number  | roundlot                     |
| Number  | sec_scale                    |
| Number  | securityidsource             |
| Number  | securitytradingstatus        |
| Number  | strikeprice                  |
| Number  | theorprice                   |
| Number  | theorpricelimit              |
| Number  | underlyingfutureid           |
| Number  | underlyingsecurityid         |
| Number  | volatility                   |
| Integer | lotdivider                   |
| Boolean | eveningsessiontradingallowed |
| Boolean | mainsessiontrading           |
| Boolean | nonanonymoustradingallowed   |
| Boolean | multileg                     |
| String  | anonymoustradingallowed      |
| String  | auctionindicator             |
| String  | cficode                      |
| String  | currency                     |
| String  | datetime                     |
| String  | encodedsecuritydesc          |
| String  | encodedshortsecuritydesc     |
| String  | firsttradedate               |
| String  | iqstradingallowed            |
| String  | lasttradedate                |
| String  | marketcode                   |
| String  | marketid                     |
| String  | marketsegmentid              |
| String  | maturitydate                 |
| String  | maturitytime                 |
| String  | minpriceincrementamountcurr  |
| String  | securityaltid                |
| String  | securityaltidsource          |
| String  | securitydesc                 |
| String  | securityid                   |
| String  | securitytype                 |
| String  | sendercompid                 |
| String  | settlcurrency                |
| String  | settldate                    |
| String  | settlfixingdate              |
| String  | settlpriceopen               |
| String  | statesecurityid              |
| String  | symbol                       |
| String  | tradingsessionid             |
| String  | tradingsessionsubid          |
| String  | underlyingsymbol             |
```

```sql
SELECT name,
SEC_DEF.anonymoustradingallowed,
SEC_DEF.auctionindicator,
SEC_DEF.cficode,
SEC_DEF.contractmultiplier,
SEC_DEF.couponperiod,
SEC_DEF.currency,
SEC_DEF.datetime,
SEC_DEF.dividendnetpx,
SEC_DEF.encodedsecuritydesc,
SEC_DEF.encodedshortsecuritydesc,
SEC_DEF.eveningsessiontradingallowed,
SEC_DEF.exchangetradingsessionid,
SEC_DEF.facevalue,
SEC_DEF.firsttradedate,
SEC_DEF.flags,
SEC_DEF.highlimitpx,
SEC_DEF.initialmarginonbuy,
SEC_DEF.initialmarginonsell,
SEC_DEF.iqstradingallowed,
SEC_DEF.lasttradedate,
SEC_DEF.lotdivider,
SEC_DEF.lowlimitpx,
SEC_DEF.mainsessiontrading,
SEC_DEF.marketcode,
SEC_DEF.marketid,
SEC_DEF.marketsegmentid,
SEC_DEF.maturitydate,
SEC_DEF.maturitytime,
SEC_DEF.minpriceincrement,
SEC_DEF.minpriceincrementamount,
SEC_DEF.minpriceincrementamountcurr,
SEC_DEF.multileg,
SEC_DEF.nonanonymoustradingallowed,
SEC_DEF.nosharesissued,
SEC_DEF.ordernote,
SEC_DEF.pricetype,
SEC_DEF.product,
SEC_DEF.roundlot,
SEC_DEF.sec_scale,
SEC_DEF.securityaltid,
SEC_DEF.securityaltidsource,
SEC_DEF.securitydesc,
SEC_DEF.securityid,
SEC_DEF.securityidsource,
SEC_DEF.securitytradingstatus,
SEC_DEF.securitytype,
SEC_DEF.sendercompid,
SEC_DEF.settlcurrency,
SEC_DEF.settldate,
SEC_DEF.settlfixingdate,
SEC_DEF.settlpriceopen,
SEC_DEF.statesecurityid,
SEC_DEF.symbol,
SEC_DEF.tradingsessionid,
SEC_DEF.tradingsessionsubid,
SEC_DEF.underlyingsymbol
FROM atsd_entity
  WHERE tags.class_code = '<class>' AND tags.symbol = '<symbol>'
```