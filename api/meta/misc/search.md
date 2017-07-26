# Search

## Description

Full text series search.

Refer to [expression reference](../../../search/README.md) for syntax, available fields and operators.

## Request

| **Method** | **Path**         |
| :--------- | :--------------- |
| GET        | `/api/v1/search` |

### Query Parameters:

| **Parameter** | **Type** | **Description**                                                                                   |
| :------------ | :------- | :------------- |
| query  | string   | **[Required]** Search query according to [expression reference](../../../search/README.md). |
| limit  | number   | Maximum number of records to be returned by the server. Default: 100. <br> Specity `limit=0` to return all matching records. |
| offset | number   | Number of records to skip before beginning to return data. |
| metricTags | string   | Comma-separated list of metric tag names to be included in the response.<br>For example, `metricTags=OS,location`. <br>Specify `metricTags=*` to include all metric tags. |
| metricFields | string   | Comma-separated list of [metric field names](../metric/list.md#fields) to be included in the response.<br>For example, `metricFields=dataType,units`. <br>Specify `metricFields=*` to include all metric fields. |
| entityTags | string   | Comma-separated list of entity tag names to be included in the response.<br>For example, `entityTags=OS,location`. <br>Specify `entityTags=*` to include all entity tags. |
| entityFields | string   | Comma-separated list of [entity field names](../entity/list.md#fields) to be included in the response.<br>For example, `entityFields=timeZone,interpolate`. <br>Specify `entityFields=*` to include all entity fields. |

## Response

### Fields

| **Name**        | **Type** | **Description**                              |
| :-------------- | :------- | :------------------------------------------- |
| recordsTotal    | number   | Total number of series in the database as of last index update.  |
| recordsFiltered | number   | Total number of series that matched the specified expression. |
| time            | number   | Query execution time, in milliseconds. |
| data            | array    | Array of [series records](#series-record). |

### Series Record

The record contains series identifier as well as entity and metric fields in the following order:

|   # | **Type** | **Description**                                        |
| --: | :------- | :----------------------------------------------------- |
|   1 | string   | Metric name                                            |
|   2 | string   | Metric label                                           |
|   3 | object   | Metric fields: key-value pairs                         |
|   4 | object   | Metric tags: key-value pairs                           |
|   5 | string   | Entity name                                            |
|   6 | string   | Entity label                                           |
|   7 | object   | Entity fields: key-value pairs                         |
|   8 | object   | Entity tags: key-value pairs                           |
|   9 | object   | Series tags: key-value pairs                           |
|  10 | number   | Relevance score                                        |

> Tags and fields without a value are not included in the response, even if they are specified in the request.

## Example

Find series records, matching `inflation*`. Return 2 records at most.

### Request

#### URI

```elm
GET /api/v1/search?query=inflation*&limit=2&metricTags=*&metricFields=units,dataType&entityTags=*&entityFields=timeZone
```

#### Payload

None.

#### curl

```elm
curl 'https://atsd_host:8443/api/v1/search?query=inflation*&limit=2&metricTags=*&metricFields=units,dataType&entityTags=*&entityFields=timeZone' \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
{
  "query": "contents:inflation.cpi.categories*",
  "recordsTotal": 496621,	
  "recordsFiltered": 20,
  "time": 136,
  "data": [
    [
      "inflation.cpi.categories.price",
      "CPI - Non-negotiable",
      {
        "units": "million",
        "dataType": "LONG"
      },			
      {
        "pricebase": "Current prices",
        "seasonaladjustment": "Seasonally Adjusted",
        "source": "CBS"
      },
      "fed",
      "U.S. FED",
      {
        "timeZone": "US/Eastern"
      },				
      {
        "source": "FRED"
      },
      {
        "category": "Health"
      },
      1.5
    ],
    [
      "inflation.cpi.categories.price",
      "CPI - Non-negotiable",
      {
        "units": "million",
        "dataType": "LONG"
      },			
      {
        "pricebase": "Current prices",
        "seasonaladjustment": "Seasonally Adjusted",
        "source": "CBS"
      },
      "fed",
      "U.S. FED",
      {
        "timeZone": "US/Eastern"
      },				
      {
        "source": "FRED"
      },
      {
        "category": "Energy"
      },
      1.5
    ]
  ]
}
```

* Series object description:

```js
    [
      // metric name
      "inflation.cpi.categories.price",
      
      // metric label
      "CPI - Non-negotiable",
      
      // metric fields
      {
        "units": "million",
        "dataType": "LONG"
      },
      
      // metric tags
      {
        "pricebase": "Current prices",
        "seasonaladjustment": "Seasonally Adjusted",
        "source": "CBS"
      },
      
      // entity name
      "fed",
      
      // entity label
      "U.S. FED",
      
      // entity fields
      {
        "timeZone": "US/Eastern"
      },
      
      // entity tags
      {
        "source": "FRED"
      },
      
      // series tags
      {
        "category": "Health"
      },
      
      // relevance score
      1.5
    ]
```
