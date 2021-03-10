# Instrument Security Definitions

To insert metadata about an instrument into the database, send the [`property`](../api/network/property.md) command with type `security_definitions` to port `8081` (TCP) or port `8082` (UDP).

```bash
echo -e "property e:gazp_[tqbr] t:security_definitions ms:1610604976193 v:symbol=GAZP v:tradingsessionid=TQBR v:roundlot=10" > /dev/tcp/atsd_hostname/8081
```

The commands of type `security_definitions` are processed by the `security_definition_update` rule in the rule engine and are converted to entity commands.

The commands must be terminated by line break. Multiple commands can be sent over the same connection.

Refer to [`Network API Overview`](../api/network/README.md) for details on how to send network commands.

## Format

```bash
property e:<symbol>_[<class>] t:security_definitions ms:<unix_time> v:key=value [ v:key=value]
```

## Example

```ls
property e:gazp_[tqbr] t:security_definitions ms:1610604976193 v:symbol=GAZP v:securitytype=CS v:eveningsessiontradingallowed=1 v:securityid=RU0007661625 v:facevalue=5 v:encodedshortsecuritydesc="ГАЗПРОМ ао" v:securityidsource=4 v:lotdivider=1 v:pricetype=2 v:currency=RUB v:cficode=ESXXXX v:tradingsessionid=TQBR v:tradingsessionsubid=NA v:sec_scale=2 v:product=5 v:securitydesc=Gazprom v:minpriceincrement=0.01 v:statesecurityid=1-02-00028-A v:settlcurrency=RUB v:encodedsecuritydesc="""Газпром"" (ПАО) ао" v:sendercompid=MOEX v:settldate=20210118 v:ordernote=1 v:couponperiod=0 v:marketcode=FNDT v:nosharesissued=23673512900 v:securitytradingstatus=18 v:roundlot=10
```

## Required Tags

> While the property command in ATSD does not require any `v` tags to be set, the following tags are necessary for SQL and rule engine functions.

* `tradingsessionid`
* `symbol`
* `securitydesc`
* `encodedshortsecuritydesc`
* `encodedsecuritydesc`
* `roundlot`
* `sec_scale`
* `minpriceincrement`
* `currency`
* `settlcurrency`

## Logging

Network commands are [logged](../administration/logging.md) in `command.log` file located in the `./atsd/logs` directory.

```sh
# search today's archives and the current command.log sorted by time
ls -rt command.$(date '+%Y-%m-%d').* command.log | xargs zgrep -ih "property .* t:security_definitions"
```

## Validating Results

* UI:

```elm
https://atsd_hostname:8443/financial/instrument/properties/security_definitions?entity=GAZP_[TQBR]
```

* SQL using [`SEC_DEF`](./sql.md#sec_def) function accessible in `atsd_trade`, `atsd_entity`, `atsd_session_summary` tables:

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
  WHERE tags.class_code = 'TQBR' AND tags.symbol = 'GAZP'
```

* API using [`property query`](../api/data/properties/query.md) endpoint:

```elm
POST /api/v1/properties/query
```

```json
[{
  "type": "security_definitions",
  "entity": "gazp_[tqbr]",
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "merge": true
}]
```