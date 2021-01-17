# Trades

## Description

Deletes trades for the instrument.

The deleted trades are not physically removed from the database until a corresponding [administrative action](#physical-deletion) is permformed against the `atsd_trade` table.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trades/delete` |

### Payload

```json
{
  "class": "<class-name>",
  "symbol": "<symbol>",
  "exchange": "<exchange>",
  "startDate": "<start date in ISO format>",
  "endDate": "<end date in ISO format>"
}
```

`endDate` is inclusive.

To delete trades for **all** instruments within the class, omit the `symbol` parameter and add `multipleInstruments` set to `true` to the payload.

```json
{
  "class": "<class-name>",
  "multipleInstruments": "true",
  "exchange": "<exchange>",
  "startDate": "<start date in ISO format>",
  "endDate":   "<end date in ISO format>"
}
```

## Logging

Deleted trades are logged in `deleted_trades.log` file using the format:

```txt
<delete timestamp>;<hour timestamp>;<Instrument specification>
trade_command
trade_command
...
```

```txt
2021-01-17T12:23:53.312Z;2020-12-12T11:00:00Z;Instrument(id=32, symbol=GAZP, class=TQBR, exchange=MOEX)
3406495814,1607773266798,435,TQBR,GAZP,MOEX,S,1,199,293,N
3406495817,1607773286767,32,TQBR,GAZP,MOEX,B,1,202.8,282,N
```

## Example

### Request

#### curl

```bash
curl --insecure --request POST 'https://atsd_hostname:8443/api/v1/trades/delete' \
--header 'Authorization: Bearer <token>' \
--header 'Content-Type: application/json' \
--data-raw '{
  "class":    "TQBR",
  "symbol":   "GAZP",
  "exchange": "MOEX",
  "startDate": "2020-12-12T00:00:00.000+03:00",
  "endDate":   "2020-12-12T59:59:59.999+03:00"
}'
```

## Physical_deletion

Disable tombstone protection.

```bash
echo "alter 'atsd_trade', NAME => 'd', KEEP_DELETED_CELLS => false" | /opt/atsd/hbase/bin/hbase shell
```

Initiate major compaction.

```bash
echo "major_compact 'atsd_trade'" | /opt/atsd/hbase/bin/hbase shell
```

Wait until major compaction is completed. Watch for `Completed major compaction` message.

```bash
tail -n 100 -F /opt/atsd/hbase/logs/* | grep atsd_trade
```

Re-enable tombstone protection.

```bash
echo "alter 'atsd_trade', NAME => 'd', KEEP_DELETED_CELLS => true" | /opt/atsd/hbase/bin/hbase shell
```

Verify that protection is enabled: `KEEP_DELETED_CELLS => 'TRUE'`

```bash
echo "describe 'atsd_trade'" | /opt/atsd/hbase/bin/hbase shell
```