# Monthly Change Log: May 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
| 5340 | statistics     | Bug     | Server error for metrics with [NaN](https://axibase.com/docs/atsd/sql/#not-a-number-nan).
| 5338 | UI             | Bug     | Export form issue.
| 5337 | client | Feature | Value filter added for [Python Client](https://github.com/axibase/atsd-api-python). Support for [Rate Processor](https://axibase.com/docs/atsd/api/data/series/rate.html#rate-period) without defined period.
| 5334 | api-rest       | Bug     | [Properties delete query](https://axibase.com/docs/atsd/administration/data_retention.html#deleting-properties) returns `0` after deletion.
| 5333 | client         | Bug     | Microsecond precision fails tests for [Python Client](https://github.com/axibase/atsd-api-python).
| 5327 | UI             | Bug     | Missing tags if entity is specified.
| 5325 | api-rest       | Bug     | Limit 1 processing error for [series query](https://axibase.com/docs/atsd/api/data/series/insert.html).
| 5324 | rule engine    | Bug     | [`randomItem`](https://axibase.com/docs/atsd/rule-engine/functions-random.html#randomitem) [Rule Engine](https://axibase.com/docs/atsd/rule-engine/) function returns similar output as input.
| 5321 | core           | Feature | Data consistency page implemented at **Settings** > **Schema** > **Series Consistency Check**.
| 5319 | rule engine    | Bug     | Infinite loop closed.
| 5318 | nmon           | Bug     | Fix [`nmon`](https://axibase.com/docs/atsd/integration/nmon/) property record update.
| 5315 | message        | Bug     | Fix incorrect [wildcard](https://axibase.com/docs/atsd/search/entity-search.html#wildcards) match.
| 5313 | client         | Bug     | [Message model](https://github.com/axibase/atsd-api-python#inserting-data) refactored for [Python Client](https://github.com/axibase/atsd-api-python).
| 5310 | message        | Feature | Filter modified when tag value is not specified in [Messages: Query](https://axibase.com/docs/atsd/api/data/messages/query.html).
| 5309 | api-rest       | Bug     | `NullPointerException` on [message insert](https://axibase.com/docs/atsd/api/network/message.html) with [`NULL`](https://axibase.com/docs/atsd/sql/#null) tag.
| 5308 | installation   | Support | [Python3](https://www.python.org/download/releases/3.0/) added to [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview) image.
| 5307 | csv            | Bug     | Repair `NullPointerException` in `Test` mode.
| 5306 | api-rest       | Feature | Add [fields](https://axibase.com/docs/atsd/api/data/) to `/api/v1/version`.
| 5304 | installation   | Feature | Simplify default [mail.properties parameters](https://axibase.com/docs/atsd/administration/mail-client.html#settings) for [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview).
| 5301 | rule engine    | Feature | Implement [`db_messages`](https://axibase.com/docs/atsd/rule-engine/functions-message.html#db-messages) function in [Rule Engine](https://axibase.com/docs/atsd/rule-engine/).
| 5294 | api-rest       | Bug     | Clarified [expression usage](https://axibase.com/docs/atsd/api/meta/entity/metrics.html#query-parameters) for list of metrics collected by an entity.
| 5286 | rule engine    | Bug     | Enabled custom message for [Telegram](https://axibase.com/docs/atsd/rule-engine/notifications/telegram.html) [test](https://axibase.com/docs/atsd/rule-engine/notifications/telegram.html#testing-notification-rule).
| 5282 | sql            | Bug     | Support [SQL Scheduler](https://axibase.com/docs/atsd/sql/scheduled-sql.html) [placeholder](https://axibase.com/docs/atsd/rule-engine/placeholders.html) resolution.
| 5281 | rule engine    | Bug     | JSON serialized to columns instead of rows.
| 5280 | installation   | Feature | `--env` variable added to [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview) to control [Collector](https://github.com/axibase/axibase-collector/) start.
| 5278 | rule engine    | Feature | Generic prefix removed from [`jsonToList`](https://axibase.com/docs/atsd/rule-engine/functions-table.html#jsontolists) rows.
| 5276 | core           | Bug     | [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview) `--env` variable substitution in archives.
| 5266 | rule engine    | Bug     | Support [Rule Engine](https://axibase.com/docs/atsd/rule-engine/) [notifications](https://axibase.com/docs/atsd/rule-engine/notifications/#creating-notifications) loading in imported [rules](https://github.com/axibase/atsd-use-cases/blob/master/how-to/shared/import-rule.md).
| 5241 | rule engine    | Feature | Implemented monitoring for [rule errors](https://axibase.com/docs/atsd/rule-engine/#rule-errors).
| 5234 | api-rest       | Bug     | [Series: Query](https://axibase.com/docs/atsd/api/data/series/query.html) drops partially-loaded dataset upon exception.
| 5220 | security       | Bug     | Modify [certificate upload](https://axibase.com/docs/atsd/administration/ssl-ca-signed.html) restrictions.
| 5194 | forecast       | Bug     | [Data Forecasting](https://axibase.com/docs/atsd/forecasting/): several issues repaired.
| 5189 | log_aggregator | Bug     | Handing for duplicate fields in [Log Aggregator](https://axibase.com/docs/atsd/administration/logging.html).
| 5150 | sql            | Feature | Short ISO format implemented for `datetime` [literal](https://axibase.com/docs/atsd/sql/#literals).
| 5019 | UI             | Feature | Improve user interface.
| 4150 | api-rest       | Feature | Implement [Series: Delete](https://axibase.com/docs/atsd/api/data/series/delete.html) method.
| 4668 | collectd       | Support | [Collectd](https://axibase.com/docs/atsd/integration/collectd/ ) [plugin](https://axibase.com/docs/atsd/integration/collectd/#configuration) refactoring.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5299|core|Bug| Repair [Job Configuration](https://github.com/axibase/axibase-collector/#job-types) cloning.
5289|json|Feature| [Minimum Time](https://github.com/axibase/axibase-collector/blob/master/jobs/json.md#time-fields) filter added for [JSON job](https://github.com/axibase/axibase-collector/blob/master/jobs/json.md#json-job).
5261|http-pool|Bug|Remove default port from Host header in outgoing `http` requests.
5259|json|Bug|Repair [JSON job](https://github.com/axibase/axibase-collector/blob/master/jobs/json.md#json-job) failure if no requests are changed.
5255|core|Feature|Agent header added in outgoing `http` requests.
5243|collection|Feature|Add import/export options to [Item List](https://github.com/axibase/axibase-collector/blob/master/collections.md#item-lists ).
5233|jdbc|Bug| Last entities are cloned when [`JDBC`](https://github.com/axibase/axibase-collector/blob/master/jobs/jdbc.md#jdbc-job) configuration is cloned.