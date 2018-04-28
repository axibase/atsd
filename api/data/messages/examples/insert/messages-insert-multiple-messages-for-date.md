# Multiple Messages for Date Insert

## Description

Both messages will be persisted since the date is different.

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
    "severity": "MAJOR",
    "source": "atsd",
    "date": "2016-06-13T09:15:00Z"
},{
    "entity": "nurswgvml007",
    "type": "application",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "severity": "MAJOR",
    "source": "atsd",
    "date": "2016-06-13T09:12:00Z"
}]
```