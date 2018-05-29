# Getting Started: Part 3

## Export Data

Open the **Data > Export** page.

![](./resources/getting-started-3_1.png)

Complete the form to download data for the `my-entity` and `my-metric` into a CSV file as well as to displayed it as HTML.

![](./resources/getting-started-3_5.png)

## Execute API Requests

Experiment with [Data API](../api/data/README.md) by executing sample [series query](../api/data/series/query.md) requests using the built-in API client.

Open **Data > API Client** page.

![](./resources/getting-started-3_2.png)

Select _Series > Query Detailed_ template.

![](./resources/getting-started-3_3.png)

Adjust `startDate` and `endDate` fields, replace `entity` and `metric` field values accordingly.

* Request

```json
[{
  "startDate": "2018-02-26T00:00:00Z",
  "endDate":   "2018-02-28T00:00:00Z",
  "entity": "my-entity",
  "metric": "my-metric"
}]
```

* Response

```json
 [
  {
    "entity": "my-entity",
    "metric": "my-metric",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      { "d": "2018-02-26T20:10:00.000Z", "v": 15 },
      { "d": "2018-02-26T20:20:00.000Z", "v": 10.8 },
      { "d": "2018-02-26T20:30:00.000Z", "v": 24 }
    ]
  }
]
```

![](./resources/getting-started-3_4.png)

[Continue to Next Page](getting-started-4.md).
