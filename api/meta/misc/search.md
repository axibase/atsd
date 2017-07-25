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
| query  | string   | **[Required]** Search query according to [expression reference](../../../search/README.md) |
| limit  | number   | Maximum number of records to be returned by the server. Default: 0 (no limit). |
| offset | number   | Number of records to skip before beginning to return data. |

## Response

### Fields

| **Name**        | **Type** | **Description**                              |
| :-------------- | :------- | :------------------------------------------- |
| recordsTotal    | number   | Total number of series in the database as of last index update.  |
| recordsFiltered | number   | Total number of series that matched the specified expression. |
| data            | array    | Array of [series records](#series%20record)) |

### Series Record

The record contains series identifier as well as entity and metric fields in the following order:

|   # | **Type** | **Description**                                        |
| --: | :------- | :----------------------------------------------------- |
|   1 | string   | Metric name                                            |
|   2 | object   | Metric tags: key-value pairs                           |
|   3 | string   | Entity name                                            |
|   4 | object   | Entity tags: key-value pairs                           |
|   5 | object   | series tags: key-value pairs                           |
|   6 | number   | Relevance score                                        |
|   7 | string   | Entity label                                           |
|   8 | string   | Metric label                                           |

## Example

Find series records, matching `inflation*`. Return 10 records at most.

### Request

#### URI

```elm
GET /api/v1/search?query=inflation*&limit=10
```

#### Payload

None.

#### curl

```elm
curl 'https://atsd_host:8443/api/v1/search?query=inflation*&limit=10' \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
{
	"recordsTotal": 496621,
	"recordsFiltered": 20,
	"time": 136,
	"query": "contents:inflation.cpi.categories*",
	"data": [
		["inflation.cpi.categories.price", {
			"pricebase": "Current prices",
			"seasonaladjustment": "Seasonally Adjusted",
			"source": "CBS"
		}, "fed", {}, {
			"category": "Health"
		}, 1.5, "FRED", "CPI - Non-negotiable"],
		["inflation.cpi.categories.price", {
			"pricebase": "Current prices",
			"seasonaladjustment": "Seasonally Adjusted",
			"source": "CBS"
		}, "fed", {}, {
			"category": "Miscellaneous"
		}, 1.2, "FRED", "CPI - Non-negotiable"],
		["inflation.cpi.categories.price", {
			"pricebase": "Current prices",
			"process": "Bank of Israel - Research",
			"seasonaladjustment": "Seasonally Adjusted",
			"source": "CBS"
		}, "fed", {}, {
			"category": "Food (excl. fruit & veg.)"
		}, 1.0, "FRED", "CPI - Non-negotiable"]
	]
}
```
