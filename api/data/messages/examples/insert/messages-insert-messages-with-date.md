# Message Insert with Date

## Description

Supported [ISO date](../../../../../shared/date-format.md#supported-formats) formats:

* `yyyy-MM-dd'T'HH:mm:ss[.S]'Z'`
* `yyyy-MM-dd'T'HH:mm:ss[.S]±hh[:]mm`

Milliseconds are optional.

## Request

### URI

```elm
POST /api/v1/messages/insert
```

### Payload

```json
[{
    "entity": "nurswgvml007",
    "type": "application",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "source": "atsd",
    "date": "2016-06-14T09:12:00.412Z"
}]
```
