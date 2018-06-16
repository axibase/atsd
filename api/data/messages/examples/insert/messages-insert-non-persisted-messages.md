# Non-persisted Message Insert

## Description

Messages with persistence disabled are not be stored in the database; however they are still be processed be the rule engine.

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
    "persist": false
}]
```
