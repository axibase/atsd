# Trades

## Description

Deletes the instrument and all its trades.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/instruments/delete` |

### Payload

```json
{
  "class": "<class-name>",
  "symbol": "<symbol>",
  "exchange": "<exchange>"
}
```

To delete **all** instruments for the class, omit the `symbol` parameter and add `multipleInstruments` set to `true` to the payload.

```json
{
  "class": "<class-name>",
  "multipleInstruments": "true",
  "exchange": "<exchange>"
}
```

## Logging

Deleted instruments are logged in `deleted_instruments.log` file using the format:

```txt
2021-01-17T13:06:14.985Z;Instrument(id=4509, symbol=GAZP, class=TQBR, exchange=MOEX)
```

Deleted trades are [logged](./trades-delete.md#logging) in `deleted_trades.log` file.

## Example

### Request

#### curl

```bash
curl --insecure --request POST 'https://atsd_hostname:8443/api/v1/instruments/delete' \
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
echo "alter 'atsd_trade_instrument', NAME => 'd', KEEP_DELETED_CELLS => false" | /opt/atsd/hbase/bin/hbase shell
```

Initiate major compaction.

```bash
echo "major_compact 'atsd_trade_instrument'" | /opt/atsd/hbase/bin/hbase shell
```

Wait until major compaction is completed. Watch for `Completed major compaction` message.

```bash
tail -n 100 -F /opt/atsd/hbase/logs/* | grep atsd_trade_instrument
```

Re-enable tombstone protection.

```bash
echo "alter 'atsd_trade_instrument', NAME => 'd', KEEP_DELETED_CELLS => true" | /opt/atsd/hbase/bin/hbase shell
```

Verify that protection is enabled: `KEEP_DELETED_CELLS => 'TRUE'`

```bash
echo "describe 'atsd_trade_instrument'" | /opt/atsd/hbase/bin/hbase shell
```