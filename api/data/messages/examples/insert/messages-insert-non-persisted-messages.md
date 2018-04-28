# Non-persisted Message Insert

## Description

Messages with persistence disabled will not be stored in the database; however they will still be processed be the rule engine.

## Request

### URI
```elm
POST https://atsd_hostname:8443/api/v1/messages/insert
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
