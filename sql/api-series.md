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
* If the query contains an `entity` column, it is returned as entity column in the response, otherwise a default 'sql' entity is set.

* Request

```json

```

* Response

```json

```

## Charts Guidelines

* Widget:

  * Set `update-interval = 0 second` to prevent repeat query executions, if the query is expensive.

* Series:

  * Set any entity and any metric in the `[series]` section.
  * Set `timespan = all` to load any data contained in results.

## Examples