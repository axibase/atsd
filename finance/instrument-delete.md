# Delete Instrument

## Description

Deletes the instrument and all its trades.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/instruments/delete` |

### Payload

| **Field Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Symbol. |
| `class` | **[Required]** Class. |
| `exchange` | **[Required]** Exchange. |
| `multipleInstruments` | Omit the `symbol` parameter and add `multipleInstruments` set to `true` to delete trades for **all** instruments within the class. |
| `deleteEntity` | Delete the underlying entity. Default is `false`. |

```json
{
  "class": "<class-name>",
  "symbol": "<symbol>",
  "exchange": "<exchange>"
}
```

To delete **all** instruments for the class, omit the `symbol` parameter and add `multipleInstruments` parameter set to `true`.

```json
{
  "class": "<class-name>",
  "multipleInstruments": true,
  "exchange": "<exchange>"
}
```

To delete the underlying entity for the instrument add `deleteEntity` parameter set to `true`.

```json
{
  "class": "<class-name>",
  "symbol": "<symbol>",
  "deleteEntity": true | false,
  "exchange": "<exchange>"
}
```

## Logging

Deleted instruments are logged in `deleted_instruments.log` file using the format:

```txt
2021-01-17T13:06:14.985Z;Instrument(id=4509, symbol=TSLA, class=IEXG, exchange=IEX)
```

Deleted trades are [logged](./trades-delete.md#logging) in `deleted_trades.log` file.

## Example

### Request

#### curl

```bash
curl --insecure --request POST 'https://atsd_hostname:8443/api/v1/instruments/delete' \
--header 'Authorization: Bearer ****' \
--header 'Content-Type: application/json' \
--data-raw '{
  "class":    "IEXG",
  "symbol":   "ZTEST",
  "exchange": "IEX"
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

<!-- markdownlint-disable MD101 -->
Verify that protection is enabled: `KEEP_DELETED_CELLS => 'TRUE'`
<!-- markdownlint-enable MD101 -->

```bash
echo "describe 'atsd_trade_instrument'" | /opt/atsd/hbase/bin/hbase shell
```