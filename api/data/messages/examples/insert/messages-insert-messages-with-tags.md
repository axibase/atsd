# Insert Message with Tags

## Description

Message primary key is entity, type, source, and time. Tags and message are extended fields.

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
	"source": "atsd",
    "message": "NURSWGVML007 ssh: error: connect_to localhost port 8881: failed.",
    "tags": {"path": "/", "name": "sda"}
}]
```
