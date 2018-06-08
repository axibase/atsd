# Query Messages for All Types and Sources

## Description

Retrieve messages for **all** types and sources by omitting these fields in the request or by setting them to an empty string or `null` value.

## Request

### URI

```elm
POST /api/v1/messages/query
```

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "",
    "startDate": "2016-06-17T13:05:00Z",
    "endDate": "2016-06-17T13:10:00.000Z"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "type": "logger",
    "source": "com.axibase.tsd.service.security.userserviceimpl",
    "severity": "NORMAL",
    "tags": {
      "level": "INFO",
      "thread": "qtp1110642100-195",
      "command": "com.axibase.tsd.Server"
    },
    "message": "Load user details for: dataslider-reader",
    "date": "2016-06-17T13:09:56.798Z"
  },
  {
    "entity": "nurswgvml007",
    "type": "security",
    "source": "default",
    "severity": "UNDEFINED",
    "tags": {
      "path": "/var/log/secure"
    },
    "message": "Jun 17 13:07:33 NURSWGVML007 sshd[1525]: pam_unix(sshd:session): session opened for user nmonuser by (uid=0)",
    "date": "2016-06-17T13:07:33.343Z"
  }
]
```
