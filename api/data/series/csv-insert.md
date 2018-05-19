# Series: CSV Insert

## Description

Insert series values for the specified entity and series tags in CSV format.

The CSV header should include a leading time column and one or multiple numeric metric columns for the same entity and tag combination.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/series/csv/{entity}?[&{tag-name}={tag-value}]` | `text/csv` |

### Parameters

| **Name** | **In** | **Description** |
|:---|:---|:---|
| `entity` | path | **[Required]** Entity name. |
| `tag` | query | `tag=value` parameter pairs. |

### Payload

* Payload is plain text in CSV format containing a header line and data rows.
* The last line in the file must be terminated with a line feed.
* The header must begin with a `time` or `date` column, followed by at least one metric column containing numeric values.
* Entity and Metric names containing space characters will be normalized by replacing the space character with an underscore.
* Time must be specified in Unix milliseconds if the `time` column is used, and in ISO format if the `date` column is used.
* Separator must be comma.
* It is recommended that samples are sorted by time in ascending order.

#### Unix millisecond format

```ls
time,metric-1,metric-2,...,metric-N
1423139581000,5.0,2.1,...,10.4
1423139592016,5.0,2.1,...,10.4
```

#### ISO format

```ls
date,metric-1,metric-2,...,metric-N
2016-05-16T00:14:36.000Z,5.0,2.1,...,10.4
2016-05-16T00:14:45.012Z,5.0,2.1,...,10.4
```

## Response

### Fields

None.

### Errors

* "Empty first row" if no rows are found.
* "CSV must have at least 2 columns" if header contains less than 2 columns.
* "First header must be 'time' (specified in Unix milliseconds) or 'date' (ISO 8601 date)" if the name of the first column in the header is neither `time` nor `date`.
* "No data" if the number of data rows is 0.

## Example

### Request

#### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007
```

#### Payload

```ls
time,cpu_user,cpu_system,waitio
1423139581000,12.4,1.4,0
1423139592016,16.0,4.2,0
```

#### curl

```elm
curl https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007 \
 --insecure --include --user {username}:{password} \
 --header "Content-Type: text/csv" \
 --request POST \
 --data-binary $'date,lx.cpu_busy\n2016-05-21T00:00:00Z,12.45\n2016-05-21T00:00:15Z,10.8\n'
```

> `--data-binary $` is used to prevent `curl` from dropping line feed characters.

```elm
curl https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007 \
 --insecure --include --user {username}:{password} \
 --header "Content-Type: text/csv" \
 --request POST \
 --data-binary @file.csv
```

### Response

None.

## Java Example

* [Series CSV Insert](examples/DataApiSeriesCsvInsertExample.java)

## Additional Examples
