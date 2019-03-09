# Series Query: Named Forecast

## Request

```json
[
    {
        "entity": "duckduckgo",
        "metric": "direct.queries",
        "forecastName": "DuckDuckGo1",
        "type": "FORECAST",
        "startDate": "2018-05-01T00:00:00Z",
        "endDate": "2018-07-30T00:00:00Z"
    }
]
```

## Response

```json
[
    {
        "entity": "duckduckgo",
        "metric": "direct.queries",
        "type": "FORECAST",
        "aggregate": {
            "type": "DETAIL"
        },
        "forecastName": "DuckDuckGo1",
        "meta": {
            "timestamp": "2018-06-26T00:00:00Z",
            "averagingInterval": 86400000,
            "alpha": 0.1,
            "beta": 0.2,
            "gamma": 0,
            "period": "WEEKLY",
            "stdDev": 874884.3451501856
        },
        "data": [
            {
                "d": "2018-06-17T00:00:00.000Z",
                "v": 9497228.587367011
            },
            {
                "d": "2018-06-18T00:00:00.000Z",
                "v": 9517253.496233052
            },
            {
                "d": "2018-06-19T00:00:00.000Z",
                "v": 9227410.099153783
            },
            {
                "d": "2018-06-20T00:00:00.000Z",
                "v": 8481158.872775367
            },
            {
                "d": "2018-06-21T00:00:00.000Z",
                "v": 8921320.873833349
            },
            {
                "d": "2018-06-22T00:00:00.000Z",
                "v": 10065887.391646788
            },
            {
                "d": "2018-06-23T00:00:00.000Z",
                "v": 9989231.479620669
            },
            {
                "d": "2018-06-24T00:00:00.000Z",
                "v": 0
            }
        ]
    }
]
```
