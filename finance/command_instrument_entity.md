# Instrument Entity Tags

To insert instrument tags, send the [`entity`](../api/network/entity.md) command to TCP port `8081` or UDP port `8082`.

```bash
echo -e "property e:gazp_[tqbr] t:security_definitions ms:1610604976193 v:symbol=GAZP v:tradingsessionid=TQBR v:roundlot=10" > /dev/tcp/atsd_hostname/8081
```

The commands must be terminated by line break. Multiple commands can be sent over the same connection.

## Format

```bash
entity e:<symbol>_[<class>] ms:<unix_time> t:key=value [ t:key=value]
```

## Example

```ls
entity e:ru000a102az7_[tqcb] l:"TQCB:RU000A102AZ7" t:symbol=RU000A102AZ7 t:class_code=TQCB t:name="ВЭБ.РФ ПБО-001Р-К277" t:short_name=ВЭБ1P-К277 t:lot=1 t:step=0.01 t:scale=2 t:isin=RU000A102AZ7 t:cfi_code=DBXXXX t:regnumber=4B02-298-00004-T-001P t:issue_size=20000000 t:face_value=1000 t:currency=RUB t:trade_currency=RUB t:list_level=1 t:mat_date="20210204" t:nextcoupon=20210204 t:couponperiod=21 t:couponvalue=235"
```

## Required Tags

> While the `entity` command in ATSD does not require any tags to be set, the following tags are necessary for SQL and rule engine functions.

* `class_code`
* `symbol`
* `name`
* `short_name`
* `lot`
* `step`
* `scale`
* `currency`
* `trade_currency`

## Logging

Incoming commands are logged in `command.log` file by default.