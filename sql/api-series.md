# SQL Query Series API Endpoint

## Description

This endpoint executes an SQL query and returns the results in the JSON format according to the `/api/series/query` endpoint schema.

The response can be readily consumed by any client that supports series query format, for example by portal widgets.

```ls
[widget]
    type = chart
    timespan = all

[series]
    metric = user_pct
    entity = nurswgvml007
    sql
        SELECT t1.time,
          t2.value/t1.value*100 AS user_pct,
          t1.entity as "entity"
        FROM cpu_busy t1
          JOIN cpu_user t2
        WHERE t1.entity = 'nurswgvml007'
          AND t1.datetime BETWEEN now - 10*minute AND now
        LIMIT 100
    endsql
```

[View in ChartLab](https://apps.axibase.com/chartlab/fc885afe/2/)

## Query Requirements

The query must contain the following columns:

* `time` or `datetime`
* One or more named numeric columns.

All text columns other than entity returned as **series tags**.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `GET` | `/api/sql/series` | - |

### Parameters

| **Name**| **Type** | **Description** |
|:---|:---|:---|
| `sql` | string | **[Required]** Query text. |

:::tip
As an alternative, submit the query as a text payload with the `Content-Type` header set to `text/plain` and other parameters included in the query string.
:::

## Response

* The JSON response contains a list of series with their keys and values.
* The names of numeric columns are returned as metric names.
* If the query contains an `entity` column, its values is returned in the entity column in the response, otherwise the entity name defaults to `sql`.

* Request

```elm
https://atsd.example.org:8443/api/sql/series?q=SELECT%20t1.time%2C%0At2.value%2Ft1.value*100%20AS%20user_pct%2C%0At1.entity%20as%20%22entity%22%0AFROM%20cpu_busy%20t1%0AJOIN%20cpu_user%20t2%0AWHERE%20t1.entity%20%3D%20%27nurswgvml007%27%0AAND%20t1.datetime%20BETWEEN%20now%20-%2010*minute%20AND%20now&requestId=0&timeFormat=milliseconds
```

```json
[{"cache":false,"entity":"nurswgvml007","metric":"user_pct","tags":{},"aggregate":{"types":["DETAIL"]},"startDate":"1970-01-01T00:00:00.001Z","endDate":"9999-12-31T23:59:59.999Z","requestId":"0","timeFormat":"milliseconds"}]
```

* Response

```json
[{"requestId":"0","metric":"user_pct","entity":"nurswgvml007","tags":{},"type":"HISTORY","aggregate":{"type":"DETAIL"},
"data":[{"t":1566742361000,"v":73.33333333333333},{"t":1566742377000,"v":81.81818181818181},{"t":1566742393000,"v":77.77777777777779},{"t":1566742409000,"v":80.0},{"t":1566742425000,"v":73.76371442200667},{"t":1566742441000,"v":75.0},{"t":1566742457000,"v":90.0},{"t":1566742473000,"v":88.90086206896552},{"t":1566742489000,"v":77.77777777777779},{"t":1566742505000,"v":80.0},{"t":1566742521000,"v":63.63636363636363},{"t":1566742537000,"v":80.9699769053118},{"t":1566742553000,"v":69.1785983421251},{"t":1566742569000,"v":66.66666666666666},{"t":1566742585000,"v":85.71428571428571},{"t":1566742601000,"v":50.0},{"t":1566742617000,"v":58.36701697655619},{"t":1566742633000,"v":75.0},{"t":1566742649000,"v":80.0},{"t":1566742665000,"v":61.53846153846153},{"t":1566742681000,"v":85.71428571428571},{"t":1566742697000,"v":89.47911294481692},{"t":1566742713000,"v":71.46776406035666},{"t":1566742729000,"v":84.6153846153846},{"t":1566742745000,"v":75.39735099337749},{"t":1566742761000,"v":57.14285714285714},{"t":1566742777000,"v":69.1785983421251},{"t":1566742793000,"v":68.7078995713411},{"t":1566742809000,"v":75.0},{"t":1566742825000,"v":66.66666666666667},{"t":1566742841000,"v":80.0},{"t":1566742857000,"v":60.0},{"t":1566742873000,"v":75.0},{"t":1566742889000,"v":75.0},{"t":1566742905000,"v":70.0},{"t":1566742921000,"v":81.81818181818183},{"t":1566742937000,"v":58.823529411764696}]}]
```

## Charts Guidelines

* Widget:

  * Set `update-interval = 0 second` to prevent repeat query executions, if the query is expensive.

* Series:

  * Set any entity and any metric in the `[series]` section.
  * Set `timespan = all` to load any data contained in results.

## Examples