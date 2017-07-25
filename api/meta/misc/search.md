# Search

## Description

Search series by an expression.

## Request

| **Method** | **Path**         |
| :--------- | :--------------- |
| GET        | `/api/v1/search` |

### Query Parameters:

| **Parameter** | **Type** | **Description**                                                                                   |
| :------------ | :------- | :------------------------------------------------------------------------------------------------ |
| expression    | string   | **[Required]** Search query according to [search expression reference](../../../search/README.md) |
| length        | number   | Number of found records, returned from server                                                     |

## Response

### Fields

| **Name**        | **Type** | **Description**                                                            |
| :-------------- | :------- | :------------------------------------------------------------------------- |
| recordsFiltered | number   | Number of series matched given expression                                  |
| recordsTotal    | number   | Total number of series                                                     |
| data            | array    | Array of rows, describing series info  (see [Series Info](#series%20info)) |

### Series Info

Series info object is an array, containing info in following order:

|   # | **Type** | **Description**                                        |
| --: | :------- | :----------------------------------------------------- |
|   1 | string   | Metric name                                            |
|   2 | object   | Key-Value pairs of metric tags                         |
|   3 | string   | Entity name                                            |
|   4 | object   | Key-Value pairs of entity tags                         |
|   5 | object   | Key-Value pairs of series tags                         |
|   6 | number   | Search result relevance score _**TODO** WHAT IS THIS?_ |
|   7 | string   | Metric name                                            |
|   8 | string   | Entity name                                            |

## Example

Requesting first 10 series, matching _java\*_.

### Request

#### URI

```elm
GET /api/v1/search?expression=java*&length=10
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/search?expression=java*&length=10 \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
{
    "recordsTotal": 496,
    "recordsFiltered": 273,
    "query": "contents:java*",
    "data": [
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.findKeysForMetric"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.web.api.v1.series.query"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.web.portals.config.widgets_1_config"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.hbase.dao.TimeSeriesDaoImpl.findTags"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.web.portal.1_xhtml"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.service.TimeSeriesCallbackImpl.processRow"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.service.TimeSeriesServiceImpl.getTimeSeries"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.web.metrics.cache_used_percent.series"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.web.rules.all-alerts_xhtml"},1.0,null,null],
        ["java_method_invoke_average",{},"atsd",{},{"host":"LOCALHOST","name":"com.axibase.tsd.hbase.dao.EntityDaoImpl.findEntities"},1.0,null,null]
    ]
}
```
