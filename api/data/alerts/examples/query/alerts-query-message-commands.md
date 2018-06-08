# Alerts for Message Commands

## Description

Select alerts that were generated for `message` commands.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "metrics": [
      "message"
    ],
    "entity": "*",
    "startDate": "2016-06-25T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "0cd8b414e88003477b325a51d5d40e0d2c862da07fe7571f07dd4c6037636c7a",
    "tags": {},
    "repeatCount": 0,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-app",
    "openDate": "2016-06-28T12:18:13.172Z",
    "lastEventDate": "2016-06-28T12:18:13.172Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 572
  },
  {
    "entity": "5a24adbbae1f4239fda11b55812a384989ce90eb0d22fa2aa6a440f8bec2cb62",
    "tags": {},
    "repeatCount": 0,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-docker",
    "openDate": "2016-06-28T10:01:06.210Z",
    "lastEventDate": "2016-06-28T10:01:06.210Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 518
  }
]
```