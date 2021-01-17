# Instrument Security Definitions

To insert metadata about an instrument into the database, send the [`property`](../api/network/property.md) command with type `security_definitions` to TCP port `8081` or UDP port `8082`.

```bash
echo -e "property e:gazp_[tqbr] t:security_definitions ms:1610604976193 v:symbol=GAZP v:tradingsessionid=TQBR v:roundlot=10" > /dev/tcp/atsd_hostname/8081
```

The commands must be terminated by line break. Multiple commands can be sent over the same connection.

The commands of type `security_definitions` are processed by the `security_definition_update` rule in the rule engine and are converted to entity commands.

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

Incoming commands are logged in `command.log` file by default.
