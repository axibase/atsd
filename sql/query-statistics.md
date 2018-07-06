# Query Statistics

The **Query Statistics** page displays the most recent **1,000** queries submitted to the database.

![](./images/query-statistics-page.png)

The list of queries is reset each time the database is restarted.

![](./images/query-statistics.png)

## Filters

The page contains several drop-down lists to filter queries.

### Status

Filter queries for the execution status:

* `New`: Submitted queries waiting to be executed.
* `Running`: The query is executing.
* `Completed`: The query is finished.
* `Error`: The query is unable to complete because of a problem.
* `Cancelled`: The query was stopped by the client.

### Source

Filter queries by the origin of the query.

* `api`: Queries received by the [`/api/sql`](api.md) endpoint.
* `console`: Queries executed from the [**SQL Console**](./sql-console.md).
* `scheduled`: [Scheduled](./scheduled-sql.md) queries executed by the database.
* `rule-engine`: Queries executed by the [`executeSqlQuery()`](../rule-engine/functions-sql.md#executesqlquery) function in the rule engine.

### Elapsed Time

Filter queries based on the execution time, measured in seconds from the time received by the database.

* `>` : Greater than.
* `<=` : Less than or equal to.

### Query

Display queries if the SQL statement _contains_ the specified substring. The filter accepts single or multi-line text.

![](./images/all-examples.png)

To exclude queries, preface the substring with the negation operator (`!`).

This set of queries contains all those with `Completed` status, regardless of **Source**. Exclude those queries which contain certain [syntax](./README.md#syntax) with `!` negation.

![](./images/exclude-metric.png)

All queries with contain `FROM` metric `a028.m` are excluded.

![](./images/excluded-results3.png)

General expressions can be used as well. For example, exclude all queries which contain the `LOOKUP` function.

![](./images/exclude-lookup.png)

Exclude all queries which contain a `LIMIT` statement.

![](./images/exclude-limit.png)

### Source Details

Display queries if the job name or rule name contains the specified substring. Supported if the **Source** is `scheduled` or `rule-engine`.

To exclude queries for a specific job or rule, preface the text with the negation operator (`!`).

![](./images/example-query.png)

The above set of queries are all `scheduled` with status `Completed`. Each of the queries contains information in the `Source Details` column about the rule which triggered the query. Unwanted rules can be excluded using `!` negation syntax.

![](./images/exclude-alert.png)

Exclude all `ALERT` queries.

![](./images/exclude-result.png)

### User Name

Display queries based on the user who performed them.

To exclude queries for a particular username, preface the text with the negation operator (`!`).

![](./images/completed-console.png)

The above set of queries are all `Completed` from the `console` by different users. Exclude certain users with `!` negation syntax

![](./images/exclude-user.png)

Exclude user `sergei.rodionov` from search results.

![](./images/exclude-results2.png)