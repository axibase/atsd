# Monthly Change Log: May 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5340 | statistics     | Bug     | Server error raised when accessing statistics page for series with [NaN](https://axibase.com/docs/atsd/sql/#not-a-number-nan) values.
5338 | export             | Bug     | Series tags validation error on the export page.
5337 | client | Feature | Value filter added for [Python Client](https://github.com/axibase/atsd-api-python).
5334 | api-rest       | Bug     | Properties [delete query](https://axibase.com/docs/atsd/administration/data_retention.html#deleting-properties) returns zero counter even after deleting some records.
5333 | client         | Bug     | [Python Client](https://github.com/axibase/atsd-api-python) tests are failing due to time precision.
5327 | UI             | Bug     | Tags are missing on the series list page if entity is specified.
5325 | api-rest       | Bug     | `LIMIT 1` processing error in the series [query](https://axibase.com/docs/atsd/api/data/series/query.html) method.
5324 | rule engine    | Bug     | Change [`randomItem`](https://axibase.com/docs/atsd/rule-engine/functions-random.html#randomitem) function to return the same object type as the argument.
5321 | core           | Feature | Implement **Settings** > **Schema** > **Series Consistency Check** page.
5319 | rule engine    | Bug     | Fix an infinite loop when monitoring rule errors in rule engine itself.
5318 | nmon           | Bug     | [`nmon`](https://axibase.com/docs/atsd/integration/nmon/) property record is stale and is not updated.
5315 | message        | Bug     | Fix incorrect [wildcard](https://axibase.com/docs/atsd/search/entity-search.html#wildcards) match on the message search page.
5313 | client         | Bug     | [Message model](https://github.com/axibase/atsd-api-python#inserting-data) standardized for [Python Client](https://github.com/axibase/atsd-api-python).
5310 | message        | Feature | Modify filter processing for tag wildcards and empty tag values on the message search page.
5309 | api-rest       | Bug     | `NullPointerException` raised on [message insert](https://axibase.com/docs/atsd/api/network/message.html) when one of the tags is set to `null`.
5308 | installation   | Feature | Install [Python 3](https://www.python.org/download/releases/3.0/) on the [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview) by default.
5307 | csv            | Bug     | `NullPointerException` raised on the CSV parser form in test mode.
5306 | api-rest       | Feature | Add revision field to [version](../../api/meta/misc/version.md) endpoint output.
5301 | rule engine    | Feature | Implement [`db_messages`](https://axibase.com/docs/atsd/rule-engine/functions-message.html#db-messages) function.
5286 | rule engine    | Bug     | Custom test message with markdown cannot be sent when testing [Telegram](https://axibase.com/docs/atsd/rule-engine/notifications/telegram.html) webhook.
5282 | sql            | Bug     | [Scheduled SQL](https://axibase.com/docs/atsd/sql/scheduled-sql.html) placeholder fails to correctly resolve placeholders.
5281 | rule engine    | Bug     | [`jsonToLists`](../../rule-engine/functions-table.md#jsontolists) function fails to serialize JSON to columns.
5278 | rule engine    | Feature | Remove common prefix in [`jsonToLists`](https://axibase.com/docs/atsd/rule-engine/functions-table.html#jsontolists) function.
5266 | rule engine    | Bug     | [Webhooks](../../rule-engine/notifications/README.md) are not initialized in imported rules.
5241 | rule engine    | Feature | Implement [rule error](https://axibase.com/docs/atsd/rule-engine/#rule-errors) monitoring.
5234 | api-rest       | Bug     | Change error processing in series [query](https://axibase.com/docs/atsd/api/data/series/query.html) in cases when an exception is raised in the middle of response streaming.
5220 | security       | Feature     | Enforce [SSL certificate](https://axibase.com/docs/atsd/administration/ssl-ca-signed.html) upload restrictions.
5194 | forecast       | Bug     | Fix issues with [forecast](https://axibase.com/docs/atsd/forecasting/) settings form.
5189 | log_aggregator | Bug     | Discard duplicate fields in [Log Aggregator](https://axibase.com/docs/atsd/administration/logging.html).
5150 | sql            | Feature | Implement short ISO formats for `datetime` [literal](../../sql/README.md#interval-condition).
4150 | api-rest       | Feature | Implement series [delete](https://axibase.com/docs/atsd/api/data/series/delete.html) endpoint.
4668 | collectd       | Feature | Refactor [collectd](https://axibase.com/docs/atsd/integration/collectd/) plugin.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5299|core|Bug| [Job configuration](https://github.com/axibase/axibase-collector/#job-types) cloning fails.
5289|json|Feature| Add [Minimum Time](https://github.com/axibase/axibase-collector/blob/master/jobs/json.md#time-fields) filter.
5261|http-pool|Bug|Remove default port from Host header in outgoing `http` requests.
5259|json|Bug|Do not report failure when all responses are not modified.
5255|core|Feature|Add agent header to outgoing `http` requests.
5243|collection|Feature|Add import/export options for [Item Lists](https://github.com/axibase/axibase-collector/blob/master/collections.md#item-lists).
5233|jdbc|Bug| Last entities are cloned when [`JDBC`](https://github.com/axibase/axibase-collector/blob/master/jobs/jdbc.md#jdbc-job) configuration is cloned.
