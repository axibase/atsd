# Instrument Entity Tags

To insert instrument tags, send the [`entity`](../api/network/entity.md) command to port `8081` (TCP) or port `8082` (UDP).

```bash
echo -e "entity e:gazp_[tqbr] t:symbol=GAZP t:class_code=TQBR t:lot=100" > /dev/tcp/atsd_hostname/8081
```

The commands must be terminated by line break. Multiple commands can be sent over the same connection.

Refer to [`Network API Overview`](../api/network/README.md) for details on how to send network commands.

## Format

```bash
entity e:<symbol>_[<class>] t:key=value [ t:key=value]
```

## Example

```ls
entity e:ru000a102az7_[tqcb] t:symbol=RU000A102AZ7 t:class_code=TQCB t:name="ВЭБ.РФ ПБО-001Р-К277" t:short_name=ВЭБ1P-К277 t:lot=1 t:step=0.01 t:scale=2 t:isin=RU000A102AZ7 t:cfi_code=DBXXXX t:regnumber=4B02-298-00004-T-001P t:issue_size=20000000 t:face_value=1000 t:currency=RUB t:trade_currency=RUB t:list_level=1 t:mat_date=20210204 t:nextcoupon=20210204 t:couponperiod=21 t:couponvalue=235
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

Network commands are [logged](../administration/logging.md) in `command.log` file located in the `./atsd/logs` directory.

```sh
# search today's archives and the current command.log sorted by time
ls -rt command.$(date '+%Y-%m-%d').* command.log | xargs zgrep -ih "entity e:.*t:clas"
```

## Validating Results

* UI:

```elm
https://atsd_hostname:8443/entities/GAZP_[TQBR]
```

* SQL:

```sql
SELECT name, label, date_format(creationTime, 'iso') AS createdDate, date_format(versionTime, 'iso') AS versionDate,
  tags.class_code, tags.symbol, tags.name, tags.short_name, tags.lot, tags."step", tags.scale, tags.currency, tags.trade_currency
FROM atsd_entity
  WHERE tags.class_code = 'TQBR' AND tags.symbol = 'GAZP'
```

* API using [`entity get`](../api/meta/entity/get.md) endpoint:

```elm
GET /api/v1/entities/GAZP_[GAZP]
```