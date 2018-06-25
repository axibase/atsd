# Max Value Time Aggregator

## Description

Returns minimum and maximum values, as well as timestamps, when these values occurred for the first time in each period.

* [ChartLab](https://apps.axibase.com/chartlab/2350319f)
* Source data
  * [CSV](https://duckduckgo.com/traffic_data/direct.csv)
  * [HTML](https://duckduckgo.com/traffic.html)

## Request

```json
[
    {
        "entity": "duckduckgo",
        "metric": "direct.queries",
        "aggregate": {
          "types": ["MAX", "MAX_VALUE_TIME", "MIN", "MIN_VALUE_TIME"],
          "period": {"count": 1, "unit": "YEAR"}
        },
        "startDate": "2016-01-01T00:00:00Z",
        "endDate": "now"
    }
]
```

## Response

```json
[
  {
    "entity":"duckduckgo",
    "metric":"direct.queries",
    "tags":{

    },
    "type":"HISTORY",
    "aggregate":{
      "type":"MAX",
      "period":{
        "count":1,
        "unit":"YEAR",
        "align":"CALENDAR"
      }
    },
    "data":[
      {
        "d":"2016-01-01T00:00:00.000Z",
        "v":1.2657536E7
      }
    ]
  },
  {
    "entity":"duckduckgo",
    "metric":"direct.queries",
    "tags":{

    },
    "type":"HISTORY",
    "aggregate":{
      "type":"MAX_VALUE_TIME",
      "period":{
        "count":1,
        "unit":"YEAR",
        "align":"CALENDAR"
      }
    },
    "data":[
      {
        "d":"2016-01-01T00:00:00.000Z",
        "v":1463961600000
      }
    ]
  },
  {
    "entity":"duckduckgo",
    "metric":"direct.queries",
    "tags":{

    },
    "type":"HISTORY",
    "aggregate":{
      "type":"MIN",
      "period":{
        "count":1,
        "unit":"YEAR",
        "align":"CALENDAR"
      }
    },
    "data":[
      {
        "d":"2016-01-01T00:00:00.000Z",
        "v":8530739.0
      }
    ]
  },
  {
    "entity":"duckduckgo",
    "metric":"direct.queries",
    "tags":{

    },
    "type":"HISTORY",
    "aggregate":{
      "type":"MIN_VALUE_TIME",
      "period":{
        "count":1,
        "unit":"YEAR",
        "align":"CALENDAR"
      }
    },
    "data":[
      {
        "d":"2016-01-01T00:00:00.000Z",
        "v":1457740800000
      }
    ]
  }
]
```

* `MAX` of `12657536` reached at `MAX_VALUE_TIME 1463961600000 = 2016-05-23T00:00:00.000Z`.
* `MIN` of `8530739` reached at `MIN_VALUE_TIME 1457740800000 = 2016-03-12T00:00:00.000Z`.
