# Message Counts Grouped by Multiple Fields

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

    "groupKeys": [
      "entity",
      "type",
      "source",
      "severity"
    ],
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "startDate": "2016-06-20T14:11:57.383Z",
    "endDate": "2016-06-20T14:13:57.383Z"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {
      "severity": "warning",
      "source": "org.apache.hadoop.hdfs.server.datanode.datanode",
      "type": "logger"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:12:00.000Z",
        "v": 1
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {
      "severity": "normal",
      "source": "org.apache.hadoop.hbase.regionserver.storefile$reader",
      "type": "logger"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:12:00.000Z",
        "v": 1
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {
      "severity": "normal",
      "source": "com.axibase.tsd.hbase.coprocessor.messagesstatsendpoint",
      "type": "logger"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:13:00.000Z",
        "v": 1
      }
    ]
  }
]
```