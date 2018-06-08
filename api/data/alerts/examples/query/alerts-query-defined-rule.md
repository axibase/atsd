# Alerts for Defined Rule

## Description

Select alerts for the specified rule.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "rules": [
      "alert-docker"
    ],
    "entity": "*",
    "startDate": "2016-06-29T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "23bb47096a762e1bec0748d06d1cfb96472320badfea070a9b0bf5438c315567",
    "tags": {},
    "repeatCount": 2,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-docker",
    "openDate": "2016-06-29T07:23:09.061Z",
    "lastEventDate": "2016-06-29T07:23:09.063Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 26
  },
  {
    "entity": "3550fd9226aefb3ebc66b8ff70ed3a566e683050fcd61d7a0f69275322906c40",
    "tags": {},
    "repeatCount": 1,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-docker",
    "openDate": "2016-06-29T07:23:04.930Z",
    "lastEventDate": "2016-06-29T07:24:16.356Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 23
  },
  {
    "entity": "5cfb86d67e5fff29fe065906ca208f4346fa89d8e350416e8f43b63f5e4c1f7b",
    "tags": {},
    "repeatCount": 0,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-docker",
    "openDate": "2016-06-29T08:37:39.403Z",
    "lastEventDate": "2016-06-29T08:37:39.403Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 92
  },
  {
    "entity": "7154304acaaa984baa91d90ff5ff4eb9a7386eb338cc4c6837a68b48605e2d6d",
    "tags": {},
    "repeatCount": 1,
    "textValue": " ",
    "metric": "message",
    "severity": "NORMAL",
    "rule": "alert-docker",
    "openDate": "2016-06-29T08:16:48.284Z",
    "lastEventDate": "2016-06-29T08:16:48.285Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": " ",
    "id": 74
  }
]
```