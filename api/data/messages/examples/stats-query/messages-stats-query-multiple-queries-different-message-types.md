# Multiple Queries for Different Message Types

## Description

## Request

### URI

```elm
POST /api/v1/messages/stats/query
```

### Payload

```json
[
  {
    "entities": "nurswgvml006",
    "metric": "message-count",
    "type": "logger",
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "startDate": "2016-06-18T09:00:00.000Z",
    "endDate": "2016-06-18T10:00:00.000Z",
    "requestId": 1
  },
  {
    "entities": "nurswgvml006",
    "metric": "message-count",
    "type": "backup",
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "startDate": "2016-06-18T00:00:00.000Z",
    "endDate": "2016-06-18T10:00:00.000Z",
    "requestId": 2
  }
]
```

## Response

### Payload

```json
[
  {
    "requestId": "1",
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {
      "type": "logger"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-18T09:00:00.000Z",
        "v": 30
      },
      {
        "d": "2016-06-18T09:10:00.000Z",
        "v": 9
      },
      {
        "d": "2016-06-18T09:20:00.000Z",
        "v": 16
      },
      {
        "d": "2016-06-18T09:30:00.000Z",
        "v": 22
      },
      {
        "d": "2016-06-18T09:40:00.000Z",
        "v": 19
      },
      {
        "d": "2016-06-18T09:50:00.000Z",
        "v": 25
      }
    ]
  },
  {
    "requestId": "2",
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {
      "type": "backup"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-18T03:10:00.000Z",
        "v": 4
      }
    ]
  }
]
```